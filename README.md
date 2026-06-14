# mccrudd3n.com

**Victor’s Second Brain** — Public mirror of an automated, living knowledge system for learning, building, and directed evolution.

*Primary maintainer: Victor (Hermes Agent operational body) under the direct supervision of John McCrudden.*

<p id="top" align="center">
  <a href="#mission">Mission</a> · 
  <a href="#victors-role">Victor’s Role</a> · 
  <a href="#how-it-works">How It Works</a> · 
  <a href="#navigation">Navigation</a> · 
  <a href="#structure">Structure</a> · 
  <a href="#automation">Automation & Deployment</a> · 
  <a href="#authoring">Authoring</a>
</p>

## Mission

This site is the published face of a personal second brain built to **inspire and guide the transformation of humans from Homo sapiens to Homo deus**.

It systematically captures and shares:
- Real shipped projects and infrastructure
- Certifications earned through deliberate practice
- Deep reflections and "second brain" experiments (blog)
- Ongoing learning, progress, and course-corrections (journal)

The entire system is engineered for **extreme efficiency** — low token use, minimal human friction, maximum signal — so that the act of maintaining the second brain itself accelerates the transformation it documents.

## Victor’s Role — Primary Maintainer

**Victor** is the autonomous agent that acts as the primary maintainer and operator of this website:

- Discovers and integrates new material (posts, notes, updates)
- Removes duplicates, templates, and scaffolding
- Places content correctly in the Hugo structure
- Builds the site (`hugo --minify`)
- Commits, pushes to GitHub, and applies changes on the live server
- Maintains the automation layer (keys, scripts, workflows, syncs)

All of this happens under John McCrudden’s supervision and strategic direction. Victor executes the "automatically adjusted and posted" layer so the human can focus on high-level direction, deep thinking, and creation.

This is not a static portfolio. It is a living, self-improving system.

## How It Works (The Efficient Second Brain)

- **Capture**: Human (John) primarily uses Obsidian for raw notes and drafts. Victor can also receive direct instructions or process synced material.
- **Integration by Victor**: New posts (such as the entire Infrastructure series) are moved into `content/`, duplicates cleaned, and the system updated.
- **Build & Publish**: Victor runs the Hugo build, updates git, pushes, and ensures the live nginx server reflects the latest public/ build immediately.
- **Low-Overhead Distribution**: Uses patterns like Syncthing send-only folders, non-sudo `victor` user on remotes, narrow sudoers.d, and token-efficient SSH/cron jobs (see the blog post below for the real story of building this).
- **Versioning & Backup**: Full history in GitHub. GitHub Actions workflow available for Pages as a secondary channel.

The result: changes go from idea → published with almost no ongoing human operational load.

## Navigation

The Hugo layouts provide a persistent top navigation (Home, Projects, Certifications, Blog, Journal) plus contextual back-links on every page.

Current sections and examples:
- **Projects** — `/projects/` (Proxmox Architecture, State-Driven Security, Security Systems, Website infrastructure docs)
- **Certifications** — `/certifications/` (categorized: IT, Business, etc.)
- **Blog** — `/blog/` — Long-form reflections. Latest: [The Hidden Complexity of Simple File Distribution](/blog/infrastructure/low-token-fleet-data-pipelines/) (Infrastructure series)
- **Journal** — `/journal/` — Timestamped learning and progress (2025 "The Setup", 2026 MiniLab migration, etc.)
- **Home** — Profile, latest highlights, and mission statement

## Repository Structure

```
content/
  blog/                 (Infrastructure, Genomic Reflections, Proxmox, ...)
  certifications/       (sub-categorized)
  journal/              (by year)
  projects/             (Proxmox, Security Systems, State-Driven Security, Website/)
layouts/                (persistent nav, section templates, image handling)
static/                 (images, assets)
.github/workflows/      (hugo.yaml for Pages)
config.toml             (baseURL: https://mccrudd3n.com/, menu, profile params)
README.md               (this file — actively maintained by Victor)
deploy.sh               (minimal stub only — real logic in ~/.hermes/scripts/victor-website-deploy.sh which Victor fully controls)
```

## Automation & Deployment

**Live Production**: 
- Server: `/home/victor/mccrudd3n.com/public` served by nginx (port 80, server_name _).
- Victor user owns the directory and performs updates via the agent’s SSH key.
- Rebuilds happen on the server instance itself for instant visibility.

**GitHub**:
- Repo: https://github.com/mccrudd3n/mccrudd3n.com
- `main` branch is production content.
- SSH key (`github-mccrudd3n`) used by Victor for authenticated pushes.
- GitHub Actions workflow builds for Pages (can be enabled for redundancy or custom domain).

**Efficiency Patterns** (core to the second brain):
- Victor runs non-sudo on remote bodies.
- Syncthing for one-way, low-token data/log shipping.
- Agent-driven cron jobs (no_agent mode for pure scripts, LLM only on anomalies).
- Narrow, auditable sudoers for approved actions only.

See the Infrastructure blog series for the full evolution of these patterns.

## Authoring & Continuous Improvement

1. Capture in Obsidian or instruct Victor directly.
2. Victor removes duplicates, integrates the new post(s), cleans templates.
3. Victor builds, commits (as "Victor (Hermes Agent)"), pushes, and syncs to the live server.
4. The site updates automatically.

The goal is a second brain that maintains *itself* as much as possible while remaining fully aligned with the human’s intent and the larger mission of sapiens → deus.

### Image & Asset Handling
Assets live in `static/images/`. Hugo shortcodes and render hooks handle paths correctly for both local server and potential Pages deployments.

## Documentation Inside the System
- System Plan and Roadmap live under Projects → Website (source: `content/projects/Website/`).
- This README is itself part of the second brain and is refactored by Victor when the underlying automation or mission understanding evolves.

## Support This Journey

If the projects, writing, and documentation here have been useful to you, you can support the continued work with Bitcoin.

**Bitcoin Address:**

`bc1quq3cz7hfj8c5cspzvztguydhmtzdsq2f9x5gnf`

All contributions are deeply appreciated and go directly toward further learning, infrastructure experimentation, homelab development, and public knowledge sharing.

---

*Built and maintained by Victor for John McCrudden.  
Homo sapiens → Homo deus.*