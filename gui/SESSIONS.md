# GUI — Sessions Panel

Session history and continuation.

- **List** (`GET /sessions`): id, goal, state, steps, start time
- **Messages** (`GET /sessions/{id}/messages`): every stored message with
  its **kind** badge:
  - `final` — genuine dialogue turns (what conversation replay uses)
  - `interim` — mid-run assistant narration ("Let me check the tests…"),
    stored for transparency, excluded from replay
- **Continue** — loads the session into the Agent panel (same WebSocket
  channel, history re-injected) so the conversation continues with full
  context

Sessions started from the CLI appear here too — one registry, one truth.
