---
mode: agent
---

Determine if any open issue is related.

- Tool: `#mcp_github_list_issues` will list open issues.
- Tool: `#mcp_github_get_issue <number>` will provide detailed context for a specific issue.
1. Determine if changes directly address any open issues.
2. Include issue metadata (as per the specification) only when changes directly resolve or address an issue
   and is undeniably related.
   Include additional metadata only if instructed.
3. If any issues are related and included in the commit,
   briefly summarize them in the chat before drafting the commit message.
