# GITHUB — SHS-Code v4.0.0 (verified provider module)

Provider: `app/git_providers/github/` (verified dir) under `GitProviderService` base
(rate-limit, backoff retry, `get_repos/get_repo/get_branches` + async variants).

## Setup
1. Create token (GitHub web UI — environmental, UNVERIFIED here).
2. Register: connectors store via `/connectors` or `get_connectors().add("github", …)`.
3. Verify: `list(masked=True)` shows entry without leaking token.

## Workflows
- `python main.py "clone <url> and summarise the repo"` (needs git + network).
- Branch/commit/push/PR flows via agent + `bash` + provider API.
- Suggested-tasks helper: `app/git_providers/suggested_tasks.py` (verified file).

Limits: API quotas/rate-limits apply; large repos pay cold-index cost (see PERFORMANCE.md).
