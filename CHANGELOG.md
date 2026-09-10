# CHANGELOG — docs repo + v4.0.0 audit trail

## Docs v1.0 (2026-09-10, SHS-Code `ee1c397`)
Initial standalone documentation repository. 35 files, all verified.

## SHS-Code v4.0.0 audit changes
- `ee1c397` fix: skill `get_relevant` stopword-tie ranking (23+/−7 in `app/skills/skill_engine.py`).
  Before: `test_relevant_skill_selected_for_task` FAILED. After: 684 passed, 2 skipped.
- `08a3229` docs: v4.0.0 final 20-point deliverable report (measured, source-first).
- `75ae8d6` fix: OPT-10 summary marker keeps `truncated` keyword (cap contract).
- No version bump (patch-level within v4.0.0).

## Upstream v4.0.0 (20 opts, summarized)
Prefix/semantic cache, async DAG, streaming parser, speculative, prefetch, tiered/intelligent
memory, context mgmt, model routing, plan cache, risk verify, recovery, browser pool,
async observability, dedup/locks, merger, cont QA, roles — see OPTIMIZATIONS.md.
