# GitHub Agent & the SHS-Code-Agent Identity

> Verified against SHS-Code v4.0.1 source: `app/git_providers/agent_identity.py`,
> `app/git_providers/github_provider.py`, `app/git_providers/github/service.py`.

## The identity

GitHub work performed by SHS-Code is attributed to the dedicated automation
identity **[SHS-Code-Agent](https://github.com/SHS-Code-Agent)** — not to the
human user.

| Field | Value |
|---|---|
| Name | SHS-Code-Agent |
| Profile | https://github.com/SHS-Code-Agent |
| Trailer email | SHS-Code-Agent@users.noreply.github.com |

## Authentication (priority order)

1. **GitHub App installation token** — the official bot-identity mechanism.
   Configure:
   ```bash
   export SHSCODE_GITHUB_APP_ID=123456
   export SHSCODE_GITHUB_APP_PRIVATE_KEY_PATH=/path/to/key.pem
   export SHSCODE_GITHUB_APP_INSTALLATION_ID=78910
   pip install 'shscode[github-app]'        # PyJWT + cryptography
   ```
   SHS-Code mints the RS256 JWT (10-minute lifetime) and exchanges it for a
   short-lived installation token (cached in-process, refreshed ~60 s before
   expiry).
2. **Personal access token** — `SHSCODE_GITHUB_TOKEN` (preferred) or
   `GITHUB_TOKEN`, or a token stored in `~/.shscode/connectors`.

## Commit attribution

Commits made through the GitHubProvider carry:

```
Generated with SHS-Code

Co-Authored-By: SHS-Code-Agent <SHS-Code-Agent@users.noreply.github.com>
```

The Co-Authored-By trailer is GitHub's officially supported mechanism for
crediting a collaborator; GitHub renders the profile link when the email maps
to an account. Attribution follows GitHub's real model — the commit AUTHOR is
the authenticated account; the AGENT is the co-author. SHS-Code never claims
the organization owns every commit.

**Known limitation (documented honestly):** commits the agent makes directly
via `bash git commit` include the trailer only when the model writes it. Use
`/github commit` (CLI) or the GUI Git panel for guaranteed attribution.

## GitHubProvider — the centralized facade

`app/git_providers/github_provider.py` is the ONE implementation both CLI and
GUI call:

- **Local git**: clone (token-scrubbed remotes), branch, commit (trailer),
  push (one-shot authenticated URL — the stored remote is never rewritten),
  pull, stash, diff, log
- **GitHub API** (via GitHubService): repos, PRs (create/list), issues
  (create/list/comment), code search, webhooks, suggested tasks

CLI: `/github status|commit|branch|push|pull|stash|pop|diff|log|prs|issues|pr`
Server: `GET /github/status|diff|log|prs|issues` ·
`POST /github/commit|branch|push|pull|stash|pr`

## Token hygiene

- Tokens never appear in stored remote URLs (verified by regression test)
- `/github/status` and the GUI identity card show the auth MODE and account
  login — never the token
- Secrets are masked everywhere they could surface (`/config`, logs via
  secret_redaction)
