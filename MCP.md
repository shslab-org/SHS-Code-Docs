# MCP — SHS-Code v4.0.0 client + server (verified)

## What MCP is
Model Context Protocol: standard JSON-RPC over stdio/SSE to expose tools from external servers.
SHS-Code implements BOTH sides: `app/mcp/client.py` (`MCPClient`, `MCPProxyTool`) and
`app/mcp/server.py` (`build_mcp_server()` FastAPI: `list_tools`, `call_tool`, `health`).

## Client usage (verified `--help`)
```bash
python run_mcp.py --connection stdio --interactive
python run_mcp.py --connection sse --server-url http://localhost:8000 --prompt "list files"
```
In-shell: `/mcp` (list/manage), `/tools` (includes proxied `MCPProxyTool`s).
Config: server command/URL via CLI flags or `/mcp add` (persisted to config path).

## Server usage (verified `--help`)
```bash
python run_mcp_server.py --host 0.0.0.0 --port 8000
curl localhost:8000/health
```
Exposes agent tools as MCP tools; auth model follows server (`SHSCODE_API_KEY` pattern).

## Example workflow
1. Start server: `python run_mcp_server.py --port 8000`
2. Connect client: `python run_mcp.py --connection sse --server-url http://localhost:8000 --interactive`
3. Prompt: `list the available tools and call one`
4. Troubleshoot: connection refused → check host/port; `stdio` hangs → verify server command; missing tools → check server logs + `/tools`.

## Limits (honest)
Transport is stdio/SSE only (verified choices); auth on MCP server surface is minimal —
front with API key / localhost binding in production (see SECURITY.md).
