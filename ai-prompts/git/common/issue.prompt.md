---
mode: agent
---
workflow: git

# Goal
Produce a fully compliant issue efficiently. Follow these steps exactly.

**IMPORTANT**
- Before starting the workflow, follow these additional preparation [instructions](../tasks/prepare.instructions.md)
- Use only existing labels; never create new ones.
- Use safe defaults or ask the user if a task is ambiguous.
- Keep issues concise, clear, and human-readable.
- Structure and scope the issue description to requirements.
- Strictly follow the [Issues.md](../../../docs/conventions/Issues.md) specification.
- Fetch and follow this template [New Feature Template](https://raw.githubusercontent.com/AgilianX/.github/refs/heads/master/.github/ISSUE_TEMPLATE/feature.yml).
- Do not wait for user confirmation unless the step explicitly requires it.

---

## Step 1: Context
- Tool: `#mcp_github_list_issues` will list open issues.
- Tool: `#mcp_github_get_issue` will provide detailed context for a specific issue.
- Command: `git agx-ai-status` will show the staged files.
- Command: `git agx-ai-diff-staged` will show the staged diff changes.
1. Analyze the staged files and changes to determine the type of changes made.
2. Summarize the changes into an issue draft.

## Step 2: Relevance Check
1. Compare the new issue draft against open issues.
2. If changes directly address an existing issue, do not create a new one.
   Inform the user about the existing issue and its number and ask if they want to abort the workflow.
3. If the new issue could be a child(sub-issue) of an existing issue, notify the user and wait for instructions.

## Step 4: Draft & Refinement
1. Draft the issue. Iterate at least 3 times and with each iteration, attempt to improve clarity and compliance,
remove obvious or repetitive information and rephrase to shorten the content where being explicit is not critical
without losing the essence and goal of the issue.
2. Add only existing labels. If label info is unavailable, note this in chat and continue.

## Step 5: Finalize
1. Display the final issue in chat.
2. Wait for user confirmation when you believe the draft is final.
3. Tool: `#mcp_github_create_issue ` will create the issue.
   Use this if the draft is approved by the user.
   If the issue is meant to be a sub-issue, make sure it is created as a sub-issue of the parent issue.
