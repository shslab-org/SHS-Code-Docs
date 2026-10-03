# GUI — Dashboard

The landing panel: a live summary of the whole system.

| Card | Source endpoint | Shows |
|---|---|---|
| Agent Runtime | `GET /config` | provider, model, base URL, version, token budget |
| GitHub Identity | `GET /github/status` | SHS-Agent identity, auth mode (app/pat), authenticated account |
| Local Git | `GET /git/status` | branch, working-tree changes, last commit |
| Recent Tasks | `GET /tasks?limit=8` | journal task rows with lifecycle badges |
| Sessions | `GET /sessions?limit=8` | session registry with state badges |

The header always shows the active provider · model. Press **↻ Refresh**
(or re-enter the panel) to reload.

Task status badges: `completed` green · `partial` yellow (stopped before
verified completion — resumable) · `failed`/`blocked` red ·
`in_progress`/`running` blue · `pending`/`queued` gray.
