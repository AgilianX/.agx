# Goal
Generate a standards-compliant merge commit message and execute the merge without user interaction beyond information and showing the final draft.

**IMPORTANT**
- Follow the [Commits.md](../docs/conventions/Commits.md) specification precisely.
- Select one appropriate `type` per commit based on the most significant change.
- For AI-related files (prompts, workflows, configs), prioritize the `ai` type.
- Use context from relevant issues in the merge message when applicable.
- Never include implementation details in messages.
- Never use `git merge`, always use `git agx-ai-merge` WITHOUT ARGUMENTS to open the editor with the message for review.

---

## Step 1: Analysis
- At the start of the workflow, set the environment variable `$env:AGX_AI_WORKFLOW = 'true'`.
- Before anything, run `git agx-ai-git-context` to gather information about the current git context.
  - Run this command whenever you expect the git context to change (e.g., after checking out another branch or entering a submodule).
  - You can and should run this command whenever you are unsure about the location of the terminal or if commands fail.
- Determine the source branch (defaults to the active branch unless overridden by the user in the prompt).
- Determine the target branch (defaults to `develop` unless overridden by the user in the prompt).
  - Display information about the source and target branches in the chat.
- If the source branch is different from the active branch, check out the source branch.
- Run `git agx-ai-status` to check for uncommitted changes. If any are found, abort and notify the user.
- Run `git agx-ai-log {target branch}..{source branch}` to gather the list of commits to be merged.

## Step 2: Issue Correlation
- List open issues using the `#list_issues` tool.
- Determine if changes directly address any open issues.
- Use `#get_issue <number>` for detailed context if needed.
- Include `+issue:#XXX` only when changes directly resolve or address an issue and is undeniably related.
- If any issues are related and included in the merge:
  - Display a short summary about the issues in the chat before continuing to drafting the merge message.
  - Continue drafting the merge message only AFTER displaying the issue information in the chat (if any).

## Step 3: Message Formation
- Draft the merge message according to the commit specification, summarizing the changes made on the source branch.
- Structure the message according to the specification.
- Include additional metadata only if instructed.

## Step 4: Validation
- Verify type and scope appropriateness per specification.
- Iterate at least 3 times and with each iteration, attempt to improve type, scope, and compliance,
remove obvious or repetitive information, and rephrase to shorten the content where being explicit is not critical.
- Ensure the message is concise, clear, and focuses on WHAT changed (not HOW).
- Check that bullet points add meaningful context.

## Step 5: Finalize
- Display the final draft message in a code block in chat. (no user confirmation needed)
- Write the message to the appropriate prepare-comit-msg file.
    - `.agx/hooks/ai-commit.txt` for the main repository
    - `hooks/ai-commit.txt` for the .agx submodule
- Check out the target branch.
- Run `git agx-ai-merge {source-branch}` to open the merge editor with the message for review AFTER:
    - 1. displaying the draft
    - 2. editing the prepare-commit-msg file.
- Clear the `ai-comit.txt` file after the merge is completed to avoid stale messages.
- At the end of the workflow, set the environment variable `$env:AGX_AI_WORKFLOW = 'false'`.

---

**Scopes:**
- You can use `git agx-ai-lg` to get inspiration on the commit message scopes and types to keep things consistent.

**Reminders:**
- Avoid assumptions. Omit optional metadata if unsure.
- Only use the commits to be merged to determine what the merge addresses.
- Never leak implementation details in merge messages.
- Prioritize clarity and full compliance with the [Commits.md](../../.agx/docs/conventions/Commits.md) specification.
