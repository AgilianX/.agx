# General

- Always use `;` to separate terminal commands, not `&&`.

---

## Workflows and prompts

Prompts and workflows descibe their type in their header.

### Git

- When the `git` workflow type is explicitly specified (- Workflow type: `git`)
  1. Display in the chat an informational message about the current step in the workflow.
  2. Do not wait for user confirmation unless the step explicitly requires it.
  3. Follow the instructions in [prepare.prompt.md](../ai-prompts/git/tasks/prepare.prompt.md)
     before starting the tasks.
- When working with commit messages(e.g. commit, merge, release, etc.)
  after analysis is complete, follow the instructions in [issue-corelation.prompt.md](../ai-prompts/git/tasks/issue-corelation.prompt.md).
- For any git command with the `agx-*` or `agx-ai-*` prefix, run it exactly as written.
  These are preconfigured aliases. Do not modify or add arguments!
  If additional arguments are needed, ask the user for confirmation before proceeding.
- If GPG signing fails, do not attempt to fix it automatically. Inform the user, as this may be intentional.
- Never perform `push` or `pull` operations without explicit user confirmation.
- Use `git agx-ai-commit` (not `git commit`) for AI-generated commits.
  Always generate a draft commit message before running the command.

---

## Documentation

- Use emojis sparingly and only when appropriate.
- Avoid HTML in markdown files.
- All documentation files (except conventions) must include a footer with:
  - Related source files (if applicable), using actual Markdown links.
  - Do not include this information in commit or merge messages.
