import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:pub_semver/src/version.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:yaml/yaml.dart';

import 'diff.dart';

final regex = RegExp(r"<code>(.*)<\/code>", dotAll: true);

void main(List<String> arguments) async {
  final isCI = Platform.environment["CI"] == "true";

  final argParser = ArgParser()
    ..addFlag(
      "dry-run",
      defaultsTo: true,
    )
    ..addFlag(
      "verbose",
      abbr: "v",
      negatable: false,
    )
    ..addFlag(
      "help",
      abbr: "h",
      negatable: false,
    )
    ..addFlag(
      "force",
      abbr: "f",
      negatable: false,
    );
  final parsed = argParser.parse(arguments);
  final dry = parsed["dry-run"] as bool;
  final verbose = parsed["verbose"] as bool;
  final force = parsed["force"] as bool;
  if (parsed["help"]) {
    print(argParser.usage);
    exit(0);
  }

  final origin = isCI ? Origin.ci : Origin.manually;

  final date = DateFormat.yMMMMd().add_Hms().format(DateTime.now().toUtc()) + " UTC";

  final proj = Directory(parsed.rest.first);
  final pubspec = WritableFile(path.join(proj.path, "pubspec.yaml"), dry);
  final file = WritableFile(path.join(proj.path, "lib", "all.yaml"), dry);
  final dataFile = WritableFile(path.join(proj.path, "data.json"), dry);
  final changelog = WritableFile(path.join(proj.path, "CHANGELOG.md"), dry);

  if (!pubspec.existsSync()) throw Exception("$file not found");
  if (!file.existsSync()) throw Exception("$file not found");
  if (!dataFile.existsSync()) throw Exception("$dataFile not found");
  if (!changelog.existsSync()) throw Exception("$changelog not found");

  print("[i] Target project: ${proj.path}");

  // ===== PARSE pubspec.yaml =====
  final pusbpecString = await pubspec.readAsString();

  final parsedPubspec = Pubspec.parse(pusbpecString);
  final ver = parsedPubspec.version;
  if (ver == null) throw Exception("Pubspec.yaml doesn't have any version.");
  final Version nextVersion = ver.nextPatch;

  final data = jsonDecode(await dataFile.readAsString()) as Map;
  final lastHash = data["hash"];

  // ===== EDIT lib/all.yaml =====

  final url = Uri.parse("https://dart-lang.github.io/linter/lints/options/options.html");
  final res = await http.get(url);

  final match = regex.firstMatch(res.body)?.group(1);
  if (match == null) throw Exception("Unable to parse $url");
  final currentHash = base64Encode(sha256.convert(utf8.encode(match)).bytes);
  print("[i] Hashes:");
  print("    Last content hash: $lastHash");
  print("    Current content hash: $currentHash");

  if (lastHash == currentHash) {
    if (force) {
      print("[i] Content is identical but we are forcing...");
    } else {
      print("\n[i] No changes in content, quitting...");
      exit(0);
    }
  }
  final string = """
  # Generated ${origin.contextual} on $date

$match
  """;

  if (verbose) {
    print("YAML: ");
    print("=" * 20);
    print(string);
  }

  final fileYaml = loadYaml(string);

  try {
    if (fileYaml["linter"]["rules"] == null) {
      throw FormatException("Invalid yaml file", fileYaml);
    }
  } on NoSuchMethodError {
    throw FormatException("Invalid yaml file", fileYaml);
  }

  final diff = Diff.compareYAML(loadYaml(await file.readAsString()), fileYaml);
  print("[i] Diff:");
  print("    ${diff.removedRules.length} removed");
  print("    ${diff.addedRules.length} added");

  // ===== EDIT pubspec.yaml =====

  final updated = pusbpecString.replaceFirst(
    "version: ${ver.toString()}",
    "version: ${nextVersion.toString()}",
  );

  final updatedPub = Pubspec.parse(updated);
  if (updatedPub.version != nextVersion) {
    throw Exception("Failed to correctly update version");
  }

  if (verbose) print(updated);

  final newData = JsonEncoder.withIndent(" ").convert({
    'hash': currentHash,
    'origin': origin.toString(),
    'last_generated': date,
  });

  print("[*] Writing to files...");

  await file.writeAsString(string);
  await pubspec.writeAsString(updated);
  await dataFile.writeAsString(newData);
  await changelog.writeAsString(diff.genNewChangelog(await changelog.readAsString(), nextVersion));
  print("    Done writing !");

  final didWriteFiles = File(".did_write");
  if (!dry) {
    await didWriteFiles.create();
  } else {
    if (didWriteFiles.existsSync()) await didWriteFiles.delete();
  }

  exit(0);
}

class Origin {
  const Origin._(this.contextual, this._value);
  final String contextual;
  final String _value;

  static const manually = Origin._("manually", "user-generated");
  static const ci = Origin._("by CI", "CI");

  @override
  String toString() => _value;
}

class WritableFile {
  WritableFile(String path, this.dryRun) : file = File(path);
  final File file;
  final bool dryRun;

  bool existsSync() => file.existsSync();

  Future<void> writeAsString(String content) async {
    if (dryRun) {
      print("[i] Dry run, skipped writing to ${file.path}");
      print("=" * 10 + " content " + "=" * 10);
      print(content);
      print("=" * 20);
    } else {
      await file.writeAsString(content);
    }
  }

  Future<String> readAsString() {
    return file.readAsString();
  }
}
