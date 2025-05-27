# IMPORTANT

**Owner:** AgilianX
**Repository name:** `.agx`
**Goal:** Collection of development tools, conventions, and automation for AgilianX repositories to be used as a git submodule

---

## Git Operations

- For any git command with the `agx-*` or `agx-ai-*` prefix, run it exactly as written.
  These are preconfigured aliases. Do not modify or add arguments!
  If additional arguments are needed, ask the user for confirmation before proceeding.
- If GPG signing fails, do not attempt to fix it automatically. Inform the user, as this may be intentional.
- Never perform `push` or `pull` operations without explicit user confirmation.
- Always use `;` to separate terminal commands, not `&&`.

### Commits

- Use `git agx-ai-commit` (not `git commit`) for AI-generated commits.
  Always generate a draft commit message before running the command.
- For submodules, change into the submodule directory before running workflows.

---

## Documentation

- Use emojis sparingly and only when appropriate.
- Avoid HTML in markdown files.
- All documentation files (except conventions) must include a footer with:
  - Related source files (if applicable), using actual Markdown links.
  - Do not include this information in commit or merge messages.
