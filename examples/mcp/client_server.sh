#!/bin/bash
# MCP server + client (verified --help flags)
python run_mcp_server.py --host 127.0.0.1 --port 8000 &
SRV=$!
sleep 2
curl -s localhost:8000/health || true
python run_mcp.py --connection sse --server-url http://127.0.0.1:8000 --prompt "list tools"
kill $SRV
