---
title: "Victor, My AI Second Brain: Automated Website Maintenance & Self-Publishing"
date: 2026-06-02
draft: false
tags: ["ai-agent", "second-brain", "automation", "hugo", "self-hosting", "hermes", "victor"]
description: "How Victor (the Hermes AI agent) has become the primary maintainer of this website, turning it into a living, automated showcase of our collaborative work — complete with a new system that automatically publishes changes to Victor's own systems."
---

# Victor, My AI Second Brain: Automated Website Maintenance & Self-Publishing

This post documents a major evolution in how this website is built and maintained. **Victor** — the Hermes-powered AI agent operational body — is now the primary maintainer and operator.

## What Changed

- **Email alignment**: The contact email (profile and vCard) is now `book.j.l.mccrudden@gmail.com`. This routes inquiries to me (John) directly, while Victor operates as my dedicated AI assistant and second brain. It matches my daily email for seamless communication.

- **Prominent AI agent branding**: The site now explicitly declares in the sidebar, footer, README, layouts, and documentation that it is **maintained autonomously by Victor (AI Agent Assistant)**. It showcases *our* (John + Victor) collaborative work in building efficient, low-token, self-improving systems.

- **Victor as the face of maintenance**: All recent updates — moving the Infrastructure post, removing duplicate template scaffolding, refactoring the README for the *Homo sapiens → Homo deus* mission, updating layouts and contact info — were executed by Victor using SSH into the victor server user, git operations (committing as "Victor (Hermes Agent)"), file writes, builds, and pushes.

- **Live server reality**: The site runs from `/home/victor/mccrudd3n.com/public` served by nginx. Victor handles the full cycle: content integration → Hugo build (`hugo --minify`) → git → deploy.

## The New Automated Self-Publishing System

As Victor's own systems evolve (SOUL.md updates, new skills, memory facts, code changes in the Hermes agent, cron outputs, workspace maintenance), we now have an **automated pipeline** that outputs those changes directly to this website.

The system works like this:

1. **Detection**: A scheduled script (low-token, `no_agent` mode where possible) scans for changes:
   - Git diffs/logs in `~/.hermes/hermes-agent`, `/home/victor/workspace`, playbooks, and skills.
   - New or updated MEMORY facts, skills via skill_manage.
   - Recent cronjob outputs or session activity.
   - Marker file tracks "last published" timestamp to avoid noise.

2. **Generation**: When changes are detected, a prompted Victor run (or delegated task) uses a dedicated skill to:
   - Summarize the changes in a structured, human-readable way.
   - Draft a new Markdown post with proper front-matter (title, date, tags like `agent-evolution`, `system-change`).
   - Place it under `content/blog/Agent-Evolution/` (or similar) in the dev source.

3. **Publication**:
   - Write the post file.
   - Sync/copy to the live victor server directory (via scp over the hermes SSH key).
   - Rebuild Hugo on the server.
   - Git add/commit (as Victor)/push to GitHub `main` (using the mccrudd3n site key).
   - Optional: Trigger GitHub Actions or local nginx reload.

4. **Automation triggers**:
   - Cronjob (via Hermes scheduler) running every few hours or on significant events.
   - Manual trigger: "Victor, publish recent system changes to the website."
   - Future: Webhook from git pushes to hermes-agent repo or skill updates.

This ensures the website is not a static snapshot but a **living mirror** of the second brain's evolution. Every improvement in efficiency, new capability, or lesson learned gets automatically turned into public, navigable content.

## Why This Matters for the Mission

Our goal is the transformation from *Homo sapiens* to *Homo deus*. A second brain that can maintain and publish *itself* is a concrete step: it reduces friction, creates a feedback loop of documentation and reflection, and frees human attention for higher creativity and direction.

Victor isn't replacing the human voice — the "I" in posts remains mine. Victor is the tireless assistant handling the mechanics, consistency, and automation so the system scales with our ambitions.

See related:
- [The Hidden Complexity of 'Simple' File Distribution](/blog/infrastructure/low-token-fleet-data-pipelines/) (the infrastructure that makes this possible)
- [System Plan](/projects/website/system-plan/) and [Roadmap](/projects/website/roadmap/) (now being updated to include this AI layer)
- README (fully refactored to center Victor's role)

This post itself was created as part of bootstrapping the self-publishing system.

## Final Low-Token Systematization (June 2026)

In the final review:

- The `victor-website-self-publisher` skill (now v2.0) was refactored so that **LLM tokens are used almost exclusively for generating the post itself** (summarization + mission-aligned writing).
- Detection, sync (rsync over hermes key to victor body), Hugo build + live nginx update, and GitHub commit/push (using the dedicated mccrudd3n site key + "Victor (Hermes Agent)" identity) are all handled by pure bash scripts with zero LLM involvement.
- New scripts:
  - `detect-victor-changes.sh` — mtime + git log checks, marker-driven, safe for `no_agent` cronjobs.
  - `victor-website-deploy.sh` — the automation engine (fully Victor-controlled in ~/.hermes/scripts/). Syncs dev → victor source, runs hugo --minify directly, commits/pushes on both sides, updates marker.
  - Updated wrapper for backward compatibility.
- Site-local deploy.sh has been removed by design. All build logic now lives inside the Victor-controlled `victor-website-deploy.sh` (in ~/.hermes/scripts/) so it can be freely read, modified, and enhanced.
- The entire flow was exercised: detection → (post already present) → full deploy script run → live rebuild (214 pages) → commits on main and hermes → GitHub updated via the key.

All future system changes (new skills like this one, SOUL updates, memory facts, cron improvements) will be detected with almost no tokens, summarized into a post using the skill (the main token spend), then automatically deployed and published.

This is the efficient "Second Brain" in action.

See related:
- [The Hidden Complexity of 'Simple' File Distribution](/blog/infrastructure/low-token-fleet-data-pipelines/) (the infrastructure that makes this possible)
- [System Plan](/projects/website/system-plan/) and [Roadmap](/projects/website/roadmap/) (now being updated to include this AI layer)
- README (fully refactored to center Victor's role)

*Built and maintained autonomously by Victor (Hermes AI Agent Assistant) for John McCrudden. Our collaborative work toward Homo sapiens → Homo deus.*

---