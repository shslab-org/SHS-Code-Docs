# GUI — Agent Panel

The conversational coding surface, with everything the CLI run gives you.

## Chat

- Type a task, press Enter. The run starts on the session's WebSocket
  (`/ws/chat/{session-id}`).
- **Live token streaming**: `llm_delta` frames append to a growing message —
  you watch the answer form in real time. When the final answer equals what
  already streamed, it is not printed twice.
- The final `agent_done` frame carries the output, the run state, the
  **finish reason** (`final_answer`, `terminate`, `max_steps`, …), and the
  step count.

## Activity feed (right side)

Internal runtime events — tool starts/ends, steps, checkpoints, plan
creation, rate-limit waits, task lifecycle — as they happen. This is the
debug/progress view; it is intentionally **separate from the chat**: an
internal event never becomes an assistant message.

## Run controls

- **New** — start a fresh session id (`gui-<timestamp>`)
- **■ Cancel run** — cancels the running task (`POST /sessions/{id}/cancel`);
  state is checkpointed, so the task can be resumed
- **Session field** — paste an existing session id to continue it (the agent
  re-injects that session's conversation history)
