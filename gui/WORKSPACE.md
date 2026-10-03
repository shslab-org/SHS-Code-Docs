# GUI — Workspace Panel

Browse and read the server's working directory.

- **File tree** (left): expandable directories; hidden dirs, `__pycache__`,
  `node_modules`, `.git`, virtualenvs are skipped.
- **Viewer** (right): click a file to load it (`GET /workspace/file`).
  Size-capped (200 KB default, truncation flagged).

## Safety

All paths are resolved against the server's cwd and **confined** to it —
`../../etc` style escapes are rejected with HTTP 400. This is a viewer,
not an editor: the agent (or the Terminal panel) performs edits.
