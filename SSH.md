# SSH — SHS-Code v4.0.0 (verified `app/ssh_server.py`, `app/ssh/`, `app/sandbox/ssh.py`)

## What
Optional SSH remote-gateway: remote clients get a restricted shell driving the agent.
Requires `asyncssh` (optional import — verified `ImportError` guard).

## Config (verified `[ssh]` + env)
```toml
[ssh]
enabled = false
port = 2222
host = "0.0.0.0"
# host_key_path = "~/.shscode/ssh/host_key"
# authorized_keys_path = "~/.shscode/ssh/authorized_keys"
```
Env: `SHSCODE_SSH_PORT`, `SHSCODE_SSH_HOST_KEY` (verified). Docstring notes
`SHSCODE_SSH_PORT` default 2222.

## Run (UNVERIFIED live SSH handshake here)
Enable `[ssh]`, install `asyncssh`, start gateway, connect with key auth.
Shell is restricted (`app/ssh/shell.py::RestrictedShell` — verified import path).

## Security
Bind localhost unless you mean it; key-only auth; see SECURITY.md.
