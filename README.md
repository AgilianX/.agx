# .agx - AgilianX Shared Development Tools

A comprehensive collection of development tools, conventions, and automation for AgilianX repositories. This repository serves as a central hub for standardized tooling and can be used across multiple repositories as a Git submodule.

## Features

- **Git Integration** - Hooks, aliases, and automation scripts
- **Development Conventions** - Coding standards and workflow practices
- **Documentation Templates** - Architecture Decision Records (ADRs) and more
- **AI Prompt Files** - Optimized prompts for AI-assisted development
- **Common Tooling** - Shared utilities for AgilianX projects

## Installation

To integrate the AgilianX shared tooling in any repository:

1. Add the repository as a Git submodule:

    ```bash
    git submodule add https://github.com/AgilianX/.agx.git .agx
    git submodule update --init
    ```

2. Track the master branch of the submodule (OPTIONAL and RECOMMENDED):

    By default, the submodule will track the `commit` at the time of addition. If you want to track the `master` branch instead, run:

    ```bash
    git config --local agx.autosync true
    git config -f .gitmodules submodule.".agx".branch master
    ```

3. Run the initialization script:

   On Windows PowerShell:

     ```powershell
     # From the repository root (omit the .agx\ prefix if running from the .agx repository)
     .\.agx\init.ps1
     ```

   On Linux/macOS:

     ```bash
     # From the repository root (omit the .agx\ prefix if running from the .agx repository)
     bash .agx/init.sh
     ```

     > **Note**: If you want to contribute to the `.agx` repository itself and take advantage of it's functionality, you should run the initialization script from within the `.agx` directory as well.

## Updating

### Automatic Updates (Default)

The `.agx` submodule is configured to automatically stay up-to-date with its remote repository through Git hooks:

- When you switch branches (`post-checkout` hook)
- When you merge or pull changes (`post-merge` hook)

This happens automatically in the background without requiring manual sync commands.

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

## Repository Modes

This repository can operate in two modes:

1. **As a standalone repository** - When working directly within the `.agx` repository
2. **As a submodule** - When included as a submodule in another repository

The scripts automatically detect which mode they're running in and adjust paths accordingly.

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

- init.ps1
- init.sh
- aliases/install-aliases.ps1
- aliases/install-aliases.sh
- hooks/install-hooks.ps1
- hooks/install-hooks.sh
