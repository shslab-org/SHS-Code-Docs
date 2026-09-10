#!/bin/bash
# Autonomous bounded loop (max_steps=30, stuck_threshold=3 verified in config.toml)
python main.py "migrate all print() to logger in app/util/ and run tests"
# controls inside shell: /pause /stop /continue /retry /checkpoint
