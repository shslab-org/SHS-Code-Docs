# DEVELOPMENT — SHS-Code-Docs repo itself

```bash
git clone <docs-repo-url> SHS-Code-Docs && cd SHS-Code-Docs
# edit markdown, then validate:
grep -rn "TODO\|FIXME\|lorem" . --include="*.md" | head
python3 -c "import pathlib; print(len(list(pathlib.Path('.').rglob('*.md'))), 'markdown files')"
```

## Validation checklist
- [ ] every command re-ran against SHS-Code `ee1c397`
- [ ] every path/config key/env var matches source
- [ ] no invented flags or features
- [ ] UNVERIFIED marks intact where needed
- [ ] PERFORMANCE.md context preserved
- [ ] examples copy-paste tested where practical
