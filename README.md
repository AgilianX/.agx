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

2. Run the initialization script:
   - On Windows PowerShell:

     ```powershell
     # From the repository root
     .\.agx\init.ps1
     ```

   - On Linux/macOS:

     ```bash
     # From the repository root
     bash .agx/init.sh
     ```

## Updating

To update the AgilianX shared tooling in your repository:

```bash
git submodule update --remote .agx
# Re-run the initialization script
./.agx/init.ps1  # or ./.agx/init.sh on Linux/macOS
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
