#!/bin/bash
cd "$(dirname "$0")"
PORT=8000
open "http://localhost:$PORT" >/dev/null 2>&1 &
python3 -m http.server "$PORT"
