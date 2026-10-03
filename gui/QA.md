# GUI — QA Panel

Run the project-aware VerificationEngine — the SAME engine the agent's
`verify` tool uses (`POST /qa/verify`).

- Auto-detects the project type (Python/JS/…) from the intelligence index
- Runs the relevant checks: build, tests, lint, typecheck
- Results render per-check PASS/FAIL with output excerpts

The GUI calls the shared runtime directly — verification results are
identical to what the agent sees, never a reimplementation.
