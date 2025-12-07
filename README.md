# My Website

Obsidian-authored, Hugo-powered portfolio that highlights shipped projects, certifications, learning goals, and a day-to-day journal.

<p id="top" align="center">
  <a href="#overview">Overview</a> ·
  <a href="#site-navigation">Site Navigation</a> ·
  <a href="#repository-structure">Repository Structure</a> ·
  <a href="#deployment-workflow">Deployment Workflow</a> ·
  <a href="#server-deployment-ip-only">Server Deployment (IP-only)</a> ·
  <a href="#authoring-workflow">Authoring Workflow</a>
</p>

## Overview
- Presents core projects, certifications, long-form blog posts, and short journal updates.
- Built with Hugo; layout templates provide persistent navigation back to root sections.
- Obsidian remains the primary writing surface, with content synced directly into `content/`.
- GitHub Pages ready: navigation URLs resolve from the configured `baseURL`.

## Site Navigation
The Hugo layout templates read the `main` menu defined in `hugo.toml`, rendering a persistent navigation bar (Home, Projects, Certifications, Blog, Journal) on every page. Each leaf page also exposes contextual “Back to Home” and “Back to &lt;Section&gt;” links to keep readers oriented.

Assuming GitHub Pages deployment at `https://lostuser.github.io/mywebsite/`, the live paths are:

- Home → `/` &nbsp;(`content/_index.md`)
- Projects → `/projects/` &nbsp;(`content/projects/`)
  - Sample: [Test Links to Project](content/projects/Test%20Links%20to%20Project.md)
- Certifications → `/certifications/` &nbsp;(`content/certifications/`)
  - Organised into sub-folders such as `data-analysis/`, `cloud-computing/`, `ux-design/`, and `python-automation/`.
  - The homepage surfaces each category as a block with the two most recent credentials and a direct "View all" link.
  - Sample: [Google Advanced Data Analytics Capstone](content/certifications/data-analysis/google-advanced-data-analytics.md)
- Blog → `/blog/` &nbsp;(`content/blog/`)
  - Sample: [Test Blog 1](content/blog/Test%20Blog%201.md)
- Journal → `/journal/` &nbsp;(`content/journal/`)
  - Sample: [Test Journal](content/journal/Test%20Journal.md)

Update the `baseURL` in `hugo.toml` if deploying to a different domain; the navigation menu will automatically render correct paths for the chosen host.

## Repository Structure
```
content/                 → Hugo sections (blog, journal, projects, certifications)
layouts/                 → Base template, section lists, and single-page views with navigation
static/                  → Static assets served without processing
assets/                  → Pipeline-managed styles/scripts (optional)
docs/                    → Planning docs (system plan, roadmap)
hugo.toml                → Hugo configuration and menu definitions
```

## Deployment Workflow
1. Configure GitHub Pages (project site): Settings → Pages → GitHub Actions.
2. Add a GitHub Actions workflow (e.g., `.github/workflows/deploy.yml`) that:
   - Checks out the repo
   - Runs `hugo --minify`
   - Deploys the `public/` output to the `gh-pages` branch (or Pages artifact)
3. Ensure `baseURL` points at the Pages URL (`https://lostuser.github.io/mywebsite/` by default).
4. Commit and push; each merge to `main` will rebuild and publish the site with the correct navigation paths.

> Tip: If you serve the site from a custom domain, update `baseURL` and add the domain to `static/CNAME`.

## Server Deployment (IP-only)
Use this when hosting on a server with only an IP address (no domain).

1) Install prerequisites
- `sudo apt update && sudo apt install -y git hugo nginx` (use `hugo-extended` if available).

2) Pull the site
- `sudo git clone https://github.com/<your-org>/<repo>.git /opt/mywebsite`
- `cd /opt/mywebsite`
- In `hugo.toml`, set `baseURL = "http://<SERVER_IP>:80/"` (or `:8080` if you prefer a non-privileged port).

3) Build
- `hugo --minify` (add `-D` to include drafts/future-dated content). Output lands in `public/`.

4) Serve with nginx (recommended)
- Create `/etc/nginx/sites-available/mywebsite`:
  ```
  server {
    listen 80;
    server_name _;
    root /opt/mywebsite/public;
    index index.html;
    location / { try_files $uri $uri/ =404; }
    location ~* \.(css|js|png|jpg|jpeg|gif|svg|ico|webp|woff2?)$ {
      add_header Cache-Control "public, max-age=31536000, immutable";
    }
  }
  ```
- `sudo ln -s /etc/nginx/sites-available/mywebsite /etc/nginx/sites-enabled/mywebsite`
- `sudo nginx -t && sudo systemctl reload nginx`
- Open `http://<SERVER_IP>/` in a browser.

5) Fast ad-hoc check (optional)
- Instead of nginx, temporarily run: `python3 -m http.server 8080 --directory public`
- Visit `http://<SERVER_IP>:8080/` to confirm the build, then Ctrl+C to stop.

6) Pull-and-rebuild helper (optional)
- Create `/usr/local/bin/deploy-mywebsite.sh`:
  ```
  #!/usr/bin/env bash
  set -e
  cd /opt/mywebsite
  git pull
  hugo --minify
  sudo systemctl reload nginx
  ```
- `sudo chmod +x /usr/local/bin/deploy-mywebsite.sh`
- Run `sudo deploy-mywebsite.sh` after each update.

Firewall note: allow inbound HTTP (80) or your chosen port in your VPS firewall/security group.

## Authoring Workflow
1. Draft or update notes in Obsidian using the front-matter templates documented in `docs/system-plan.md`.
2. Run your sync command to copy the vault into Hugo’s `content/` directories.
3. Preview locally with `hugo server` to confirm navigation and linking.
4. Commit and push; GitHub Actions handles the production build and deployment.

### Image Embeds
- Store shared assets under `static/images/` and include them with `{{< staticimg src="images/example.png" alt="Descriptive alt text" >}}`; the shortcode adds the correct `/mywebsite/` prefix for GitHub Pages.
- Alternatively, use page bundles (`content/blog/my-post/index.md` + image files) and reference them with standard Markdown (`![Alt text](cover.jpg)`). The custom image render hook resolves bundle assets automatically.

### Documentation
- [System Plan](docs/system-plan.md) — Obsidian ↔ Hugo automation, layout details, and maintenance cadence.
- [Roadmap](docs/roadmap.md) — Milestones for content, design polish, and automation.
