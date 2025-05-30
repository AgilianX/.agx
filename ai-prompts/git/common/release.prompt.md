---
mode: agent
---
workflow: git

# Goal
Generate a standards-compliant release commit and tag, finalizing a new release on the `master` branch.

**IMPORTANT**
- Follow the [Commits.md](../../../docs/conventions/Commits.md) specification precisely.
- Never use `git merge`, always use `git agx-ai-release {source-branch}` WITHOUT ADDITIONAL ARGUMENTS to open the editor with the message for review.
- Never leak implementation details in commit messages.

---

## Step 1: Analysis
1. Determine the source branch (defaults to the active branch unless overridden by the user in the prompt).
2. Determine the target branch (defaults to `master` unless overridden by the user in the prompt).
3. Display information about the source and target branches in the chat and await confirmation.
4. If the source branch is different from the active branch, check out the source branch.
5. Command: `git agx-ai-status` on the source branch will check for uncommitted changes.
   If any are found, abort and notify the user.
6. Command: `dotnet-gitversion` will determine the current version and the next version to be released.
   Extract `{MajorMinorPatch}` from the output.
7. Command: `git tag -l` will list all tags in the repository.
   If tags are found, set `{last-semver-tag}` to the latest semantic versioned tag on `master`.
8. Command: `git agx-ai-log {last-semver-tag}..{source branch}` will gather the list of commits
   Since the last semantic versioned tag on `master`.
   If no tags exist, included all commits on the source branch.

## Step 2: Message Formation
- Command: `git show {existingTag}` can be used to reference existing tags for inspiration to keep a consistent style.
1. Draft the merge commit message as:
  `release({MajorMinorPatch}): finalize release`
2. Draft the tag message as:
   ```
   v{MajorMinorPatch}: {Release name or Feature Summary}
   - Bulleted list summarizing the changes since the last tag.
   Full Changelog: {last-semver-tag}..{last-commit-on-source-branch}
   ```
   If a release name is not provided with the prompt, generate it based on the included commits.
   Be creative, something catchy but not misleading! Display it in chat for confirmation.
3. Iterate at least 3 times and with each iteration, attempt to improve compliance,
   remove obvious or repetitive information and rephrase to shorten the content where being explicit is not critical.
4. Ensure message is concise, clear, and focuses on WHAT changed (not HOW).
5. Check that bullet points add meaningful context.

## Step 3: Finalize
1. Display the final draft commit and tag messages in a code block in chat. (no user confirmation needed)
2. Write the  merge commit message to `.agx/ai-prompts/git/temp/ai-commit.txt`.
   Note that `.agx` can be a repository or a submodule, the path may vary.
   Modify the file. On fresh forks or clones you may need to create it.
3. Write the tag message to `.agx/ai-prompts/git/temp/ai-tag.txt`.
   Note that `.agx` can be a repository or a submodule, the path may vary.
   Modify the file. On fresh forks or clones you may need to create it.
4. Check out the target branch.
5. Command: `git agx-ai-release {source-branch}` will open the merge commit editor with the message for review and refinement. Run it after:
    - showing the commit and tag drafts to the user.
    - editing the `ai-commit.txt` file.
    - editing the `ai-tag.txt` file.
6. After the merge, run `git tag -a v{MajorMinorPatch} -F {path-to-ai-tag.txt}`
7. Remove all the content of the `ai-commit.txt` and `ai-tag.txt` files after the release is completed to avoid stale messages.
