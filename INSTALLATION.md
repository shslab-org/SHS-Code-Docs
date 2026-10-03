# INSTALLATION — SHS-Code v4.0.0 A–Z

Verified: `pyproject.toml` (`requires-python >= 3.11`, extras), `config.toml`,
`python main.py --version` → `SHS Code v4.0.0`, `install.sh`, `setup-termux.sh`.

## What SHS-Code is / requirements

- Persistent autonomous coding agent (CLI + server + multi-agent + Team103).
- Needs: Python ≥ 3.11, Git, pip/venv. Optional per feature (verified extras):
  `browser` (playwright, crawl4ai), `search` (duckduckgo-search), `server`
  (fastapi, uvicorn), `cron` (croniter), `ollama`, `mistral/bedrock/google/litellm`.

## Linux (verified path)

```bash
git clone <repo-url> shs-code-live && cd shs-code-live
python3 -m venv .venv && source .venv/bin/activate
pip install -e ".[cli,server,search]"
python main.py --version
```

## macOS

Same as Linux (Homebrew Python 3.11+). Browser extra needs
`playwright install chromium` (playwright docs, not verified here — marked UNVERIFIED).

## Windows

```powershell
git clone <repo-url> shs-code-live; cd shs-code-live
py -3.11 -m venv .venv; .\.venv\Scripts\Activate.ps1
pip install -e ".[cli,server,search]"
python main.py --version
```
PowerShell execution policy issues are environmental, not app bugs.

## Android/Termux — NOT officially supported

`setup-termux.sh` exists in repo but Termux support is **UNVERIFIED** in v4.0.0.
Do not document as supported. Advanced users may try `bash setup-termux.sh` at own risk.

## Configuration

```bash
cp config.toml ~/.shscode/config.toml   # user profile copy (dir auto-created on first run)
export LLM_API_KEY="..."                # preferred; or OPENAI_API_KEY / ANTHROPIC_API_KEY
export LLM_BASE_URL="https://integrate.api.nvidia.com/v1"  # universal endpoints
export LLM_MODEL="openai/gpt-oss-20b"
```

Env prefix rule (verified `app/env.py`): canonical `SHSCODE_<NAME>`, legacy
`MANUSCLAW_<NAME>` fallback. Key vars: `SHSCODE_HOME`, `SHSCODE_WORKSPACE`,
`SHSCODE_API_KEY`, `SHSCODE_ALLOWED_ORIGINS`, `SHSCODE_SKILLS_DIR`,
`SHSCODE_SSH_PORT`, `SHSCODE_SSH_HOST_KEY`, `LLM_API_KEY`, `LLM_BASE_URL`, `LLM_MODEL`.

## First launch / verify install

```bash
python main.py --help
python main.py "say OK"
python run_server.py --help
python run_multi_agent.py --help
python run_mcp.py --help
```

## Updating / reinstall / uninstall

```bash
git pull && pip install -e ".[cli,server,search]"   # update
rm -rf .venv && python3 -m venv .venv && pip install -e ".[cli,server,search]"  # clean reinstall
rm -rf ~/.shscode workspace/*.db  # reset state (deletes sessions/memory — careful)
```

## Troubleshooting install

- `No module named shscode`: use `python main.py`, not `python -m shscode` (verified).
- `app.server is a package`: use `python run_server.py` or `uvicorn app.server.main:app`.
- See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) and in-app `/doctor`.
