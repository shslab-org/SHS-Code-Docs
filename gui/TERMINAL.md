# GUI — Terminal Panel

Run shell commands in the server's working directory — the same location
the agent operates in.

- Input → `POST /terminal/exec {command, timeout}` (max 120 s)
- Output: stdout + stderr + exit code, rendered monospace
- Protected by the server API key when configured

The terminal is user-driven; the agent's own bash commands appear in the
Agent panel's activity feed instead. Both run in the same workspace.
