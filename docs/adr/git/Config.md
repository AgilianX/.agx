# Architecture Decision Record: .agx Submodule Configuration Options

This document outlines the configuration options available for the `.agx` submodule.

| Setting                     | Scope        | Default   | Description                                                                                       |
|-----------------------------|--------------|-----------|---------------------------------------------------------------------------------------------------|
| autosync                    | local config | `true`    | When `true`, post-checkout and post-merge hooks will automatically update the `.agx` submodule to the `track` ref/branch. Disabling this allows you to pin the tooling to a specific commit. |
| previousCommitHash          | local config | *(none)*  | Stores the previous commit hash of the `.agx` submodule after an update. Used internally to support reverting the submodule to its previous state. |
| useAliases                  | submodule    | `true`    | Enables installation of preconfigured AgX git aliases. |
| useHooks                    | submodule    | `true`    | Enables installation of AgX git hooks. |
| track                       | submodule    | `master`  | Specifies which branch or commit hash the submodule should follow. Usually set to `master` for latest updates. |

## How to change defaults

Use `git config` for local settings or `git config -f .gitmodules` for **submodule-scoped** options. Example:

```bash
# Disable AgX aliases

# in the .agx root -> applies to the .agx repository
git config --local agx.useAliases false

# in the main repository root -> applies to the .agx repository
git config -C .agx --local agx.useAliases false

# in the main repository root -> applies to the main repository
# this setting is part of source control
git config -f .gitmodules submodule..agx.useAliases false

# in the main repository root -> overrites the submodule config
# local override
git config --local agx.useAliases false
```

> [!CAUTION]
> When overriding submodule settings locally, remember to clean up your git config if already initialized.

## When to override

### The repository has it's own git hooks

If the repository has its own git hooks, you may want to disable AgX hooks. This is especially important if the hooks conflict with each other or if you want to maintain a specific set of hooks for your project.

> [!TIP]
> You can call the agx hooks from your own hooks if you want to use them in combination.

### You have conflicting aliases

If you have your own set of git aliases that conflict with AgX aliases, you may want to disable AgX aliases.

This is particularly relevant if you have custom aliases that perform similar functions or if you prefer a different naming convention.

> [!NOTE]
> The preconfigured aliases are mainly designed for the ai workflows that are also shipped with the AgX repository. If you don't use them, you can disable the aliases.

---

## Related source files

- [tools/init.ps1](../../../tools/init.ps1)
- [tools/auto-update.ps1](../../../tools/auto-update.ps1)
- [tools/revert-update.ps1](../../../tools/revert-update.ps1)
- [tools/install-aliases.ps1](../../../tools/install-aliases.ps1)
- [tools/install-hooks.ps1](../../../tools/install-hooks.ps1)
- [tools/aliases.yml](../../../tools/aliases.yml)
- [README.md](../../../README.md)
