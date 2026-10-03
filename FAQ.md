# FAQ — SHS-Code v4.0.0

**Q: What Python?** A: ≥3.11 (verified).
**Q: Do I need an API key?** A: Only for real models; `provider="mock"` works offline.
**Q: Which command first?** A: `python main.py "say OK"`, then a small coding task.
**Q: Single vs multi vs Team103?** A: Single = daily; multi = decomposable projects
(PM→Arch→Eng→QA serial); Team103 = bounded ≤100-coroutine pool via `run_team103` API.
**Q: Are there really 103 LLM agents?** A: No — 1 PM + 1 Architect + ≤100 coroutines + 1 QA (verified).
**Q: Is it 10x faster?** A: No — 10x was 10 parallel 10 ms sleeps (micro-benchmark). See PERFORMANCE.md.
**Q: Where is memory?** A: `~/.shscode/` + workspace SQLite + `MEMORY.md`; `/remember /memory /forget`.
**Q: How do I add a skill?** A: Drop `.md` in `$SHSCODE_SKILLS_DIR`, check `/skills`. See SKILLS.md.
**Q: MCP?** A: `run_mcp.py` client + `run_mcp_server.py` server, stdio/SSE. See MCP.md.
**Q: Termux?** A: Not officially supported (UNVERIFIED).
