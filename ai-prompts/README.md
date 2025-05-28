# Setting Up AI Development Tools

This guide explains how to set up AI development tools using the .agx submodule, particularly focusing on GitHub Copilot instructions.

## GitHub Copilot Instructions

The `.agx` submodule provides standardized GitHub Copilot instructions that can be used across AgilianX repositories. These instructions help ensure that AI-assisted development follows the organization's conventions and best practices.

### Setting Up Copilot Instructions

1. **Create a `.github` directory** in your repository if it doesn't already exist:

   ```bash
   mkdir -p .github
   ```

2. **Copy the Copilot instructions template** from the .agx submodule:

   ```bash
   cp .agx/.github/copilot-instructions.md .github/copilot-instructions.md
   ```

3. **Update the Copilot instructions** with your repository details:
   - Update the Repository name (replace `.agx` with your repository name)
   - Update the path to the Commit Specification if needed
   - The default path assumes your repository has the .agx submodule at the root level

## Customizing Instructions

You can customize the Copilot instructions for your repository's specific needs, this provides a good starting point and some common instructions.

---

**Related source files:**

- [copilot-instructions.md](../.github/copilot-instructions.md)
