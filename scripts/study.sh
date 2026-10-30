#!/usr/bin/env bash
# Study session tracker: logs time, journals, ticks the plan, commits and pushes.
#   ./scripts/study.sh start <day>   start a session for plan day N
#   ./scripts/study.sh stop          end it, write journal, commit + push
#   ./scripts/study.sh status        show the running session, if any
#   ./scripts/study.sh stats         total time, sessions, streak, days done
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
STATE=".study-session"          # git-ignored, holds the running session
LOG="time-log.csv"
JOURNAL="devops-journal.md"
PLAN="LEARNING-PLAN.md"

now_epoch() { date +%s; }
now_hm()    { date +%H:%M; }
today()     { date +%Y-%m-%d; }

cmd_start() {
  local day="${1:-}"
  [[ "$day" =~ ^[0-9]+$ ]] || { echo "usage: study.sh start <day-number>"; exit 1; }
  if [[ -f "$STATE" ]]; then
    echo "A session is already running:"; cat "$STATE"; exit 1
  fi
  printf 'day=%s\nstart_epoch=%s\nstart_hm=%s\ndate=%s\n' "$day" "$(now_epoch)" "$(now_hm)" "$(today)" > "$STATE"
  echo "▶ Day $day started at $(now_hm). Today's task:"
  grep -E "^- \[[ x]\] Day $day —" "$PLAN" || echo "  (day $day not found in plan)"
  git pull --rebase --quiet 2>/dev/null || true
}

cmd_stop() {
  [[ -f "$STATE" ]] || { echo "No session running. Use: study.sh start <day>"; exit 1; }
  # shellcheck disable=SC1090
  source "$STATE"
  local end_epoch end_hm minutes
  end_epoch="$(now_epoch)"; end_hm="$(now_hm)"
  minutes=$(( (end_epoch - start_epoch + 59) / 60 ))

  echo "■ Day $day: $minutes min ($start_hm → $end_hm)"
  read -r -p "Built:    " built
  read -r -p "Broke:    " broke
  read -r -p "Question: " question
  read -r -p "Day finished? Tick it in the plan [Y/n]: " done_ans

  echo "$date,$day,$start_hm,$end_hm,$minutes" >> "$LOG"
  {
    echo
    echo "## $date — Day $day ($minutes min)"
    echo "- **Built:** $built"
    echo "- **Broke:** $broke"
    echo "- **Question:** $question"
  } >> "$JOURNAL"

  if [[ ! "$done_ans" =~ ^[Nn] ]]; then
    # Tick "- [ ] Day N —" (portable sed for macOS + Linux)
    sed -i.bak -E "s/^- \[ \] (Day $day —)/- [x] \1/" "$PLAN" && rm -f "$PLAN.bak"
  fi

  rm -f "$STATE"
  git add "$LOG" "$JOURNAL" "$PLAN"
  git commit --quiet -m "Day $day: $minutes min — $built"
  if git remote get-url origin >/dev/null 2>&1; then
    git pull --rebase --quiet && git push --quiet && echo "✔ Pushed to $(git remote get-url origin)"
  else
    echo "✔ Committed (no remote configured yet)"
  fi
}

cmd_status() {
  if [[ -f "$STATE" ]]; then
    # shellcheck disable=SC1090
    source "$STATE"
    echo "Running: Day $day since $start_hm ($(( ($(now_epoch) - start_epoch) / 60 )) min)"
  else
    echo "No session running."
  fi
}

cmd_stats() {
  awk -F, 'NR>1 { m+=$5; n++; d[$1]=1 }
    END { printf "Sessions: %d   Total: %dh %02dm   Study days: %d\n", n, m/60, m%60, length(d) }' "$LOG"
  local done total
  done=$(grep -cE '^- \[x\] Day [0-9]+' "$PLAN" || true)
  total=$(grep -cE '^- \[[ x]\] Day [0-9]+' "$PLAN" || true)
  echo "Plan: $done / $total days done"
  # Current streak of consecutive calendar days with a session
  local streak=0 d
  d="$(today)"
  while grep -q "^$d," "$LOG"; do
    streak=$((streak+1))
    d="$(date -j -v-1d -f %Y-%m-%d "$d" +%Y-%m-%d 2>/dev/null || date -d "$d -1 day" +%Y-%m-%d)"
  done
  echo "Current streak: $streak day(s)"
}

case "${1:-}" in
  start)  shift; cmd_start "$@" ;;
  stop)   cmd_stop ;;
  status) cmd_status ;;
  stats)  cmd_stats ;;
  *) sed -n '2,7p' "$0" | sed 's/^# \{0,1\}//'; exit 1 ;;
esac
