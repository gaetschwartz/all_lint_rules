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

  if (!pubspec.existsSync()) throw Exception("$file not found");
  if (!file.existsSync()) throw Exception("$file not found");

  print("[i] Target project: ${proj.path}");

  // ===== PARSE pubspec.yaml =====
  final pusbpecString = await pubspec.readAsString();

  final parsedPubspec = Pubspec.parse(pusbpecString);
  final ver = parsedPubspec.version;
  if (ver == null) throw Exception("Pubspec.yaml doesn't have any version.");
  final nextVersion = ver.nextPatch;

  final lastHashRegexp = RegExp(r"alr_hash: (.+)");
  final lastHash = lastHashRegexp.firstMatch(pusbpecString)?.group(1);

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
  final updated = pusbpecString
      .replaceFirst(
        "version: ${ver.toString()}",
        "version: ${nextVersion.toString()}",
      )
      .replaceFirst(
        RegExp("alr_last_generated: .*"),
        "alr_last_generated: $date",
      )
      .replaceFirst(
        RegExp("alr_origin: .*"),
        "alr_origin: $origin",
      )
      .replaceFirst(
        lastHashRegexp,
        "alr_hash: $currentHash",
      );

  final updatedPub = Pubspec.parse(updated);
  if (updatedPub.version != nextVersion) {
    throw Exception("Failed to correctly update version");
  }

  if (verbose) print(updated);

  print("[*] Writing to files...");
  if (dry) {
    print("    Dry run, skipped.");
  } else {
    await file.writeAsString(string);
    await pubspec.writeAsString(updated);
    didWrite = true;
    print("    Done writing !");
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
