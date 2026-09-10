# QUICKSTART — SHS-Code v4.0.0 in 5 minutes

Verified against `python main.py --help` and `config.toml` at `ee1c397`.

## 1. Requirements

- Python **>= 3.11** (`pyproject.toml requires-python`, verified).
- Git. `pip` / `venv`. No LLM key needed for smoke test (`mock` provider).

## 2. Install

```bash
git clone <repo-url> shs-code-live && cd shs-code-live
python3 -m venv .venv && source .venv/bin/activate
pip install -e ".[cli,server,search]"
python main.py --version   # expect: SHS Code v4.0.0
```

## 3. Configure (pick one)

```bash
# Option A — offline smoke test, no key:
# config.toml [llm] provider = "mock"

# Option B — real provider:
export LLM_API_KEY="sk-..."          # preferred generic var
# or provider-specific: OPENAI_API_KEY / ANTHROPIC_API_KEY
# or endpoint style:
export LLM_BASE_URL="https://integrate.api.nvidia.com/v1"
export LLM_MODEL="openai/gpt-oss-20b"
```

Config file resolution: `./config.toml` (repo default) → user profiles.
Top-level keys verified in `config.toml`: `workspace_dir = "workspace"`, `max_steps = 30`.

## 4. First runs

```bash
python main.py --help
python main.py "what is 2+2? answer briefly"
python main.py "list the files in app/v4/ and describe each in one line"
```

Interactive shell: `python main.py` (no prompt arg) → slash commands
(`/help /status /model /skills /tools /mcp /doctor /exit`, full list in CLI_REFERENCE.md).

## 5. First coding task

```bash
python main.py "add a function is_even(n) in workspace/demo.py with a test, then run the test"
```

Expected: agent creates/edits files via `str_replace_editor`, runs `bash`/`verify`,
reports test result. If it stalls: `/status`, `/retry`, or restart with `--continue`.

## 6. Next

- [BEGINNER_GUIDE.md](BEGINNER_GUIDE.md) Levels 1–10 · [USAGE.md](USAGE.md) ·
  [TROUBLESHOOTING.md](TROUBLESHOOTING.md) · `/doctor` in-app diagnostics.
