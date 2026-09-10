"""Create first skill (verified SkillEngine API, stopword-fix ee1c397)."""
import os
os.environ.setdefault("SHSCODE_SKILLS_DIR", "/tmp/my-skills")
from app.skills.skill_engine import get_skill_engine
e = get_skill_engine()
s = e.create("my_first_skill", "Run pytest quietly", "Always run pytest -q before claiming done.", tags=["testing"])
print("created:", s.name, s.version)
print("relevant:", [x.name for x in e.get_relevant("run pytest for my change")][:3])
