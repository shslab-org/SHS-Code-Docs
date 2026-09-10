# AUDIT — SHS-Code v4.0.0 final (source-first, measured)

## Scope
Full spec §1–§25 at commit `ee1c397` (post skill-ranking patch). Method:
INSPECT → VERIFY → TEST → FIX → RE-TEST → REGRESSION → USER WORKFLOW → RE-MEASURE → DOCUMENT.

## A. What v4.0.0 can actually do
Single-agent CLI/shell, autonomous bounded loop, multi-agent 4-role pipeline,
Team103 bounded pool, 23 tools, 29 skills, MCP client+server, tiered/intelligent memory,
server REST/WS + pages, cron, webhooks(HMAC), SSH gateway (asyncssh), sandbox backends,
browser pool, git providers (5), verification tiers, context condenser.

## B. Works reliably
CLI one-shot + shell, file edit/run/verify loop, sessions/resume, `/doctor`,
server REST/WS, cron CRUD, webhook HMAC path, skill CRUD + ranking (post-fix),
memory tiers, DAG fan-out, streaming parse, async logging, Team103 synthetic stress.

## C. Works with configuration
Real LLM providers (keys + base_url + model), browser (extra + chromium),
server auth/CORS (keys), SSH (asyncssh + keys), sandbox docker (daemon),
git providers (tokens), Ollama/local (daemon + extra).

## D. Experimental
Speculative exec (module verified, policy UNVERIFIED), `data_viz` (flag-gated),
`open_shell` sandbox backend, channels surface (entry verified, flags UNVERIFIED).

## E. Incomplete
Per-request LLM-path failover (whole-run only); semantic-cache scale (difflib O(n));
cold-index compute (prefetch hides, not removes); MCP auth minimal.

## F–H. Difficult / confusing / gaps
Provider/model env matrix; 103-agent naming (NOT 103 LLMs — documented);
micro-benchmark vs real-workload confusion (documented with §19 rule);
Termux expectations (explicitly unsupported); channels flags gap.

## I. Bugs found
1. Skill `get_relevant` stopword-tie burial → FIXED (`ee1c397`), regression suite green.
2. `run_flow.py --help` side-effect PlanningFlow errors (agent-not-idle) — noted, not patched (needs owner triage).
3. `python -m shscode` / `python -m app.server` don't work — documented correct entries.

## §19 FEATURE STATUS MATRIX (spec §19 — exists ≠ works ≠ production-ready)

| Feature | Exists | Implemented | Tested | Works | Beginner Guide | Notes |
|---|---|---|---|---|---|---|
| Single-agent CLI one-shot | yes | yes | yes | reliable | QUICKSTART, SINGLE_AGENT | `python main.py "task"` verified |
| Interactive shell + slash cmds | yes | yes | yes | reliable | USAGE, CLI_REFERENCE | bare `--help`→`/help` mapping (uncommitted fix, tested) |
| Autonomous bounded loop | yes | yes | yes | reliable | AUTONOMOUS | max_steps 30, stuck_threshold 3 |
| Multi-agent PM→Arch→Eng→QA | yes | yes | yes | works, serial 4x amplification | MULTI_AGENT | `run_multi_agent.py --mode build\|plan` |
| Team103 bounded pool | yes | yes | yes (synthetic) | works-synthetic, LLM-bound in prod | TEAM_103 | NOT 103 LLMs; AIMD 8→100; API `run_team103` |
| 23 tools | yes | yes | yes | reliable | TOOLS | `GET /tools`; parallel DAG dispatch |
| 29 built-in skills | yes | yes | yes (post-ee1c397 fix) | reliable | SKILLS, BEGINNER L5 | ranking fixed; keyword-tag discovery |
| Custom skills CRUD | yes | yes | yes | reliable | SKILLS | `SHSCODE_SKILLS_DIR`, patch/disable |
| MCP client (stdio/SSE) | yes | yes | yes | works with config | MCP | `run_mcp.py --interactive` |
| MCP server | yes | yes | yes | works, minimal auth | MCP | `run_mcp_server.py --port 8000` |
| Tiered memory L1/L2/SQLite | yes | yes | yes | reliable, 0.08/0.05ms per 100 | MEMORY, PERFORMANCE | batched flush |
| Intelligent memory | yes | yes | yes | works | MEMORY | classify + 3R + contradictions |
| Sessions SQLite + resume | yes | yes | yes | reliable | USAGE, MEMORY | `--continue`, stale→interrupted recovery |
| Server REST/WS + pages | yes | yes | yes | reliable, open w/o key | USAGE, SECURITY | `run_server.py :8765`; SHSCODE_API_KEY optional |
| Cron scheduler | yes | yes | yes | works (needs croniter) | CRON | `--add/--run/--list/--trigger` |
| Webhooks HMAC-SHA256 | yes | yes | yes | works | WEBHOOKS | SessionDB table; rotate secrets |
| Channels CLI | yes | entry verified | no | UNVERIFIED flags | WEBHOOKS | `shscode-channels --help` for truth |
| SSH gateway | yes | yes | no live handshake | works with config | SSH | needs asyncssh + keys; restricted shell |
| Sandbox backends | yes | yes | no live docker | works with config | SANDBOX | docker/ssh/openshell; disabled default |
| Browser (search/crawl/use) | yes | yes | partial | works with config | BROWSER | needs browser extra + chromium (UNVERIFIED run) |
| Git providers (5) | yes | yes | yes | works with tokens | GIT, GITHUB | github/gitlab/bitbucket/azure/forgejo |
| Verification tiers | yes | yes | yes | reliable | OPTIMIZATIONS | `verify` tool + risk_verify + cont QA |
| Context condenser | yes | yes | yes | reliable | AUTONOMOUS | rolling default, 200 events/80k tokens |
| Providers/models/fallback | yes | yes | partial | works, whole-run fallback only | MODELS, PROVIDERS | per-request failover INCOMPLETE |
| v4 20 opts wiring | yes | yes | yes (31 tests) | reliable | OPTIMIZATIONS, ARCHITECTURE | `app/v4/wiring.py` singletons |
| Termux/Android | no | no | no | unsupported | INSTALLATION | explicitly UNVERIFIED |

## J. Doc improvements made
This repo: 36 files, all commands/paths/keys verified; UNVERIFIED explicitly marked;
weakness register + truth table + validation checklist included.
