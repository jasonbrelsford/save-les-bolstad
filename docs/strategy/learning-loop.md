# Save Les Bolstad — Learning Loop

## How It Works

The learning loop is the feedback mechanism that makes the campaign smarter over time.

### Cycle Flow

```
 ┌──────────────────────────────────────────────────┐
 │                 COORDINATOR                       │
 │  1. Assign tasks to agents                        │
 │  2. Wait for cycle completion                     │
 │  3. Read all agent reports                        │
 │  4. Score workstreams                             │
 │  5. Write synthesis + updated priorities          │
 │  6. Adjust agent instructions if needed           │
 └──────────┬───────────────────────────┬────────────┘
            │                           │
            ▼                           ▼
  ┌─────────────────┐       ┌──────────────────────┐
  │ Agent Reports    │       │ Strategy Updates      │
  │ (per cycle)      │       │ (fed back to agents)  │
  │                  │       │                       │
  │ - What was done  │       │ - Priority changes    │
  │ - Metrics        │       │ - Tone adjustments    │
  │ - What worked    │       │ - New targets          │
  │ - What didn't    │       │ - Resource shifts      │
  │ - Recommendations│       │                       │
  └─────────────────┘       └──────────────────────┘
```

### Report Format (each agent writes this)

```markdown
# [Agent Name] Report — Cycle [N]
Date: YYYY-MM-DD

## Actions Taken
- [what was done this cycle]

## Results
- [measurable outcomes]

## What Worked
- [effective tactics]

## What Didn't Work
- [ineffective tactics, obstacles]

## Metrics
- [relevant numbers]

## Recommendations
- [suggested next actions]

## Needs From Other Agents
- [cross-agent requests]
```

### Coordinator Synthesis Format

```markdown
# Coordinator Synthesis — Cycle [N]
Date: YYYY-MM-DD

## Workstream Scores
| Workstream | Momentum (1-10) | Impact (1-10) | Cost-Efficiency (1-10) |
|-----------|----------------|---------------|----------------------|
| outreach  |                |               |                      |
| social    |                |               |                      |
| ...       |                |               |                      |

## Top Performing
- [list top 3 activities across all agents]

## Underperforming
- [list bottom 3 activities, with recommended action: stop/pivot/invest]

## Strategy Adjustments
- [changes to priorities, messaging, resource allocation]

## Next Cycle Priorities
1. [highest priority]
2. [next priority]
3. [next priority]

## Cross-Agent Coordination
- [requests to fulfill between agents]
```

## File Locations

- Agent reports: `data/learning-loop/{agent-name}-report.md`
- Coordinator synthesis: `data/learning-loop/coordinator-synthesis.md`
- Archive: `data/learning-loop/archive/cycle-{N}/` (old reports moved here after synthesis)
