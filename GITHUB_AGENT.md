# GitHub Agent & the SHS-Code-Agent Identity

> Verified against SHS-Code v4.2.0 source: `app/git_providers/agent_identity.py`,
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

## Commit attribution — the agent, everywhere (v4.2.0)

Every commit made by SHS-Code — CLI or GUI — is attributed to the agent
profile as **author, committer and co-author**:

```
author:    SHS-Code-Agent <SHS-Code-Agent@users.noreply.github.com>
committer: SHS-Code-Agent <SHS-Code-Agent@users.noreply.github.com>

…commit message…

Generated with SHS-Code

Co-Authored-By: SHS-Code-Agent <SHS-Code-Agent@users.noreply.github.com>
```

Mechanisms (all three, together):

1. **Per-command `-c` overrides** — `GitHubProvider.commit()` forces
   `user.name` / `user.email` for author AND committer without touching
   the user's global or repo git config. `/github commit` (CLI), the GUI
   Git panel, and `/github/commit` (server) all flow through this one
   implementation. `pull()` merge commits are attributed the same way.
2. **Process environment** — CLI and server startup export
   `GIT_AUTHOR_NAME` / `GIT_AUTHOR_EMAIL` / `GIT_COMMITTER_NAME` /
   `GIT_COMMITTER_EMAIL` for the agent profile, so ANY child-process
   `git commit` — the agent's bash tool, the GUI terminal panel, cron
   jobs — inherits the same attribution.
3. **Trailer + footer** — the `Co-Authored-By` trailer (GitHub's
   officially supported collaborator credit; GitHub renders the profile
   link when the email maps to an account) and the `Generated with
   SHS-Code` footer stay on every commit.

Opt-out: `SHSCODE_AGENT_IDENTITY=0` keeps the host's default git
identity (the trailer is still added to provider commits).

The v4.0.1 “known limitation” (bash `git commit` attribution depended
on the model writing the trailer) is **resolved** by mechanism 2.

## GitHubProvider — the centralized facade

`app/git_providers/github_provider.py` is the ONE implementation both CLI and
GUI call:

- **Local git**: clone (token-scrubbed remotes), branch, commit (agent
  author + committer + trailer), push (one-shot authenticated URL — the
  stored remote is never rewritten), pull (attributed merges), stash,
  diff, log
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
