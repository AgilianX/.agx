# Commit Standard

This document outlines our internal commit message standard, designed to improve clarity, automation, and collaboration across teams.

> [!NOTE]
> It is based on the [Conventional Commits](https://www.conventionalcommits.org/) specification and extended with ergonomic conventions that support semantic versioning, CI/CD workflows, changelogs, and more.

---

## Structure

A commit message consists of:

```xml
<type>(<scope>): <summary  short description>

- <bullet describing what, why or how it changed, if relevant>
- <bullet>
...
- <bullet>

<metadata +key:value>
```

Notes:

- **Scope** is optional but recommended. Omit the brackets if not used.
- **Metadata** are prefixed with `+` and placed on the final lines.

> [!WARNING]
> Multiple scopes are allowed, separated by commas. For example: `feat(auth,ui): add login button`.
> Avoid using multiple types in a single commit message and use more atomic commits when possible.

---

## Accepted Commit Types

| Type       | Purpose                                                            |
|------------|--------------------------------------------------------------------|
| `feat`     | Introduces a new feature                                           |
| `fix`      | Fixes a bug                                                        |
| `chore`    | Routine tasks: configs, build scripts, formatting, etc.            |
| `refactor` | Code change that neither fixes a bug nor adds a feature            |
| `test`     | Adding or updating tests                                           |
| `style`    | Code style or formatting changes                                   |
| `perf`     | Performance improvements                                           |
| `revert`   | Reverts a previous commit                                          |
| `repo`     | Changes to the repository itself (e.g. .gitignore,  git hooks)     |
| `ci`       | CI/CD pipeline and build-related changes                           |
| `ai`       | AI agent instructions, prompts, workflows, or configuration files  |
| `docs`     | Documentation of the source code or solutions provided in the repo |
| `learn`    | Documentation related to research                                  |

> [!TIP]
> If the commit has [multiple types](#clarification-on-commit-types-with-mixed-changes), use the most relevant one. For example, if adds a feature,
and documents it, use `feat`.

---

## 🔀 Merge Commit Message Conventions

Merge commits must follow the same enhanced standard, with emphasis on clarity, semantic relevance, and tooling compatibility.

### 📥 Merge Types & Patterns

| Merge Type                  | Format Example                                              |
|-----------------------------|-------------------------------------------------------------|
| **Feature → Develop**       | `feat(auth): merge feature/auth-oauth into develop`         |
| **External PR → Develop**   | `feat(auth): merge external feature/auth-oauth into develop`|
| **Bugfix → Develop**        | `fix(api): merge bugfix/fix-null-response into develop`     |
| **Hotfix → Master/Develop** | `fix(0.3.2): apply hotfix v0.3.2 to master and develop`     |
| **Release → Master/Develop**| `release(0.4.0): finalize release v0.4.0`                   |

### 🧩 Template for Merge Commits

```xml
<type>(<scope>): merge <source> into <target>

- Summary of the branch purpose
- Optional list of key changes or areas affected
- Credit to the author of the branch (if external)

+semver:<level>
+issue:#<id>
```

---

## 🧩 Metadata Footer Format

> [!NOTE]
> All machine-readable metadata must be placed in the **footer**, on the final line(s) of the commit message.

Each entry:

- Begins with `+`
- Uses a `key:value` format
- Is separated by new lines

[gitVersion]: https://gitversion.net

### Control version bumping with `+semver`

Use `+semver` to explicitly control how [GitVersion][gitVersion] bumps the version for a commit. Place this in the metadata footer. This is useful for ensuring the correct semantic version is applied, regardless of the commit type.

> [!NOTE]
> This overrides the default configured behavior of GitVersion.

| Level                  | Pattern            |
|------------------------|--------------------|
| Major                  | `major`/`breaking` |
| Minor                  | `minor`/`feature`  |
| Patch                  | `patch`/`fix`      |
| Skip - no version bump | `skip`/`none`      |

**Example**: `+semver:minor`

---

### Link to issues or pull requests with `+issue`

Use `+issue` to reference one or more issues or pull requests related to the commit. Use `#` for issues/PRs in the same repository. For external issues, provide the full URL.

> [!NOTE]
> Most IDEs and GitHub will autocomplete issue numbers when you type `#` in the commit message.

**Examples**:

- `+issue:#342`
- `+issue:#123,#234`
- `+issue:https://github.com/org/repo/issues/1`

---

### Trigger CI/CD Nuke build targets with `+nuke` (planned, not implemented)

Use `+nuke` to trigger specific [Nuke](https://nuke.build/) build targets in your CI/CD pipeline.

> [!TIP]
> This can be used by automation to run or test only the specified targets.

**Example**:

- `+nuke:feature`
- `+nuke:feature,test`

---

### Request a review from a GitHub user with `+review`

Use `+review` to request a review from a specific GitHub user. Mention the reviewer with `@githubusername`.

> [!NOTE]
> Most IDEs and GitHub will autocomplete usernames when you type `@` in the commit message.

**Example**: `+review:@Xeythhhh`

---

### Signal a Breaking change with `+BREAKING`

Use `+BREAKING` to indicate a breaking change in the commit.
This is useful for tooling that needs to identify breaking changes in the commit history.

> [!CAUTION]
> Append a '!' to the type in the header to indicate a breaking change. This is a standard practice in conventional commits.

**Example**:

```commit
feat(auth)!: implement OAuth2 provider support

- Added external identity provider integration

+BREAKING: Existing SSO flows must be updated
```

### Reference git refs with `+ref`

Use `+ref` to reference a specific git ref, such as a branch, tag or commit. This is useful for linking to specific points in the commit history.

> [!NOTE]
> This is typically used when reverting a change

**Example**:

```commit
revert(auth): revert custom OAuth2 provider support

- Reverted custom OAuth2 provider support in favor of nuget package

+ref: 676104e, a215868
```

---

*This list is extensible — future metadata tags may be added as tooling evolves.*

---

## 🔠 Format Examples

### 🟢 Minimal Commit

```text
feat: add login button
```

### 🟡 Typical Commit With Body

```text
fix(auth): prevent double form submission

- Added submit lock to prevent re-triggering
- Prevents rapid keypresses on Enter
```

### 🔵 Commit With single Metadata

```text
chore(assets): move icons to Icons folder

- Cleaned up folder structure for clarity
- Updated all import paths to match

+issue:122
```

### 🟣 Commit With multiple Metadata

```text
chore(assets): move icons to Icons folder

- Cleaned up folder structure for clarity
- Updated all import paths to match

+issue:122
+nuke:test
```

### 🔴 Commit With multiple Metadata, including BREAKING CHANGE

```text
feat(auth)!: implement OAuth2 provider support

- Added external identity provider integration
- Refactored login and token validation logic

+BREAKING: Existing SSO flows must be updated
+semver:minor
+issue:#340,#420
+nuke:feature
+review:@Xeythhhh
```

---

### AI Type

AI agent instructions, prompts, workflows, or configuration files (e.g., `ai.*`, `*.prompt.md`, or Copilot-related files) should be committed with the `ai` type.

> [!NOTE]
> This includes any changes to the AI agent's behavior, configuration, or instructions.

### Clarification on Commit Types with Mixed Changes

If a commit contains both documentation and code changes, the commit type should reflect the most significant change. For example:

- If the commit introduces a new feature and includes documentation for that feature, use `feat`.
- If the commit fixes a bug and includes documentation for the fix, use `fix`.
- If the commit adds, updates, renames or removes AI agent instructions, prompts, workflows, or configuration (such as ai-instructions.*, or copilot related files), use `ai`.
- For research documentation, between `docs` and `learn`, use `learn`.

> [!WARNING]
> The `docs` or `learn` types should only be used for commits that contain **only** documentation changes, with no other code modifications, and do not affect AI agent instructions, prompts, workflows, or configuration. They have the lowest significance. They should not be used if there are any other types of changes present.
