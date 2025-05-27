# Goal
Generate a standards-compliant release commit and tag, finalizing a new release on the `master` branch.

**IMPORTANT**
- Follow the [Commits.md](../docs/conventions/Commits.md) specification precisely.
- Use the `release` type for the commit.
- The commit message must be: `release({MajorMinorPatch}): finalize release`
- The tag must be: `{Release name / Feature Summary}` with bullets summarizing the release.
    - The user may supply a release name in the prompt, otherwise you should try to generate it, display it in chat, and ask for confirmation.
- Never include implementation details in messages.
- Never use `git merge`, always use `git agx-ai-release {source-branch}` WITHOUT ADDITIONAL ARGUMENTS to open the editor with the message for review.

---

## Step 1: Analysis
- At the start of the workflow, set the environment variable `$env:AGX_AI_WORKFLOW = 'true'`.
- Run `git agx-ai-git-context` to gather information about the current git context.
- Before anything, run `git agx-ai-git-context` to gather information about the current git context.
  - Run this command whenever you expect the git context to change (e.g., after checking out another branch or entering a submodule).
  - You can and should run this command whenever you are unsure about the location of the terminal or if commands fail.
- Determine the source branch (defaults to the active branch unless overridden by the user in the prompt).
- Determine the target branch (defaults to `master` unless overridden by the user in the prompt).
  - Display information about the source and target branches in the chat.
- If the source branch is different from the active branch, check out the source branch.
- Run `git agx-ai-status` to check for uncommitted changes. If any are found, abort and notify the user.
- Run `dotnet-gitversion` and extract `{MajorMinorPatch}` from the output.
- Run `git agx-ai-log <last-semver-tag>..{source branch}` to gather the list of commits since the last semantic versioned tag on `master`.

## Step 2: Issue Correlation
- List open issues using the `#list_issues` tool.
- Determine if changes directly address any open issues.
- Use `#get_issue <number>` for detailed context if needed.
- Include `+issue:#XXX` only when changes directly resolve or address an issue and is undeniably related.
- If any issues are related and included in the release:
  - Display a short summary about the issues in the chat before continuing to drafting the release notes.
  - Continue drafting the release notes only AFTER displaying the issue information in the chat (if any).

## Step 3: Message Formation
- Draft the merge commit message as:
  `release({MajorMinorPatch}): finalize release`
- Draft the tag message as:
  ```
  v({MajorMinorPatch}): {Release name / Feature Summary}
  - Bulleted list summarizing the changes since the last tag, following commit message conventions.
  ```
- If a release name is not provided, generate a summary based on the commits and display it in chat for confirmation.
  - Be creative, something catchy but not misleading! You can reference previous tags for inspiration to keep a consistent style.
- Structure the tag message according to the specification.
- Include additional metadata only if instructed.

## Step 4: Validation
-  For the tag message, Iterate at least 3 times and with each iteration, attempt to improve type, scope, and compliance,
remove obvious or repetitive information, and rephrase to shorten the content where being explicit is not critical.
- Ensure the message is concise, clear, and focuses on WHAT changed (not HOW).
- Check that bullet points add meaningful context.

## Step 5: Finalize
- Display the final draft commit and tag messages in code blocks in chat. (no user confirmation needed)
- Write the commit message to the appropriate prepare-comit-msg file.
    - `.agx/ai/ai-commit.txt` for the main repository.
    - `ai/ai-commit.txt` for the .agx submodule.
- Write the tag message to the appropriate prepare-tag-msg file.
    - `.agx/ai/ai-tag.txt` for the main repository.
    - `ai/ai-tag.txt` for the .agx submodule.
- Check out the target branch.
- Run `git agx-ai-release {source-branch}` and then `git agx-ai-commit` to open the merge editor with the message for review AFTER:
    - 1. displaying the merge message draft.
    - 2. editing the `ai-commit.txt` file.
    - 3. displaying the tag message draft.
- After the merge, run `git tag -a v{MajorMinorPatch} -F .agx/ai/ai-tag.txt` to create the tag with the prepared tag message.
- Remove all the content of the `ai-commit.txt` file after the release is completed to avoid stale messages.
- At the end of the workflow, set the environment variable `$env:AGX_AI_WORKFLOW = 'false'`.

---

**Scopes:**
- You can use `git agx-ai-lg` to get inspiration on the commit message scopes and types to keep things consistent.

**Reminders:**
- Avoid assumptions. Include additional metadata only if instructed.
- Only use the commits since the last tag to determine what the release addresses.
- Never leak implementation details in release notes.
- Prioritize clarity and full compliance with the [Commits.md](../../.agx/docs/conventions/Commits.md) specification.
