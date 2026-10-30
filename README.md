# DevOps University — AWS DevOps, 0 to hero

My personal learning repo. I'm a software developer building DevOps expertise on AWS at 45 minutes a day, so I can manage complex deployments and choose AWS services with reason.

| File | Purpose |
|---|---|
| [`LEARNING-PLAN.md`](LEARNING-PLAN.md) | The 24-week, 120-day plan. Tick `[x]` as days are done. |
| [`devops-journal.md`](devops-journal.md) | 3 lines a day: what I built, what broke, one question. |
| [`time-log.csv`](time-log.csv) | Every study session: date, day #, start, end, minutes. |
| `scripts/study.sh` | Starts/stops a session, logs the time, commits and pushes. |

## Daily routine

```bash
./scripts/study.sh start 1      # begin Day 1 (records start time)
# ... 45 minutes of work ...
./scripts/study.sh stop         # asks for journal lines, logs minutes, ticks the day, commits + pushes
./scripts/study.sh stats        # total hours, sessions, current streak
```

`stop` marks the day as done in `LEARNING-PLAN.md`, appends the journal entry, and pushes to GitHub, so the commit graph is the consistency tracker.

## Progress

Run `./scripts/study.sh stats` for live numbers.
