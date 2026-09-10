#!/bin/bash
# Multi-agent pipeline PM->Arch->Eng->QA (verified run_multi_agent.py --help)
python run_multi_agent.py "add pagination to GET /sessions" --mode build
python run_multi_agent.py "plan the JWT migration" --mode plan
