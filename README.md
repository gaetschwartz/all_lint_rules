# All lint rules

To use, add `all_lints_rules` to your dev dependencies:

```yaml
dev_dependencies:
  all_lint_rules:
    git: https://github.com/gaetschwartz/all_lint_rules
```


Then, include it in your analysis_options.yaml: 

```yaml
include: package:all_lint_rules/all.yaml

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

  errors:
    # Without ignore here, we cause import of all_lint_rules to warn, because some rules conflict.
    # We explicitly enabled even conflicting rules and are fixing the conflicts in this file.
    included_file_warning: ignore
    # Treat missing required parameters as an error.
    missing_required_param: error
    # Treat missing returns as an error, not as a hint or a warning.
    missing_return: error
    # Don't assign new values to parameters of methods or functions.
    # Treat assigning new values to a parameter as a warning. We would almost like to set this
    parameter_assignments: warning
    # Allow having TODOs in the code.
    todo: ignore

# LINTER Preferences
#
# Explicitly disable only the rules we do not want.
linter:
  rules:
    # ALWAYS separate the control structure expression from its statement.
    # This sometimes makes things more unclear when one line is enough.
    # Also single line `if`s are fine as recommended in Effective Dart "DO format your code using dartfmt".
    always_put_control_body_on_new_line: false

    # ALWAYS specify @required on named parameter before other named parameters.
    # Conflicts with the convention used by flutter, which puts `Key key`
    # and `@required Widget child` last.
    always_put_required_named_parameters_first: false
  
    # Followed by more turned OFF lint rules as preferred/needed/desired and always 
    # turning off at least conflicting rules.
```
