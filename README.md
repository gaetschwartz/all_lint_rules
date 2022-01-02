# All lint rules

To use, add `all_lint_rules_community` to your dev dependencies:

```yaml
dev_dependencies:
  all_lint_rules_community: ^0.0.3
```


Then, include it in your analysis_options.yaml: 

```yaml
include: package:all_lint_rules_community/all.yaml

# REST OF YOUR ANALYSIS_OPTIONS.YAML FILE
analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "test/.test_coverage.dart"
    - "bin/cache/**"
    - "lib/generated_plugin_registrant.dart"

  strong-mode:
    implicit-casts: false
    implicit-dynamic: false
```

