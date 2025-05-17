# Git Alias Management Strategy

This repository utilizes several Git workflows and AI-assisted tools that benefit from standardized Git command aliases.

Specifically, these aliases enhance developer productivity and ensure consistent workflows when working with AI prompts, conventions, and repository navigation.

We needed a solution to ensure these aliases are available to all contributors, including those who fork the repository.

## Decision Factors

We explored several approaches to manage repository-specific Git aliases:

1. [**Manual Setup (REJECTED)**](#manual-setup-rejected)
2. [**Git Template Directory Approach (REJECTED)**](#git-template-directory-approach-rejected)
3. [**Pre-command Hook (REJECTED)**](#pre-command-hook-rejected)
4. [**Init Script + Installer (Current Solution)**](#init-script--installer-current-solution)

---

### Manual Setup [REJECTED]

This approach requires each developer to manually configure the necessary Git aliases in their local environment, typically by editing their global or repository `.gitconfig` file or running `git config` commands directly.

**Advantages:**

- Simple to understand and implement for small teams or one-off needs
- No repository-specific tooling required

**Disadvantages:**

- Tedious and error-prone for contributors, especially as the number of aliases grows
- No guarantee that all contributors have the correct or up-to-date aliases
- Difficult to maintain consistency across teams, repositories and forks
- High onboarding friction for new contributors

---

### Git Template Directory Approach (REJECTED)

Git provides a "template directory" feature that can populate the `.git` directory of new repositories when they're initialized or cloned:

```bash
git config --global init.templatedir "path/to/template/directory"
```

**Advantages:**

- Cleaner approach - aliases would be set automatically upon clone
- No need for post-clone setup scripts
- Could include other standard configurations

**Disadvantages:**

- Requires users to configure Git globally *before* cloning the repository
- Not automatically applied to forks
- Higher barrier to entry for contributors
- Requires global Git configuration changes (invasive)
- Problematic when working with multiple repositories with different template needs

---

### Pre-command Hook (REJECTED)

We considered using a pre-command hook to check for and set up repository-specific aliases automatically before every git command.

However, Git does not support pre-command hooks natively. Implementing this would require a third-party tool or a custom git wrapper, which would add complexity and reduce portability.

**Advantages:**

- Would provide a fully automated and transparent experience for contributors
- Could ensure aliases are always up to date before every git command

**Disadvantages:**

- Not supported natively by Git; requires a third-party tool or custom wrapper
- Adds significant complexity and reduces portability
- Increases maintenance burden and risk of breakage
- Could interfere with standard Git workflows and tooling
- Performance overhead for every git command

---

### Init Script + Installer (Current Solution)

The current solution uses the [init](../../../tools/init.ps1) script to call [install-aliases](../../../tools/install-aliases.ps1), which sets up all preconfigured aliases from [aliases.yml](../../../tools/aliases.yml).

This script is run manually after cloning or initializing the submodule, and is also called automatically by the submodule's auto-update mechanism. This ensures aliases are always up to date and managed alongside the submodule.

**Advantages:**

- Repository-specific without requiring global Git changes
- Transparent and easy to document
- Minimal third-party dependencies
    > [!WARNING]
    > The [install-aliases](../../../tools/install-aliases.ps1) script requires powershell-yaml module and will prompt the user to install it. If the user declines, `useAliases` will be set to `false` in the config(.gitmodules or local git config)

- Aliases are always in sync with the submodule version

**Disadvantages:**

- May require an installation step after cloning or updating the submodule

## Decision

We initially considered a pre-command hook, but since Git does not support this natively, we adopted a more standard and portable approach:

1. All preconfigured aliases are defined in `.agx/tools/aliases.yml` (YAML format, supporting multi-line/script aliases)
2. The `.agx/tools/install-aliases.ps1` script installs these aliases
3. The `.agx/tools/init.ps1` script calls the installer and manages all setup logic
4. The submodule's auto-update mechanism ensures aliases are kept up to date after submodule updates

> [!IMPORTANT]
> All repository-specific aliases use the `agx-` prefix to avoid conflicts with personal aliases.
> All repository-ai-specific aliases use the `agx-ai-` prefix to avoid conflicts with personal aliases.

## Implementation

The Git alias management system consists of these components:

```directory
.agx/tools/
├── aliases.yml              # Defines repository-specific aliases (YAML)
├── install-aliases.ps1      # PowerShell script to install aliases
├── init.ps1                 # Repository initialization script
├── auto-update.ps1          # Handles submodule auto-updates and triggers alias install
```

> [!NOTE]
> All preconfigured agx git aliases are defined in the [aliases file](../../../tools/aliases.yml) using YAML.

This format supports:

- **Single-line aliases** (quote the value if it starts with `!`)
- **Multi-line/script aliases** using an object with `shell` and `script` keys
  - supports shells: `pwsh`, `bash`

### Key Features

1. **Idempotent**: Can run multiple times without issues
2. **Extensible**: Easily add new aliases by updating the central aliases file
3. **Prefix-Based**: All aliases use the `agx-` or `agx-ai-` prefix to avoid conflicts
4. **Centralized**: All aliases defined in a single `aliases.yml` file

## Setup Instructions

**Recommended**: Follow the repository setup guide in [README](../../../README.md).

> [!NOTE]
> When registering a new alias, simply run the [initialization script](../../../tools/init.ps1) again.

Verify aliases are working:

```bash
git agx-setup-test
```

## Why Aliases Are Necessary for AI Workflows

Several AI-assisted workflows depend on these aliases to operate effectively:

1. **AI commit message generation**: The `agx-ai-lg` command provides sufficient context for our AI agents to understand commit history patterns.

2. **AI prompt execution**: Some prompt files like [ai.create-commit-message.prompt.md](../../../ai/ai.create-commit-message.prompt.md) explicitly reference these aliases in their execution steps.

3. **Consistent context gathering**: When agents need to understand repository state, these aliases ensure they receive consistent and sufficient information, free of halucinated extra arguments that come from training data around the command.

4. **Enhanced collaboration**: By standardizing commands, we reduce the learning curve for new contributors and improve team efficiency.

5. **Error reduction**: Using aliases minimizes the risk of human error when typing complex commands, especially in AI-assisted workflows.

6. **Consistent prompt execution**: The aliases ensure that AI prompts are executed in a consistent manner, reducing variability in results. Ai training data often produces commands with extra arguments that are not needed in our context. Using standardized aliases helps mitigate this issue as the commands are tokenized differently.

### Positive

- Makes AI prompt files more reliable and consistent
- Centralized alias management through a single aliases file
- More transparent approach with dedicated installation scripts

### Negative

- Requires a manual installation step after cloning
- May cause confusion if users have personal aliases with the same names (very unlikely)

## References

- [Git Config Documentation](https://git-scm.com/docs/git-config)
- [Git Template Directories](https://git-scm.com/docs/git-init#_template_directory)
- [Git Hooks Documentation](https://git-scm.com/docs/githooks)

---

**Related source files:**

- [tools/aliases.yml](../../../tools/aliases.yml)
- [tools/install-aliases.ps1](../../../tools/install-aliases.ps1)
- [tools/init.ps1](../../../tools/init.ps1)
- [tools/auto-update.ps1](../../../tools/auto-update.ps1)
- [ai/ai.create-commit-message.prompt.md](../../../ai/ai.create-commit-message.prompt.md)
