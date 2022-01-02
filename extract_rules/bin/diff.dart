import 'package:pub_semver/pub_semver.dart';
import 'package:yaml/yaml.dart';

class Diff {
  final List<String> addedRules;
  final List<String> removedRules;

  const Diff._(this.addedRules, this.removedRules);

  factory Diff(List<String> old, List<String> newRules) {
    final added = newRules.where((r) => !old.contains(r)).toList();
    final removed = old.where((r) => !newRules.contains(r)).toList();
    return Diff._(added, removed);
  }

  factory Diff.compareYAML(YamlMap oldYAML, YamlMap newYAML) {
    return Diff(
      (oldYAML["linter"]["rules"] as YamlList).toList().cast(),
      (newYAML["linter"]["rules"] as YamlList).toList().cast(),
    );
  }

  String toDetailedString() {
    if (addedRules.isEmpty && removedRules.isEmpty) {
      return "No changes in the rules.";
    }
    return addedRules.map((r) => "- Added `$r`.").join("\n") +
        "\n" +
        removedRules.map((r) => "- Removed `$r`.").join("\n");
  }

  String genNewChangelog(String oldChangelog, Version version) {
    return """
## $version
${toDetailedString()}

$oldChangelog
  """;
  }
}
