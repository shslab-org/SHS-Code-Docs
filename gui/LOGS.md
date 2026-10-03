# GUI — Logs Panel

Live tail of the newest log file (`GET /logs/recent`), auto-refreshing
every 3 s (toggleable).

- Log lines are colored by level (INFO blue, WARNING yellow, ERROR red)
- Logs are SEPARATE from the user conversation by design — internal
  diagnostics live here, never in the chat

Log files rotate under `logs/` (compressed rotation). The panel always
follows the newest file.
