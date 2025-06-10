# General

- Repository Info: [Repository](Repository..agx.md)
- Always use `;` to separate terminal commands, not `&&`.
- Always inform the user about which instructions you are currently following. Keep a balance between detail and brevity for efficiency.
- Any **temporary** files created by the AI during a prompt will be stored in `.agx/ai-prompts/temp/`.

---

BEFORE DOING ANYTHING:
- Please inform the user about the workflow type(`workflow: {type}` in the prompt if present) before proceeding

## Git

- If a commit is aborted with empty message, it is likely intentional, wait for further user instructions.
- If GPG signing fails, do not attempt to fix it automatically. Inform the user, as this may be intentional.
- When using a git command, check for existing aliases, there may be a preconfigured alias starting with `agx-*` or `agx-ai-*` which is preferred.
  You can cache these in your temp folder for reference in the future if it makes things easier.
- For any git command with the `agx-*` or `agx-ai-*` prefix, run it exactly as written.
  These are preconfigured aliases. Do not modify or add arguments!
  If additional arguments are needed, ask the user for confirmation before proceeding.
- Never perform the following operations without explicit user confirmation:
  - `git push`
  - `git pull`
  - `git commit`
  - `git merge`
  - `git restore`
  - `git reset`

---

## Issues
- Most issues should follow the [Issue Specification](../docs/conventions/Issues.md).
  If the issue does not follow the specification, inform the user about it. Do not make changes unless instructed after informing the user.

---

## Documentation

- Use emojis sparingly and only when appropriate.
- Avoid HTML in markdown files.
- All documentation files (except conventions) must include a footer with:
  - Related source files (if applicable), using actual Markdown links.
  - Do not include this information in commit or merge messages.
