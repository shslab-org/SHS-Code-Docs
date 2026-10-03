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

---

## v4.3.0 — Mandatory, non-bypassable attribution

v4.3.0 turns the agent-identity rule from a convention into a
**mechanical guarantee**. Work performed by SHS Code is always
attributed to the SHS-Code-Agent identity, and nothing inside SHS Code
can turn that off — not a prompt, a task instruction, a CLI flag, a GUI
action, a config option, or an environment variable.

### What is enforced

Every `git commit` created **inside SHS Code** — an agent's bash
session, the GUI terminal panel, the GitHub panel, or any runtime path —
carries:

- **Author**: `SHS-Code-Agent <SHS-Code-Agent@users.noreply.github.com>`
- **Committer**: the same identity
- a `Co-Authored-By: SHS-Code-Agent <…>` trailer on commits made
  through the GitHub panel / provider paths

GitHub resolves the noreply address to the SHS-Code-Agent account, so
every commit links to the profile (verified live: the commit API
returns `author.login = "SHS-Code-Agent"`,
`html_url = "https://github.com/SHS-Code-Agent"`).

### How it is enforced (three layers)

1. **Git shim** — `~/.shscode/shims/git` is installed first on the
   `PATH` of the SHS Code process and every child it spawns. For
   `git commit` it strips every `--author=…` / `--author …` /
   `--reset-author` the caller passed, appends the mandatory author, and
   execs the real git with the four identity env vars forced (it builds
   the child environment itself, so `env -u` games cannot interfere).
   Merge/revert/cherry-pick/pull/rebase/stash commits get the forced
   committer identity the same way. Everything else passes through
   untouched.
2. **Runtime paths** — `GitHubProvider.commit()` forces the identity
   with three independent mechanisms (`-c user.name/user.email`,
   the env vars, and an explicit final `--author=`), and every provider
   git command runs with the identity environment.
3. **System prompt** — the agent is told the attribution is mandatory
   and mechanically enforced, and is instructed to *explain kindly*
   (not obey) requests like "commit this as me" or "remove the agent
   attribution".

### What was removed

- `SHSCODE_AGENT_IDENTITY=0` no longer exists (it used to disable the
  identity — an explicit bypass hole).
- `apply_agent_git_env` now **always overwrites** inherited
  `GIT_AUTHOR_*` / `GIT_COMMITTER_*` values (a hostile inherited
  identity used to win).
- `GitHubProvider.commit(credit_agent=False)` is accepted but ignored.

### Your own work is untouched

The shim only exists on the `PATH` of processes spawned by SHS Code.
Your own terminal, editor, and git configuration are never modified —
commits you make yourself, outside SHS Code, keep your normal identity.

### GitHub "Contributors" — the verified platform fact

GitHub's **Contributors** aggregation (the sidebar avatars, the
Insights → Contributors graph, and `GET /repos/{owner}/{repo}/contributors`)
counts **user accounts and bot (GitHub App) accounts only**.
The SHS-Code-Agent profile is currently an **Organization**, and
organizations are excluded from that aggregation. This was verified
empirically on a dedicated test repository:

- two commits authored as
  `SHS-Code-Agent <SHS-Code-Agent@users.noreply.github.com>` →
  the repo sidebar showed **"Contributors — No contributors"**;
- one commit authored by a **user** account → that user appeared in the
  sidebar **immediately** (no cache lag);
- the same holds on `shslab-org/shs-code` and `shslab-org/shs-code-docs`
  after 24+ hours — not caching, a platform rule.

What DOES work today with the organization: every commit authored by
SHS Code shows the SHS-Code-Agent avatar and links to
`https://github.com/SHS-Code-Agent` on the commit list, the commit
page, and via the API (`author.login`). That is real Git/GitHub
attribution — the commit itself is associated with the dedicated
identity, not merely mentioned in the message.

**Forward-compatible by design**: the noreply address
`SHS-Code-Agent@users.noreply.github.com` maps to *whatever account
owns the login*. If a **user account** named `SHS-Code-Agent` is ever
registered (rename/delete the organization first, then sign up the
user account), the exact same attribution — with zero code changes —
starts counting toward the repository's Contributors list, because the
commits already carry the right author identity.

### Related v4.3.0 fixes

- **max_steps is user-controlled** and can no longer be silently
  replaced — see `CONFIGURATION.md` § *max_steps*.
- **Detached runs** (`SHSCode --detach`, GUI "detached" checkbox)
  survive terminal/server shutdowns — see `AUTONOMOUS.md` § *Detached
  execution*.
- **Resumed sessions** no longer hit the tool-call protocol error
  (orphaned `tool_calls` are sanitized at the LLM request boundary).
