# MULTI_AGENT — SHS-Code v4.0.0 (verified)

## Entry (verified `--help`)
```bash
python run_multi_agent.py "add JWT auth to the API" --mode build
python run_multi_agent.py "plan the migration" --mode plan   # approval-gated
```
`shscode-multi` → `app.multi_agent:run_cli`. Server: `POST /multi-agent`.

## Real architecture (verified `app/agent/orchestrator.py`, `app/multi_agent.py`)
- `MultiAgentOrchestrator(mode=PLAN|BUILD)`, `async run(goal)`.
- Triage: simple → single role; small → few roles; complex → full 4-role pipeline
  **PM → Architect → Engineer → QA** run **serially via dependency events**.
- Each role = full LLM loop (`app/agent/roles/*.py` → `BaseRole.run` → LLM + tools).
- Request amplification ~4x under shared RPM cap (POSTMORTEM weakness #1).

## Use when
Decomposable coding projects. Simple questions stay single-agent (no overhead).

## Example
```bash
python run_multi_agent.py "add pagination to GET /sessions" --mode build
```
Expected: `PIPELINE OUTPUT:` block with merged result; `/tasks` shows stages.
