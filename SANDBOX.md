# SANDBOX — SHS-Code v4.0.0 (verified `app/sandbox/`)

Backends (verified files): `docker.py`, `ssh.py`, `openshell.py`, `factory.py`.
```toml
[sandbox]
enabled = false
docker_image = "python:3.11-slim"
memory_limit = "256m"
timeout = 30
```

## Use
Disabled by default. Enable for untrusted code execution; factory picks backend.
Docker needs daemon + image pull (environmental, UNVERIFIED here).

## Limits
Sandbox ≠ security proof — still review diffs; timeouts kill runaways but not data exfil
by a motivated prompt (see SECURITY.md).
