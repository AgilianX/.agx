## Goal
Generate a standards-compliant commit message and execute the commit without user interaction beyond showing the final draft.

**IMPORTANT**
- Follow the [Commits.md](../../.agx/docs/conventions/Commits.md) specification precisely.
- Select one appropriate `type` per commit based on the most significant change.
- For AI-related files (prompts, workflows, configs), prioritize the `ai` type.
- Use context from relevant issues in the commit message when applicable.
- Never include implementation details in messages.
- Never use `git commit`, always use `git agx-ai-commit` WITHOUT ARGUMENTS to open the editor with the message for review.

---

## Step 1: Analysis
- Before anything, run `git agx-ai-commit-context`, to gather information about the current commit context.
  - You can and should run this command whenever you are unsure about the location of the terminal or if commands fail.
- Run `git agx-ai-diff-staged` to analyze staged changes
- You can see the staged files with `git agx-ai-status`
- List open issues using the `#list_issues` tool
- Identify affected components and appropriate scope

## Step 2: Issue Correlation
- Determine if changes directly address any open issues
- Use `#get_issue <number>` for detailed context if needed
- Include `@issue:#XXX` only when changes directly resolve or address an issue
- If any issues are related and included in the commit:
  - Display a short summary about the issues in the chat before continuing to drafting the commit message
  - Continue drafting the commit message only AFTER displaying the issue information in the chat (if any).

## Step 3: Message Formation
- Structure the message according to the specification:
  ```xml
  <type>(<scope>): <concise summary>

  - <bullet describing what changed>
  - <bullet describing why/how if relevant>

  <optional BREAKING CHANGE note>
  <metadata tags>
  ```
- Include metadata tags only when appropriate:
  - `@issue:#XXX` - For directly related issues
  - `@semver:level` or `@nuke:target` - Only when explicitly instructed

## Step 4: Validation
- Verify type and scope appropriateness per specification
- Iterate at least 3 times and with each itteration, attempt to improve type, scope and compliance,
remove obvious or repetitive information and rephrase to shorten the content where being explicit is not critical.
- Ensure message is concise, clear, and focuses on WHAT changed (not HOW)
- Check that bullet points add meaningful context

## Step 5: Finalize
- Display the final draft message in a code block
- Run `git agx-ai-commit` to open the editor with the message for review AFTER displaying the draft.

---

**Git Submodules**
- When gathering context for sumbodule updates:
  1. Change into submodule directory: `cd <submodule-path>`
  2. Inspect the git log between the commit hashes to gather context.
  3. Return to main repo: `cd ..`, do not forget to return to the main repo!

**Scopes:**
- You can use `git agx-ai-lg` to get inspiration on the commit message scopes and types to keep things consistent.

**Reminders:**
- Avoid assumptions. Omit optional metadata if unsure.
- Only use the staged files to determine what the commit addresses.
- Never leak implementation details in commit messages.
- Prioritize clarity and full compliance with the [Commits.md](../../.agx/docs/conventions/Commits.md) specification.
