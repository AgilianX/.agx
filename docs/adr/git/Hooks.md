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
| whitespace.sh    | Blocks commits with trailing whitespace in staged files.                                 |
| todo.sh          | Blocks commits containing `TODO` comments in staged files.                              |
| debug.sh         | Blocks commits containing debug statements.                                              |
| conflicts.sh     | Blocks commits with unresolved merge conflict markers.                                   |
| repo_info.sh     | Displays repository and branch info before commit (informational only).                  |

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
- [checks/whitespace.sh](../../../hooks/checks/whitespace.sh)
- [checks/todo.sh](../../../hooks/checks/todo.sh)
- [checks/repo_info.sh](../../../hooks/checks/repo_info.sh)
- [checks/debug.sh](../../../hooks/checks/debug.sh)
- [checks/conflicts.sh](../../../hooks/checks/conflicts.sh)
- [tools/auto-update.ps1](../../../tools/auto-update.ps1)
- [tools/install-hooks.ps1](../../../tools/install-hooks.ps1)
- [tools/init.ps1](../../../tools/init.ps1)
