# GUI — Team103 Panel

Run the 103-worker execution layer from the browser.

**What it actually is (honest):** 1 PM + 1 Architect + up to 100
lightweight coroutine engineer workers sharing one LLM engine + 1 QA gate.
NOT 103 independent LLM instances. Engineers are real journaled SHSCode
agent runs with per-task timeout, retry, dedup claims, and AIMD dynamic
concurrency.

## Running

Type a large goal → **Execute** → `POST /team103 {goal}`. The result card
shows:

- QA gate verdict (pass/fail + detail)
- PM task count, peak concurrency, average confidence, duration
- Merged (changed) files, conflicts, unresolved items

## QA gate rules (v4.0.1)

The gate fails when: any changed file is missing or EMPTY on disk, the
merge has open conflicts with low confidence, or the aggregate confidence
is below 0.5 (a merge of partial/failed workers cannot pass).
