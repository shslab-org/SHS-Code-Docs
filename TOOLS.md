# TOOLS — SHS-Code v4.0.0 complete reference (verified `app/tool/*.py`)

23 tool classes verified by `name =` scan. Invocation is agent-side (LLM tool-calls),
not shell commands; server exposes `GET /tools`.

| name | class/file | purpose · config · failure |
|---|---|---|
| `bash` | `Bash`/`bash.py` | shell exec, persistent session. Failure: non-zero exit returned as result, risky cmds gated by `[security]` |
| `str_replace_editor` | `StrReplaceEditor` | view/create/str_replace/insert/undo on files. Failure: path errors returned |
| `python_execute` | `PythonExecute` | isolated Python subprocess, full output, optional timeout |
| `node_execute` | `NodeExecute` | isolated Node.js subprocess |
| `code_search` | `CodeSearchTool` | indexed semantic/symbol/regex/import/usages search — prefer over grep |
| `project_intel` | `ProjectIntelTool` | summary/architecture/entry/env/git/refresh |
| `verify` | `VerifyTool` | build/test/lint/typecheck, project-aware; MANDATORY before done-claims |
| `task_dag` | `TaskDagTool` | persisted plan graph (add/start/complete/fail/skip/next) |
| `planning` | `PlanningTool` | plan scaffolding |
| `delegate` | `DelegateTool` | spawn isolated subagent for parallel subtasks |
| `ask_human` | `AskHuman` | ask user (interactive stdin only) |
| `terminate` | `Terminate` | signal completion (only when verified) |
| `memory` | `MemoryTool` | read/write MEMORY.md + USER.md |
| `cross_session_search` | `CrossSessionSearch` | full-text search past sessions |
| `skill_manager` | `SkillManagerTool` | create/patch/delete/list reusable skills |
| `web_search` | `WebSearchTool` | DuckDuckGo→Bing fallback, `[search]` config |
| `crawl` | `Crawl4AITool` | clean text from URL (needs `browser` extra for JS-heavy) |
| `browser_use` | `BrowserUseTool` | Playwright actions; needs playwright + chromium; has `cleanup()` but no guaranteed hook (see WEAKNESSES) |
| `image_generate` | `ImageGenerationTool` | FAL.ai if `FAL_KEY` else mock; saves `workspace/images/` |
| `data_viz` | `DataVisualization` | charts (needs `runflow.enable_data_analysis`) |
| `platform_control` | `PlatformControlTool` | OS-level control (gated) |
| `crawl4ai` | alias of crawl path | see `crawl` |

MCP tools appear dynamically via `MCPProxyTool` (`app/mcp/client.py`).
Parallel dispatch: v4 `app/v4/parallel_tools.py` + `async_dag.py` (DAG-aware, semaphore-limited).
