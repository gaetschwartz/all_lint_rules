import 'dart:io';

import 'package:http/http.dart' as http;

final regex = RegExp(r"<code>(.*)<\/code>", dotAll: true);

void main(List<String> arguments) async {
  final file = File(arguments.first);
  if (!file.existsSync()) throw Exception("File not found");

  var url = Uri.parse(
      "https://dart-lang.github.io/linter/lints/options/options.html");
  final res = await http.get(url);

  final m = regex.firstMatch(res.body)?.group(1);
  if (m == null) throw Exception("Unable to parse $url");

  await file.writeAsString(m);
}
