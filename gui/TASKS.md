# GUI — Tasks Panel

The persisted task journal — the honest lifecycle record.

## Task list

`GET /tasks` — every task with: id, goal, **status**, step count, tool
count, and the blocked/partial reason when present.

## Task detail + DAG

Click a row: `GET /tasks/{id}` returns the task row, its **DAG nodes**, and
the journal event tail. The DAG renders wave-by-wave (dependency depth),
each node colored by state:

| State | Color | Meaning |
|---|---|---|
| pending | gray | not started |
| ready | cyan | dependencies satisfied, runnable |
| active / retryable | yellow | executing / retrying |
| completed | green | finished (v4.0.1: only when every dependency was completed or explicitly skipped) |
| failed / blocked | red | errored / waiting on the user |
| skipped | gray | explicitly skipped with a reason |

## The lifecycle rules (v4.0.1)

- `completed` is recorded ONLY for runs that finished with a verified final
  answer (`final_answer`, `terminate`, or a plan-gated `done_pattern`).
- Budget exhaustion (`max_steps`, `token_budget`) records **`partial`** —
  explicitly NOT completed; `/resume` continues from the checkpoint.
- A "done" claim with unfinished plan steps does not end the run; the plan
  gate nudges the model to finish or explicitly skip the remainder.
