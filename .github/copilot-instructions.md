# General

- Repository Info: [Repository](Repository..agx.md)
- Always use `;` to separate terminal commands, not `&&`.
- Always inform the user about which instructions you are currently following.
- Any **temporary** files created by the AI during a prompt will be stored in `.agx/ai-prompts/temp/`.

---

BEFORE DOING ANYTHING:
- Please inform the user about the workflow type(`workflow: {type}` in the prompt file header) before proceeding
- For `workflow: git`, first follow these additional preparation instructions:
  [prepare.instructions.md](../.agx/ai-prompts/git/tasks/prepare.instructions.md)

## Git

- When working with commit messages(e.g. commit, merge, release, etc.)
  after analysis is complete, follow the instructions in [issue-corelation.instructions.md](../.agx/ai-prompts/git/tasks/issue-corelation.instructions.md).
- For any git command with the `agx-*` or `agx-ai-*` prefix, run it exactly as written.
  These are preconfigured aliases. Do not modify or add arguments!
  If additional arguments are needed, ask the user for confirmation before proceeding.
- If GPG signing fails, do not attempt to fix it automatically. Inform the user, as this may be intentional.
- Never perform `push` or `pull` operations without explicit user confirmation.
- Use `git agx-ai-commit` (not `git commit`) for AI-generated commits.

---

## Documentation

- Use emojis sparingly and only when appropriate.
- Avoid HTML in markdown files.
- All documentation files (except conventions) must include a footer with:
  - Related source files (if applicable), using actual Markdown links.
  - Do not include this information in commit or merge messages.
