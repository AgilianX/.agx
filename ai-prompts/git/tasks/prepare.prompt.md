---
mode: agent
---
IMPORTANT:
- At the start of an ai workflow set the environment variable `$env:AGX_AI_WORKFLOW = 'true'`.
- At the end of an ai workflow set the environment variable `$env:AGX_AI_WORKFLOW = 'false'`.
- If the `- Workflow type:` is not present in the prompt or not set to `git`, ignore the instructions in this file.

---

1. Command: `Get-Location` will determine the current working directory.
2. Command: `git agx-ai-git-context` will determine the current repository and branch.
3. Ask the user to confirm that the repository is correct, display the repository name.
   Inform the user of the options available, the user may:
   - Confirm
   - Provide a different repository name
   - Link a `Repository.{repositoryName}.md` file with information about the repository.
     Note that the `{repositoryName}` can be different than the current repository name.
4. Verify the repository name matches the output of `git agx-ai-git-context` exactly.
5. If the names do not match, navigate to the correct directory.
6. IMPORTANT: Make sure you are in the repository root displayed by `git agx-ai-git-context`.

Notes: You can run `git agx-ai-git-context` and `Get-Location` anytime when unsure about the terminal context and location.
