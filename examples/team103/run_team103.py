"""Team103 bounded pool via verified API (app/v4/wiring.py::run_team103)."""
import asyncio
from app.v4.merger import WorkerResult
from app.v4.roles import TaskSpec
from app.v4.wiring import run_team103

async def demo_engine(spec: TaskSpec, goal: str) -> WorkerResult:
    # Replace with real LLM-backed engine_fn in production.
    return WorkerResult(task=spec.title, ok=True, output=f"done: {spec.title}", files_touched=list(spec.files))

async def main():
    res = await run_team103("migrate logging to async", engine_fn=demo_engine)
    print(res)

if __name__ == "__main__":
    asyncio.run(main())
