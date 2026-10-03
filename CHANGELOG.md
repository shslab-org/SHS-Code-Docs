# CHANGELOG — docs repo + audit trail

## Docs v2.2 (2026-10-03, SHS-Code v4.2.0)
v4.2.0 documentation — existing docs preserved, new docs added:
- `gui/TOUR.md` — **the visual tour: a docs-site page where every GUI
  feature is shown in real screenshots** (12 images in `screenshots/`):
  dashboard, agent chat, Files tab, the new diff-viewer (annotated
  how-to-read-it table), staged mode, changes badge, hidden sidebar,
  full-width diff reading, mobile hidden + drawer, help panel
- `screenshots/` — 12 real PNG captures from a live v4.2.0 session
- `MESSAGING.md` — all 12 messaging adapters now fully implemented
  (Discord Gateway, Slack Socket Mode, Teams Bot Framework OAuth,
  Google Chat service-account JWT + send-URL bug fix, Email IMAP
  polling), env-var matrix, webhook routes, gateway architecture
- `gui/WORKSPACE.md` — Files/Changes tabs, diff-viewer, three
  comparison modes, server-side behavior, safety notes
- `GITHUB_AGENT.md` — v4.2.0 "agent everywhere" attribution: author +
  committer + co-author forced via `-c` overrides and
  `GIT_AUTHOR_*`/`GIT_COMMITTER_*` env at CLI/server startup; opt-out
  `SHSCODE_AGENT_IDENTITY=0`; the v4.0.1 bash-commit limitation is
  resolved
- `GUI_GUIDE.md` — workspace chapter rewritten for the two-tab
  diff-viewer (mirrored from shs-code)
- `gui/README.md` — Workspace row updated + Visual Tour callout
- README — version 4.2.0, TOUR + MESSAGING links, honest status
  (824 passed / 3 skipped, 826 collected, CI green)
- SHS-Code v4.2.0 (pushed @ 99be8a4, CI green): diff-viewer, CI pytest workflow,
  messaging completed, agent identity everywhere; commits on main now
  authored by SHS-Code-Agent

## Docs v2.1 (2026-10-03, SHS-Code v4.1.0)
v4.1.0 documentation — existing docs preserved, new docs added:
- `GUI_GUIDE.md` — complete 15-chapter plain-language GUI manual for
  non-programmers (mirrored from shs-code `docs/GUI_GUIDE.md`): layout,
  nav slide/hide, first-task walkthrough, all 14 panels, honest finish
  reasons, task statuses, Git/GitHub safety, data locations,
  troubleshooting, FAQ, CLI↔GUI cheat sheet
- `gui/HELP.md` — the new 14th panel (in-app Help / Guide) + the
  collapsible navigation feature (three toggle paths, localStorage
  persistence, mobile drawer mode)
- `gui/README.md` — Help panel row + Collapsible navigation section
- README — GUI_GUIDE links in run-modes table and doc map
- SHS-Code v4.1.0 (pushed, 776 tests green): slide/hide sidebar,
  Help panel, QA-panel badge fix (Python `True` leaked into JS)

## Docs v2.0 (2026-10-03, SHS-Code v4.0.1)
Full v4.0.1 documentation pass — all existing docs preserved, new docs added:
- `gui/` — 14 files: README index + Overview/Dashboard/Agent/Tasks/Team103/
  Workspace/Terminal/Git/GitHub/QA/Sessions/Memory/Logs/Settings
- `GITHUB_AGENT.md` — SHS-Code-Agent identity, GitHub App tokens, trailer,
  GitHubProvider facade, token hygiene
- `TASK_SYSTEM.md` — finish reasons, the `partial` state, strict DAG
  dependencies, plan gate, response-channel cleanliness
- `STREAMING.md` — SSE token streaming end-to-end
- README: v4.0.1 status (755 passed), GUI row in run modes, updated
  learning path + map + honest known-limits

SHS-Code v4.0.1 (verified live against the Agnes API, fresh installs):
- Task lifecycle integrity: finish-reason tracking, `partial` journal state,
  plan-gated DONE patterns, strict DAG dependencies, no fake completion
- Response channel: final answer only; interim/final session message kinds
- Token streaming: UniversalClient SSE + on_delta plumbing, CLI live line,
  WS `llm_delta` frames for the GUI
- Full GUI at `/gui` (13 panels, shared runtime, no duplicated logic)
- SHS-Code-Agent GitHub identity + GitHubProvider + CLI `/github` +
  server `/github/*` endpoints
- Team103 production entry points (CLI `/team103`, `POST /team103`) +
  honest confidence/QA gates
- Multi-socket WS fan-out, session continuation over REST, packaging fixes
  (fastapi/uvicorn core; package-data for static+skills)
- Live-testing bug fixes: tool-args always valid JSON; ENVIRONMENT
  working-directory injection
- Tests: 708 → 755 passed (+47 regression tests)

## Docs v1.1 (2026-09-11, SHS-Code `3dad673` fix stack; prior `ee1c397`)
Surgical doc sync to final code: 708 passed / 37 v4 tests; `--help` entries, semantic-cache O(1), secrets auth, LLM failover partial-fix. Prior v1.0 below unchanged.
Initial standalone documentation repository. 35 files, all verified.

## SHS-Code v4.0.0 audit changes
- `ee1c397` fix: skill `get_relevant` stopword-tie ranking (23+/−7 in `app/skills/skill_engine.py`).
  Before: `test_relevant_skill_selected_for_task` FAILED. After (`ee1c397`): 684 passed, 2 skipped; post-fix stack (`3dad673`): 708 passed, 2 skipped.
- `08a3229` docs: v4.0.0 final 20-point deliverable report (measured, source-first).
- `75ae8d6` fix: OPT-10 summary marker keeps `truncated` keyword (cap contract).
- No version bump (patch-level within v4.0.0).

## Upstream v4.0.0 (20 opts, summarized)
Prefix/semantic cache, async DAG, streaming parser, speculative, prefetch, tiered/intelligent
memory, context mgmt, model routing, plan cache, risk verify, recovery, browser pool,
async observability, dedup/locks, merger, cont QA, roles — see OPTIMIZATIONS.md.
