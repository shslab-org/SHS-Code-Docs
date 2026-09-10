# SKILLS — SHS-Code v4.0.0 (verified `app/skills/`, 29 built-ins)

## Where skills live
- Built-ins: `app/skills/builtin/*.md` (29 files, verified count).
- User dir (verified `_get_skills_dir`): `SHSCODE_SKILLS_DIR` env, else
  `SHSCODE_HOME`-honouring default (`~/.shscode/skills`); legacy `MANUSCLAW_*` fallback.
- Installed third-party: `<skills_dir>/installed/`. Disabled state: `skills_state.json` sibling.

## Built-in list (verified filenames)
`android-development api-development automation browser-automation c coding cpp csharp
data_analysis database-engineering debugging devops documentation git github java javascript
kotlin linux mlops php python research security-engineering sql testing typescript ui-ux web-development`

## Structure / metadata
Markdown with front-matter (`name`, `description`, `tags`, `version`); engine
`SkillEngine` (`app/skills/skill_engine.py`): create/get/patch/list, enable/disable,
`get_relevant(goal)` ranking, `should_suggest_skill(tool_call_count)`.

## Ranking fix during this audit (commit ee1c397, verified)
Old `get_relevant` counted raw word overlap incl. stopwords (`a/with/write/…`) so every
skill tied at 1 and the right skill was buried (`test_relevant_skill_selected_for_task` failed).
Fix: stopword filter + name/tag-weighted scoring + name tie-break. Full suite now 684 passed.

## Create your first skill (beginner, verified API)
```bash
export SHSCODE_SKILLS_DIR=/tmp/my-skills   # isolate while learning
python3 - <<'PY'
from app.skills.skill_engine import get_skill_engine
e = get_skill_engine()
s = e.create("my_first_skill", "Remind me to run pytest -q", "Always run pytest -q before claiming done.", tags=["testing"])
print(s.name, s.version)
print([x.name for x in e.list_skills()])
print([x.name for x in e.get_relevant("run pytest for my change")])
PY
```
Expected: your skill ranks first for testing queries.

## Install / update / remove / test / troubleshoot
- Install existing: copy its `.md` into `$SHSCODE_SKILLS_DIR/` (or `/installed/`) then `list_skills()`.
- Update: `engine.patch(name, content=…, description=…, version="2.0.0")`.
- Remove: delete file or `engine.disable(name)`; project-local vs global = which dir you put it in.
- Test: `get_relevant("your task words")` should rank it top-3; `should_suggest_skill(n)` gates auto-suggest.
- Troubleshoot: wrong ranking → check tags/description keywords (stopwords ignored); not found → check `SHSCODE_SKILLS_DIR` + `skills_state.json` disabled list.
