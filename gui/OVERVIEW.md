# GUI — Overview

- **Location**: `app/server/static/gui.html`, served at `/gui` by `shscode-server`
- **Stack**: plain HTML + CSS + JS (no build step, no npm) — one file, ~55 KB
- **Backend**: the SHS-Code FastAPI server; every action is a REST call or a structured WebSocket frame

## Starting

```bash
shscode-server --port 8765
# → http://localhost:8765/gui
```

With an API key set (`SHSCODE_API_KEY`), open `/gui?api_key=YOUR_KEY` —
the key is sent as the `X-API-Key` header on REST calls and as a query
parameter on the WebSocket upgrade.

## The shared-state principle

CLI and GUI are two views of ONE runtime. Concretely:

| State | Where it lives | Used by |
|---|---|---|
| Sessions + messages | `workspace/.sessions/shscode.db` | both |
| Task journal + DAG + checkpoints | `~/.shscode/state/journal.db` | both |
| Long-term memory | `workspace/.memory/long_term.db` | both |
| Provider config | `~/.shscode/config.*` (0600) | both |
| Git state | the repository itself | both |

Starting a run in the GUI and continuing it in the CLI (`shscode --continue`,
or `--session <id>`) works — and vice versa (GUI Sessions panel → Continue).

## Auth model

- No key configured (local dev): everything is open.
- `SHSCODE_API_KEY` set: all REST endpoints and WebSockets require it.
- Secrets (LLM keys) are always masked in API responses — the GUI never
  displays a raw key.
