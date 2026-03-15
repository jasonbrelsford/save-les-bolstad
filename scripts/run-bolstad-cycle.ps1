<#
.SYNOPSIS
  Run a Bolstad campaign coordinator cycle via OpenClaw.

.DESCRIPTION
  Sends a campaign-cycle prompt to bolstad-coordinator, which gathers
  reports from specialist agents, synthesizes status, and updates
  state files. Can run on-demand or be scheduled via cron/Task Scheduler.

.PARAMETER Phase
  Campaign phase (1-4). Defaults to reading from data/campaigns/status.json.

.PARAMETER DryRun
  Preview the prompt without sending to the agent.

.PARAMETER Timeout
  Agent timeout in seconds (default: 300).

.EXAMPLE
  .\run-bolstad-cycle.ps1
  .\run-bolstad-cycle.ps1 -DryRun
  .\run-bolstad-cycle.ps1 -Phase 2 -Timeout 600
#>

param(
    [int]$Phase = 0,
    [switch]$DryRun,
    [int]$Timeout = 300
)

$ErrorActionPreference = "Stop"
$repoDir = Split-Path $PSScriptRoot -Parent
$statusFile = Join-Path $repoDir "data\campaigns\status.json"

# Read current phase from status file if not specified
if ($Phase -eq 0) {
    if (Test-Path $statusFile) {
        $status = Get-Content $statusFile -Raw | ConvertFrom-Json
        $Phase = $status.phase
    } else {
        $Phase = 1
    }
}

$phaseNames = @{
    1 = "Research & Intelligence Gathering"
    2 = "Coalition Building & Mobilization"
    3 = "Demonstrate Viability"
    4 = "Negotiation & Resolution"
}

$phaseName = $phaseNames[$Phase]
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
$sessionId = "bolstad-cycle-" + (Get-Date -Format "yyyyMMdd-HHmm")

# Read agent state files to build context
$agentStates = @()
$agentFiles = Get-ChildItem (Join-Path $repoDir "data\agents") -Filter "bolstad-*.json" -ErrorAction SilentlyContinue
foreach ($f in $agentFiles) {
    $state = Get-Content $f.FullName -Raw | ConvertFrom-Json
    $todoCount = ($state.tasks.todo | Measure-Object).Count
    $ipCount   = ($state.tasks.inProgress | Measure-Object).Count
    $doneCount = ($state.tasks.done | Measure-Object).Count
    $agentStates += "- **$($state.agent)** ($($state.role)): $todoCount todo, $ipCount in-progress, $doneCount done"
}

$prompt = @"
## Campaign Cycle — $timestamp
**Phase $Phase**: $phaseName

### Current Agent Task Status
$($agentStates -join "`n")

### Instructions
1. Review each agent's task state above
2. For agents with no work done yet, pick their highest-priority task and delegate it
3. For agents with in-progress work, check whether it can be completed or needs input
4. Synthesize overall campaign status
5. Identify the top 3 priorities for this cycle
6. Flag any blockers or items needing human approval
7. Update your coordinator state with observations

Keep your response structured with clear sections per agent. End with an ESCALATIONS section for anything requiring human attention.

### Data Locations
- Agent states: save-les-bolstad/data/agents/
- Campaign status: save-les-bolstad/data/campaigns/status.json
- Learning loop: save-les-bolstad/data/learning-loop/state.json
- Analytics: save-les-bolstad/data/analytics/metrics.json
- Contacts: save-les-bolstad/data/outreach/contacts.json
"@

if ($DryRun) {
    Write-Host "=== DRY RUN — Prompt Preview ===" -ForegroundColor Yellow
    Write-Host ""
    Write-Host $prompt
    Write-Host ""
    Write-Host "Session: $sessionId" -ForegroundColor Cyan
    Write-Host "Timeout: ${Timeout}s" -ForegroundColor Cyan
    exit 0
}

Write-Host "Starting Bolstad Campaign Cycle" -ForegroundColor Cyan
Write-Host "  Phase:   $Phase — $phaseName" 
Write-Host "  Session: $sessionId"
Write-Host "  Timeout: ${Timeout}s"
Write-Host ""

$result = openclaw agent --agent bolstad-coordinator --session-id $sessionId --message $prompt --timeout $Timeout --json 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "Cycle failed (exit code $LASTEXITCODE)" -ForegroundColor Red
    Write-Host $result
    exit 1
}

# Display result
$parsed = $result | ConvertFrom-Json -ErrorAction SilentlyContinue
if ($parsed -and $parsed.response) {
    Write-Host "=== Coordinator Response ===" -ForegroundColor Green
    Write-Host ""
    Write-Host $parsed.response
} else {
    Write-Host $result
}

# Update campaign status timestamp
if (Test-Path $statusFile) {
    $status = Get-Content $statusFile -Raw | ConvertFrom-Json
    $status.lastUpdated = $timestamp
    $status | ConvertTo-Json -Depth 10 | Set-Content $statusFile -Encoding UTF8
}

Write-Host ""
Write-Host "Cycle complete. Session: $sessionId" -ForegroundColor Cyan
