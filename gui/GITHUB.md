# GUI — GitHub Panel

GitHub integration and the automation identity.

- **Identity card** (`GET /github/status`): SHS-Agent profile link,
  auth mode (`app` = GitHub App installation token, `pat` = personal
  access token), authenticated account, local branch state, and the commit
  trailer in use.
- **Pull requests** (`GET /github/prs?repo=owner/name`): open PRs with
  number, title, state, author.
- **Issues** (`GET /github/issues?repo=owner/name`).
- **Create PR** (`POST /github/pr`): repo, head → base, title, body, draft
  flag.

## Auth configuration

Priority: GitHub App installation token → `SHSCODE_GITHUB_TOKEN` →
`GITHUB_TOKEN` → `~/.shscode/connectors`. See
[GITHUB_AGENT.md](../GITHUB_AGENT.md) for the full identity documentation.
