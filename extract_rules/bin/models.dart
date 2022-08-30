import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:yaml/yaml.dart';

part 'models.freezed.dart';
part 'models.g.dart';

@freezed
class Diff with _$Diff {
  const factory Diff(List<String> oldRules, List<String> newRules) = _Diff;
  factory Diff.fromYaml(YamlMap oldYAML, YamlMap newYAML) {
    return Diff(
      (oldYAML["linter"]["rules"] as YamlList).toList().cast(),
      (newYAML["linter"]["rules"] as YamlList).toList().cast(),
    );
  }

  const Diff._();

  List<String> get addedRules =>
      newRules.where((r) => !oldRules.contains(r)).toList();

  List<String> get removedRules =>
      oldRules.where((r) => !newRules.contains(r)).toList();

  RulesDiff get rulesDiff => RulesDiff(
        addedRules: addedRules,
        removedRules: removedRules,
      );

  String toDetailedString() {
    if (addedRules.isEmpty && removedRules.isEmpty) {
      return "No changes in the rules.";
    }
    return "${addedRules.map((r) => "- Added [`$r`](https://dart-lang.github.io/linter/lints/$r.html).").join("\n")}\n${removedRules.map((r) => "- Removed `$r`.").join("\n")}";
  }

  String genNewChangelog(String oldChangelog, Version version) {
    return """
## $version
${toDetailedString()}

$oldChangelog
  """;
  }

  factory Diff.fromJson(Map<String, dynamic> json) => _$DiffFromJson(json);
}

@freezed
class RulesDiff with _$RulesDiff {
  const factory RulesDiff({
    required List<String> addedRules,
    required List<String> removedRules,
  }) = _RulesDiff;

  factory RulesDiff.fromJson(Map<String, dynamic> json) =>
      _$RulesDiffFromJson(json);
}
