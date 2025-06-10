---
mode: agent
---
workflow: git

# Goal
Generate a standards-compliant commit message and execute the commit without user interaction beyond information and showing the final draft.

**IMPORTANT**
- Before starting the workflow, follow these additional preparation [instructions](../tasks/prepare.instructions.md)
- Follow the [Commits.md](../../../docs/conventions/Commits.md) specification precisely.
- Never use `git commit`, always use `git agx-ai-commit` WITHOUT ARGUMENTS to open the editor with the message for review.
- Never leak implementation details in commit messages.
- Avoid assumptions. Include additional metadata only if instructed.
- If the commit was aborted, stop the workflow.
- Do not wait for user confirmation unless the step explicitly requires it.

---

## Step 1: Analysis
- Command: `git agx-ai-status` will show the staged files.
- Command: `git agx-ai-diff-staged` will show the staged diff changes.
- Command: `git agx-ai-diff-submodule {submoduleName}` will show the staged submodule updates.
  Run this command for each submodule that is staged.
1. Analyze the staged files and changes to determine the type of changes made.
2. Follow the instructions in [issue-corelation.instructions.md](../tasks/issue-corelation.instructions.md).

## Step 2: Message Formation
- Command: `git agx-ai-lg` can be used get inspiration on the commit message to keep things consistent.
1. Draft the merge message according to the commit specification, summarizing the staged changes.
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
3. Command: `git agx-ai-commit` will open the commit editor with the message for review and refinement. Run it after:
    - showing the draft to the user.
    - editing the `ai-commit.txt` file.
4. Remove all the content of the `ai-commit.txt` file after the commit is completed to avoid stale messages.

## Step 4: Documentation
1. After committing, search the existing documentation for every file that was staged, this includes added, modified or deleted files.
   Each documentation file's footer references related source files with a markdown link.
2. Display a list of related documentation files in the chat.
3. Evaluate if any documentation files need to be updated based on the changes and inform the user:
   - Display what should be updated, why it should be updated and in which files.
