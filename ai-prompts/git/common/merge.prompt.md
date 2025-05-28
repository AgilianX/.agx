---
mode: agent
---
# Goal
Generate a standards-compliant merge commit message and execute the merge without user interaction beyond information and showing the final draft.

**IMPORTANT**
- Workflow type: `git`
- Follow the [Commits.md](../../../docs/conventions/Commits.md) specification precisely.
- Never use `git merge`, always use `git agx-ai-merge` WITHOUT ARGUMENTS to open the editor with the message for review.
- Use context from relevant issues in the merge message when applicable.
- Never leak implementation details in commit messages.
- Only use the commits to be merged to determine what the merge addresses.

---

## Step 1: Analysis
- Command: `git agx-ai-lg` can be used on the target branch to get inspiration on the commit message scopes and types to keep things consistent.
1. Determine the source branch (defaults to the active branch unless overridden by the user in the prompt).
2. Determine the target branch (defaults to `develop` unless overridden by the user in the prompt).
3. Display information about the source and target branches in the chat and await confirmation.
4. If the source branch is different from the active branch, check out the source branch.
5. Command: `git agx-ai-status` on the source branch will check for uncommitted changes.
   If any are found, abort and notify the user.
6. Command: `git agx-ai-log {target branch}..{source branch}` will gather the list of commits to be merged.

## Step 2: Message Formation
1. Draft the merge message according to the commit specification, summarizing the changes made on the source branch.
2. Verify type and scope appropriateness per specification.
3. Iterate at least 3 times and with each iteration, attempt to improve type, scope and compliance,
   remove obvious or repetitive information and rephrase to shorten the content where being explicit is not critical.
4. Ensure message is concise, clear, and focuses on WHAT changed (not HOW).
5. Check that bullet points add meaningful context.

## Step 3: Finalize
1. Display the final draft in a code block in chat. (no user confirmation needed)
2. Write the message to `.agx/ai-prompts/git/temp/ai-commit.txt`.
   Note that `.agx` can be a repository or a submodule, the path may vary.
   Modify the file. On fresh forks or clones you may need to create it.
3. Check out the target branch.
4. Command: `git agx-ai-merge {source-branch}` will open the merge commit editor with the message for review and refinement. Run it after:
    - showing the draft to the user.
    - editing the `ai-commit.txt` file.
4. Remove all the content of the `ai-commit.txt` file after the commit is completed to avoid stale messages.
