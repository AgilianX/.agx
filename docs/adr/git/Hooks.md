# Architecture Decision Record: Git Hooks Strategy

AgilianX projects require consistent enforcement of code quality, repository hygiene, and automation across all contributors and environments. Git hooks provide a mechanism to automate checks and actions at key points in the development workflow. The `.agx` submodule supplies a set of preconfigured hooks and check scripts to standardize these practices.

**Decision**:
The `.agx` submodule installs the following hooks and check scripts:

> [!TIP]
> See [Configuration Options](Config.md) for details on how to change the default settings or disable the hooks.

## Top-level Git Hooks

| Hook           | Description                                                                                 |
|----------------|---------------------------------------------------------------------------------------------|
| pre-commit     | Runs a suite of code and repository checks on staged files before a commit is finalized.    |
| post-checkout  | Triggers submodule auto-update to ensure tooling is current after branch changes.           |
| post-merge     | Triggers submodule auto-update to ensure tooling is current after merges.                   |

## Check Scripts (used by pre-commit)

| Script           | Description                                                                              |
|------------------|------------------------------------------------------------------------------------------|
| whitespace.ps1   | Blocks commits with trailing whitespace in staged files.                                 |
| todo.ps1         | Blocks commits containing `TODO` comments in staged files.                               |
| debug.ps1        | Blocks commits containing debug statements.                                              |
| conflicts.ps1    | Blocks commits with unresolved merge conflict markers.                                   |

## Skipping Individual Checks

> [!NOTE]
> Some check scripts support targeted bypass for advanced scenarios.

### Skipping the debug pre-commit check

To skip only the debug statement check (not all hooks), set the following environment variable when committing:

```sh
AGX_PRECOMMIT_SKIPDEBUGCHECK=1 git commit
```

This will skip only the debug statement check, while all other pre-commit checks will still run.

**Consequences**:

- Ensures code quality and repository standards are enforced automatically.
- Reduces manual review burden by catching common issues early.
- Provides context and feedback to contributors at commit time.
- Keeps `.agx` tooling up to date automatically after merges and checkouts.

**References**:

- [pre-commit](../../../hooks/pre-commit)
- [post-checkout](../../../hooks/post-checkout)
- [post-merge](../../../hooks/post-merge)
- [checks/whitespace.ps1](../../../hooks/checks/whitespace.ps1)
- [checks/todo.ps1](../../../hooks/checks/todo.ps1)
- [checks/debug.ps1](../../../hooks/checks/debug.ps1)
- [checks/conflicts.ps1](../../../hooks/checks/conflicts.ps1)
- [tools/auto-update.ps1](../../../tools/auto-update.ps1)
- [tools/install-hooks.ps1](../../../tools/install-hooks.ps1)
- [tools/init.ps1](../../../tools/init.ps1)
