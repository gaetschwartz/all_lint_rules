import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:yaml/yaml.dart';

final regex = RegExp(r"<code>(.*)<\/code>", dotAll: true);

void main(List<String> arguments) async {
  final file = File(arguments.first);
  if (!file.existsSync()) throw Exception("File not found");
  print("Target file: $file");

  var url = Uri.parse(
      "https://dart-lang.github.io/linter/lints/options/options.html");
  final res = await http.get(url);

  final match = regex.firstMatch(res.body)?.group(1);
  if (match == null) throw Exception("Unable to parse $url");

  final origin = () {
    if (Platform.environment["CI"] == "true") {
      return "by CI";
    }
    if (Platform.environment["GITHUB_ACTIONS"] == "true") {
      return "by Github Actions";
    }
    return "manually";
  }();
  final string = """
# Generated $origin on ${DateFormat.yMMMMd().add_Hm().format(DateTime.now().toUtc())} UTC

$match
  """;

  print("YAML: ");
  print("=" * 20);
  print(string);

  final yaml = loadYaml(string);

  try {
    if (yaml["linter"]["rules"] == null) {
      throw FormatException("Invalid yaml file", yaml);
    }
  } on NoSuchMethodError {
    throw FormatException("Invalid yaml file", yaml);
  }

  print("Writing to $file...");
  await file.writeAsString(string);
  print("Done writing !");
}
