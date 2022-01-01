import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:yaml/yaml.dart';

final regex = RegExp(r"<code>(.*)<\/code>", dotAll: true);

void main(List<String> arguments) async {
  bool didWrite = false;
  final isCI = Platform.environment["CI"] == "true";

  final argParser = ArgParser()
    ..addFlag(
      "dry-run",
      abbr: "n",
      defaultsTo: !isCI,
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
  if (!isCI) {
    print("Because we are not CI, defaults to dry-run");
  }
  final origin = () {
    if (isCI) {
      return Origin.ci;
    }
    return Origin.manually;
  }();

  final date =
      DateFormat.yMMMMd().add_Hms().format(DateTime.now().toUtc()) + " UTC";

  final proj = Directory(parsed.rest.first);
  final pubspec = File(path.join(proj.path, "pubspec.yaml"));
  final file = File(path.join(proj.path, "lib", "all.yaml"));
  final dataFile = File(path.join(proj.path, "data.json"));
  final changelog = File(path.join(proj.path, "CHANGELOG.md"));

  if (!pubspec.existsSync()) throw Exception("$pubspec not found");
  if (!file.existsSync()) throw Exception("$file not found");
  if (!changelog.existsSync()) throw Exception("$changelog not found");

  print("[i] Target project: ${proj.path}");

  // ===== PARSE pubspec.yaml =====
  final pusbpecString = await pubspec.readAsString();

  final parsedPubspec = Pubspec.parse(pusbpecString);
  final ver = parsedPubspec.version;
  if (ver == null) throw Exception("Pubspec.yaml doesn't have any version.");
  final nextVersion = ver.nextPatch;

  final data = jsonDecode(await dataFile.readAsString()) as Map;
  final lastHash = data["hash"];

// ===== PARSE pubspec.yaml =====
  final changelogString = await changelog.readAsString();

  // ===== EDIT lib/all.yaml =====

  final url = Uri.parse(
      "https://dart-lang.github.io/linter/lints/options/options.html");
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
  if (dry) {
    print("    Dry run, skipped.");
  } else {
    await file.writeAsString(string);
    await pubspec.writeAsString(updated);
    await dataFile.writeAsString(newData);
    didWrite = true;
    print("    Done writing !");
  }

  // ===== WRITE CHANGELOG.md =====
  print("[*] Checking git diff...");
  if (dry) {
    print("    Dry run, skipped.");
  } else {
    var gitDiff = await Process.run(
      "git",
      ["diff", "HEAD^", "lib/all.yaml"],
      workingDirectory: proj.path,
    );

    final lines = gitDiff.stdout.split("\n");
    final changes = <String>[];
    int add = 0;
    int remove = 0;

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.startsWith("+    - ")) {
        changes.add("- Added lint rule: `${line.substring(7)}`");
        add++;
        print("[i] Added lint rule: ${line.substring(7)}");
      } else if (line.startsWith("-    - ")) {
        changes.add("- Removed lint rule: `${line.substring(7)}`");
        remove++;
      }
    }
    if (changes.isNotEmpty) {
      if (add != 0) {
        print("[i] Added $add lint rule" + (add > 1 ? "s" : ""));
      }
      if (remove != 0) {
        print("[i] Removed $remove lint rule" + (remove > 1 ? "s" : ""));
      }

      String newChangelog = "# ${nextVersion.toString()}\n" +
          changes.join("\n") +
          "\n" +
          changelogString;
      await changelog.writeAsString(newChangelog);
    }
  }

  final didWriteFiles = File(".did_write");
  if (didWrite) {
    await didWriteFiles.create();
  } else {
    await didWriteFiles.delete();
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
