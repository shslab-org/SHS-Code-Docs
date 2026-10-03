# DEVELOPMENT — SHS-Code-Docs repo itself

```bash
git clone <docs-repo-url> SHS-Code-Docs && cd SHS-Code-Docs
# edit markdown, then validate:
grep -rn "TODO\|FIXME\|lorem" . --include="*.md" | head
python3 -c "import pathlib; print(len(list(pathlib.Path('.').rglob('*.md'))), 'markdown files')"
```

## CI on the main repo (v4.2.0)

`shs-code` runs two GitHub-Actions workflows on every push / PR to `main`:

- **Tests** (`.github/workflows/tests.yml`) — the full pytest suite on
  Python 3.11 + 3.12 (`pip install -e .` + pytest/pytest-asyncio/
  pytest-xdist/httpx). Green as of `99be8a4`.
- **Pylint** (`.github/workflows/pylint.yml`) — syntax/undefined-name
  class checks (`--enable=E,F`) on 3.11 + 3.12. The old 3.8–3.10
  matrix could never install the ≥3.11 package; fixed in v4.2.0.

CI findings that were fixed on first run: the OpenShell sandbox test
  now skips cleanly where the runner forbids unprivileged user
  namespaces, and the multi-file edit→rerun test pins honest behavior
  with `PYTHONDONTWRITEBYTECODE=1` (stale-`__pycache__` sharp edge).

## Validation checklist
- [ ] every command re-ran against SHS-Code `99be8a4`
- [ ] every path/config key/env var matches source
- [ ] no invented flags or features
- [ ] UNVERIFIED marks intact where needed
- [ ] PERFORMANCE.md context preserved
- [ ] examples copy-paste tested where practical
