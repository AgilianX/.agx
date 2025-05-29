# .agx - AgilianX Shared Development Tools

A comprehensive collection of development tools, conventions, and automation for AgilianX repositories. This repository serves as a central hub for standardized tooling and can be used across multiple repositories as a Git submodule.

## Features

- **Git Integration** - [Hooks](docs/adr/git/Hooks.md), [aliases](docs/adr/git/Aliases.md), and automation scripts
- **YAML-based Aliases** - All preconfigured agx git aliases are defined in [aliases.yml](tools/aliases.yml) for maintainability and multi-line/script support
- **Development Conventions** - Coding standards and workflow practices (`docs/conventions`)
- **Documentation** - [Architecture Decision Records (ADRs)](docs/adr/README.md) and more (`docs/`)
- **AI Prompt Files** - Optimized prompts for AI-assisted development (`.github/copilot-instructions.md` and `ai/`)
- **Common Tooling** - Shared utilities for AgilianX projects (`tools/`)

## Installation

To integrate the AgilianX shared tooling in any repository:

> [!NOTE]
> By default, the submodule will track the `commit` at the time of addition.
> The init script will set up the submodule to track the `master` branch for automatic updates.
> See [Configuration Options](docs/adr/git/Config.md) for details.

1. Add the repository as a Git submodule:

    ```bash
    git submodule add https://github.com/AgilianX/.agx.git .agx
    git submodule update --init .agx
    ```

2. Run the [initialization script](tools/init.ps1):

   ```powershell
   # From the repository root
   # omit the .agx directory prefix if initializing the .agx repository
   .\.agx\tools\init.ps1
   ```

## Updating

> [!IMPORTANT]
> `agx-update` and automatic updates use the value stored in `agx.track` to determine which branch or commit hash to update to. See [Configuration Options](docs/adr/git/Config.md) for details.

### Automatic Submodule Updates (Default)

Git hooks [post-checkout](hooks/post-checkout), [post-merge](hooks/post-merge) invoke [auto-update.ps1](tools/auto-update.ps1) for submodule sync and update.

> [!TIP]
> You can also update with `git agx-update` if AgX aliases are installed.

- If you have uncommitted changes in the `.agx` submodule, the script will automatically **stash** those changes with a unique timestamped message before updating.
- After the update, it will search for and **pop only the specific stash** it created, so your changes are restored and other stashes are not affected.
- This ensures your work is preserved and does not interfere with any other stashes you may have in the submodule.
- You will see a message if changes were stashed and restored.

> See [Disable automatic updates](#disabling-automatic-updates) if you want to prevent this behavior.

### Reverting to the Previous Submodule Commit After an Update

If the `.agx` submodule was automatically updated and you want to revert to the previous commit (for example, to pin your tooling to a known working version), you can use the `agx.previousCommitHash` value saved in your local git config:

#### 1. Recommended - Git Alias

Use `git agx-revert-update`.

> [!WARNING]
> AgX Aliases need to be installed.

#### 2. Manual

```bash
# 1. Disable automatic updates (recommended before pinning)
git config --local agx.autosync false

# 2. Revert the submodule to the previous commit
# (Run this from the root of your main repository, not inside .agx)
git -C .agx checkout $(git config --get agx.previousCommitHash)

# 3. Stage and commit the change in your main repository
git add .agx
git commit -m "chore(agx): revert .agx submodule to previous commit"
```

This allows you to quickly undo an automatic update and lock the submodule to the prior version. You can always re-enable auto-updates later by setting `agx.autosync` to `true`.

---

### Disabling Automatic Updates

If you need to prevent automatic updates and pin the submodule to a specific version:

```bash
# Disable automatic updates
git config --local agx.autosync false

# Optional: Pin to a specific commit
cd .agx
git checkout <commit-hash>
cd ..
git add .agx
git commit -m "chore(agx): pin tooling to specific commit"
```

### Manual Updates

To manually update the submodule (if automatic updates are disabled):

```bash
git submodule update --remote .agx
```

> [!TIP]
> Or just use the alias `git agx-update` to update the submodule if AgX aliases are installed!

## Repository Modes

This repository can operate in two modes:

1. **As a standalone repository** - When working directly within the `.agx` repository
2. **As a submodule** - When included as a submodule in another repository

> [!NOTE]
> The scripts automatically detect which mode they're running in and adjust paths accordingly.
> This is based on the terminal location and the presence of the `.agx` directory.

## Documentation

See the `docs` directory for detailed documentation on:

- [Architecture Decision Records](docs/adr/README.md)
- Development Conventions
  - [Branch Naming](docs/conventions/Branches.md)
  - [Commit Messages](docs/conventions/Commits.md)
  - [Issue Management](docs/conventions/Issues.md)

## License

See [LICENSE](LICENSE) for details.

---

**Related source files:**

- [tools/init.ps1](../tools/init.ps1)
- [tools/install-aliases.ps1](../tools/install-aliases.ps1)
- [tools/install-hooks.ps1](../tools/install-hooks.ps1)
- [tools/update.ps1](../tools/update.ps1)
- [tools/revert-update.ps1](../tools/revert-update.ps1)
- [tools/auto-update.ps1](../tools/auto-update.ps1)
- [tools/aliases.yml](../tools/aliases.yml)
- [tools/repo-info.ps1](../tools/repo-info.ps1)
