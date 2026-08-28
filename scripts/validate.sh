#!/usr/bin/env bash
# One gate for everything: orchestrator and CI both call this and nothing else.
set -uo pipefail
FAIL=0
LOG=/tmp/validate_$$.log
 
echo "== 1/4 import =="
timeout 120 godot --headless --import . > "$LOG" 2>&1
grep -E "SCRIPT ERROR|ERROR:" "$LOG" && FAIL=1
 
echo "== 2/4 parse check =="
while IFS= read -r f; do
  timeout 30 godot --headless --check-only --script "$f" >> "$LOG" 2>&1 || { echo "PARSE FAIL: $f"; FAIL=1; }
done < <(find scenes scripts tests -name '*.gd' 2>/dev/null)
 
echo "== 3/4 smoke =="
timeout 120 godot --headless -s tests/smoke/run_scenes.gd > "$LOG" 2>&1
SMOKE=$?
grep -E "SCRIPT ERROR|ERROR:|LOAD FAIL" "$LOG" && FAIL=1
[ "$SMOKE" -ne 0 ] && FAIL=1
 
echo "== 4/4 unit tests =="
timeout 300 godot --headless -s addons/gdUnit4/bin/GdUnitCmdTool.gd --ignoreHeadlessMode --add res://tests/unit > "$LOG" 2>&1 || FAIL=1
grep -E "FAILED|ERROR" "$LOG" && FAIL=1
 
if [ "$FAIL" -ne 0 ]; then
  echo "==== VALIDATE: FAIL ===="
  tail -40 "$LOG"
  exit 1
fi
echo "==== VALIDATE: PASS ===="
 