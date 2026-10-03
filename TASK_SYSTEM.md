# Task System — Lifecycle, DAG, and the No-Fake-Completion Rules

> Verified against SHS-Code v4.0.1 source: `app/agent/base.py`,
> `app/agent/toolcall.py`, `app/state.py`, `app/task_dag.py`.

## Finish reasons

Every run tracks WHY it ended:

| Reason | Meaning | Journal status |
|---|---|---|
| `final_answer` | text answer stood (plan finished / no plan) | `completed` |
| `terminate` | terminate tool accepted (plan gate passed) | `completed` |
| `done_pattern` | keyword "done" — only honored when the persisted plan has NO unfinished steps | `completed` |
| `max_steps` | step budget exhausted mid-work | **`partial`** |
| `token_budget` | token budget + grace exhausted | **`partial`** |
| `error` | unhandled exception | `failed` |
| `permission_denied` | permission rejection | `failed` |
| (REQUIRES_USER errors) | user dependency | `blocked` |

`partial` is the honest middle state: work stopped without a verified final
answer. The task is explicitly NOT completed; `/resume` continues from the
checkpoint; the user-facing response states plainly that the task did not
finish.

## Task DAG states

`pending → ready → active → completed | failed → retryable | skipped | blocked`

Strict dependency semantics (v4.0.1): a node may only be marked completed
when EVERY dependency reached `completed` or was **explicitly skipped** with
a reason. The old silent auto-completion of active dependencies was removed
— it reported unfinished work as done.

## The plan gate

Before a text answer or terminate is accepted (once real work has started),
the agent reloads the persisted DAG and checks for unfinished steps:

1. Unfinished steps + nudge budget left → the model is nudged to continue
   executing (bounded: 3 nudges)
2. Budget exhausted → the answer stands (a plan-stuck model still delivers)
3. No plan / no journal → the answer stands (pure Q&A)

## Response channel cleanliness

- `agent.run()` returns the **final answer only**
- Raw tool outputs / retry diagnostics / terminate markers live in
  `agent.last_run_step_outputs` for GUI/debug consumers
- Session DB separates message kinds: `final` (replayed as conversation) vs
  `interim` (mid-run narration — visible in the session browser, never
  replayed)
- Background-task failures RAISE — the TaskQueue records `FAILED`, never
  `COMPLETED` with a failure message
