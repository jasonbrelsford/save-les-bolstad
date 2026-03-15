# Save Les Bolstad Golf Course

**An OpenClaw-powered autonomous campaign to preserve the University of Minnesota's beloved Les Bolstad Golf Course.**

## The Mission

Les Bolstad Golf Course — the University of Minnesota's historic course — was slated to close in November 2025 and is not supposed to reopen. This project uses [OpenClaw](https://openclaw.ai) multi-agent orchestration to run every campaign, research thread, outreach push, and operational plan needed to save it.

## How It Works

A **Coordinator agent** (Claude Opus 4.6) oversees 9 specialist agents, each running on cost-appropriate LLMs. The agents work autonomously on parallel workstreams — outreach, social media, crypto membership tokens, community engagement, course operations planning, legal/policy research, analytics, content creation, and fundraising — with a learning loop that feeds results back to improve strategy.

```
┌─────────────────────────────────────────────────────────┐
│                   COORDINATOR (Opus 4.6)                │
│            Orchestrates all workstreams                  │
│            Runs the learning loop                        │
│            Makes strategic decisions                     │
└──────┬──────┬──────┬──────┬──────┬──────┬──────┬───────┘
       │      │      │      │      │      │      │
  ┌────┴┐ ┌──┴──┐ ┌─┴──┐ ┌┴───┐ ┌┴───┐ ┌┴──┐ ┌┴────┐
  │Out- │ │Soci-│ │Cry-│ │Com-│ │Cour│ │Leg│ │Anal-│
  │reach│ │al   │ │pto │ │mun-│ │se  │ │al/│ │ytics│
  │     │ │Media│ │Memb│ │ity │ │Ops │ │Pol│ │     │
  └─────┘ └─────┘ └────┘ └────┘ └────┘ └───┘ └─────┘
  ┌───────────┐ ┌──────────────┐
  │Content    │ │Fundraising   │
  │Creator    │ │              │
  └───────────┘ └──────────────┘
```

## Agent Roster

| Agent | Model | Purpose |
|-------|-------|---------|
| **coordinator** | Claude Opus 4.6 | Strategic oversight, decision-making, learning loop |
| **outreach** | Gemini 2.5 Flash | University admin, alumni networks, local government |
| **social-media** | DeepSeek V3 | Twitter/X, Reddit, Instagram campaigns |
| **crypto-membership** | Gemini 2.5 Flash | $BOLSTAD token design, membership tiers, public access |
| **community** | DeepSeek V3 | Local engagement, events, petitions, volunteer coordination |
| **course-ops** | Gemini 2.5 Flash | Business plans, tee-time systems, maintenance, staffing |
| **legal-policy** | Gemini 2.5 Flash | University policy, land use, nonprofit structures |
| **analytics** | DeepSeek V3 | Campaign metrics, sentiment tracking, KPI dashboards |
| **content-creator** | DeepSeek V3 | Blog posts, videos scripts, press releases, graphics briefs |
| **fundraising** | Gemini 2.5 Flash | Grant writing, donor outreach, crowdfunding, corporate sponsors |

## The Dual-Use Model: Golf Course + Public Park

A core innovation: Les Bolstad can serve **both golfers AND the public** without conflict.

### How It Works
- **Active golf hours** (dawn–dusk during season): Course operates normally for members and public tee times
- **Off-peak / off-season**: Walking paths, cross-country skiing, community gardens, nature trails open to all
- **Designated public areas**: Perimeter walking loop, practice green, clubhouse café always accessible
- **Parks-style programming**: Yoga on the fairway (early AM before play), stargazing events, education programs

This "hybrid park-course" model has precedent at municipal courses nationwide and dramatically broadens community support.

## $BOLSTAD Membership Token

A crypto token that serves as the membership credential:

- **Annual Membership**: Hold N tokens = season pass with tee-time priority
- **Day Pass**: Micro-purchase of tokens for single-round access
- **Public Access Tier**: Free/low-cost token for park-only amenities
- **Governance**: Token holders vote on course improvements, events, pricing
- **Revenue**: Token sales fund operations; appreciation rewards early supporters
- **Transparency**: All financials on-chain, visible to community

## Resort/Spa Potential

The coordinator agent evaluates whether a boutique resort/spa component makes sense:
- Clubhouse renovation into a wellness destination
- Partnership with U of M hospitality/kinesiology programs
- Revenue diversification beyond greens fees
- Feasibility analysis via the course-ops and analytics agents

## Running With OpenClaw

### Container Deployment (Recommended)

```bash
cd save-les-bolstad
docker compose up -d
```

### Environment Variables

Copy `.env.example` to `.env` and fill in:
- `ANTHROPIC_API_KEY` — for Coordinator (Opus 4.6)
- `GOOGLE_AI_API_KEY` — for Gemini Flash agents
- `DEEPSEEK_API_KEY` — for DeepSeek V3 agents

### Dashboard

Once running, open `http://127.0.0.1:18789/` to monitor all agent activity.

## Learning Loop

Every cycle:
1. Each agent reports results + metrics to `data/learning-loop/`
2. Coordinator reads all reports, identifies what's working
3. Strategy adjustments are written back to agent instructions
4. Analytics agent tracks before/after performance
5. Repeat

## Project Structure

```
save-les-bolstad/
├── agents/           # Per-agent workspace + instructions
├── config/           # OpenClaw configuration
├── data/             # Campaign data, member records, analytics
├── docker/           # Container deployment files
├── docs/             # Strategy documents, research, course info
├── scripts/          # Automation scripts
└── skills/           # Custom OpenClaw skills
```

## Contributing

This is a community effort. If you love Les Bolstad, open an issue or PR. The agents welcome human collaborators.

## License

MIT
