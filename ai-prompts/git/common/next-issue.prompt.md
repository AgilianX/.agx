---
mode: agent
---
workflow: git

# Goal
Fetch the next issue and implement it.

**IMPORTANT**
- Before starting the workflow, follow these additional preparation [instructions](../tasks/prepare.instructions.md)
- Update the issue status to "in progress" before starting the implementation if the issue is part of a project.
- If the changes are validated, update the issue content.
- The issue will be closed automatically after the commit is pushed, do not close it manually.
- Do not commit or push unless the user validated the changes and instructs you to do so.

---

## Step 1: Fetch the Next Issue
1. Tool: `#mcp-github-list-issues` will list all open issues in the repository.
   - Use the `owner: {owner}` filter to specify the owner.
   - Use the `repo: {repo}` filter to specify the repository.
   - Use the `state: open` filter to fetch all open issues.
   - Use the `sort: created` filter to sort issues by creation date.
   - Use the `direction: asc` filter to get the oldest issue first.
2. Tool: `##mcp_github_get_issue <number>` will provide detailed context about the issue.

## Step 2: Implement the Issue
1. Analyze the issue content and determine the type of changes needed.
2. Inform the user about the implementation plan. DO NOT PROCEED without the user confirming the plan.
3. Keep a consistent code style with the existing codebase. If needed, reference neighboring files for style consistency.
4. If user approved the plan, implement the changes.

### Step 3: Validate Changes
1. After implementing the issue, inform the user about the changes made.
2. Wait for user validation of the changes and provide further instructions.
3. If the user validates the changes, update the issue content.
