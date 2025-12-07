# Automation & Layout Plan

This document outlines how to automate content publishing with Obsidian and Hugo, and how to structure the website so visitors can quickly understand your work, certifications, learning journey, and day-to-day reflections.

## 1. Publishing Workflow (Obsidian → Hugo → GitHub)

### 1.1 Authoring in Obsidian
- Maintain a dedicated Obsidian vault for website content.
- Use an `obsidian` folder structure that mirrors Hugo content sections:
  - `obsidian/blog/` for longer posts.
  - `obsidian/journal/` for short daily entries.
  - `obsidian/certifications/` for credential notes and metadata.
  - `obsidian/projects/` for work highlights and case studies.
- Configure Obsidian to use YAML front matter templates (via Templater or core Templates plugin) that include:
  ```yaml
  ---
  title: ""
  description: ""
  date: 2024-01-01
  tags: []
  layout: post
  draft: false
  summary: ""
  external_links:
    - label: ""
      url: ""
  ---
  ```
- Optional: install **Obsidian Git** to auto-commit note changes, and **Obsidian Hugo** or a custom snippet to ensure Hugo-compatible formatting (wikilinks → standard Markdown).
- Media handling:
  - Store shared assets in `static/images/` and embed them with the `staticimg` shortcode (`{{< staticimg src="images/example.png" alt="Describe the image" >}}`) so GitHub Pages adds the site subpath automatically.
  - When a post needs local assets, convert it to a page bundle (`content/blog/post-name/index.md`) and reference files via standard Markdown (`![Alt text](cover.jpg)`); the custom render hook rewrites those URLs for you.

### 1.2 Syncing to the Repo
- Use a one-way sync script or symbolic link:
  - Map `obsidian/blog/` → `content/blog/`.
  - Map `obsidian/journal/` → `content/journal/`.
  - Map `obsidian/certifications/` → `content/certifications/`.
  - Map `obsidian/projects/` → `content/projects/`.
- Recommended approach:
  1. Keep the Obsidian vault inside the repository (`/content-source`).
  2. Add a Node/Go script (or simple shell script) to copy/sync Markdown files into Hugo’s `content/` folders, running `hugo mod clean`/`hugo mod get` if using modules.
  3. Provide a `make sync-content` or `npm run sync-content` command for easy execution before committing.

### 1.3 Automated Deployment
- Configure GitHub Actions pipeline:
  1. Trigger on `push` to `main` and on pull requests.
  2. Job steps: checkout repo → run content sync script (if needed) → install Hugo (extended) → run `hugo` → deploy to hosting provider.
  3. Hosting options:
     - **GitHub Pages** via `peaceiris/actions-hugo`.
     - **Netlify** or **Vercel** for preview URLs on PRs.
- Include automated checks:
  - Lint Markdown (e.g., `markdownlint`).
  - Validate front matter schema (using a custom script or `jsonschema` + front matter parser).
  - Run link checker (e.g., `lychee`) to catch dead links.

### 1.4 Daily Workflow Summary
1. Draft/update content inside Obsidian.
2. Run local sync command to update Hugo `content/`.
3. Preview locally with `hugo server`.
4. Commit and push; CI builds and deploys automatically.

## 2. Information Architecture

### 2.1 Top-Level Navigation
- **Home** – Overview of who you are, featured projects, latest journal entry, and call-to-action.
- **Projects** – Deep dives into current and past work, with filtering (e.g., by skill, industry, year).
- **Certifications** – Credential timeline with issuer, verification links, and badges.
- **Blog** – Longer articles on topics of expertise or learning.
- **Journal** – Daily/weekly bite-sized entries tracking progress and reflections.
- **Learning Log** – What you are currently studying, resources, upcoming goals.
- **About / Contact** – Detailed bio, resume link, social profiles, and contact mechanism (email or form).

### 2.2 Content Structure
- **Projects**
  - Front matter: `title`, `subtitle`, `date`, `tech_stack`, `role`, `outcome`, `links`.
  - Layout: hero image, summary, problem/solution sections, metrics, call-to-action.
- **Certifications**
  - Organise into sub-folders (e.g., `data-analysis/`, `cloud-computing/`) with each `_index.md` giving a short description of that domain.
  - Individual certificate pages carry front matter: `title`, `description`, `date`, plus a nested `cert` map containing `issuer`, `awarded`, optional `credential_id`, `link`, and `skills`.
  - The section homepage renders each subsection as a block, highlighting the two latest credentials with a “View all” link into that category.
- **Blog**
  - Standard article layout; include estimated read time, related posts, social share preview.
- **Journal**
  - Stream of concise entries grouped by week or month; optional filters by tag (e.g., `learning`, `shipping`, `roadblock`).
- **Learning Log**
  - Rolling list of current resources, courses, books, with status (active, completed, planned).

## 3. Page Layout Plan

### 3.1 Home
- Hero section: name, tagline, call-to-action buttons (view resume, contact).
- Snapshot cards:
  - Project spotlight (1–2 key projects).
  - Latest certification achieved.
  - Current learning focus (link to learning log).
  - Latest journal entry preview.
- Testimonials or highlight reel (optional).
- Footer with navigation, social links, and newsletter/blog subscription callout.

### 3.2 Projects Page
- Filters at top (tech stack, type, year).
- Grid/list of project cards with summary, tags, and direct link.
- Detail pages containing chronology, problem, approach, outcomes, media gallery, and GitHub links.

### 3.3 Certifications Page
- Display a grid of category blocks (sourced from subsection `_index.md` files) complete with short summaries and the two most recent certs per block.
- Include a clear “View all” call-to-action for each block that routes to the category list, plus issuer/award metadata for quick scanning.
- Ensure blocks respond on mobile (single column) and surface section anchors for deep linking.

### 3.4 Blog Page
- Highlight featured posts.
- Tag cloud and search bar for quick discovery.
- Index that supports pagination and list view with read time.
- Individual post layout: hero image, table of contents, share buttons, related posts.

### 3.5 Journal Page
- Stream or calendar view with filters for mood/status.
- Support for quick-read cards; optionally auto-generated weekly summary.

### 3.6 Learning Log Page
- Sectioned layout:
  - **Currently Learning**: cards showing resource, progress, notes.
  - **Upcoming**: backlog of topics/courses.
  - **Completed**: achievements with reflections and links to journal/blog posts.

## 4. Automation & Maintenance Tasks

| Task | Tooling | Frequency | Notes |
|------|---------|-----------|-------|
| Content sync | Shell/Node script (`sync-content`) | Before commit | Copies Obsidian vault markdown into Hugo `content/`. |
| Local preview | `hugo server` | On demand | Runs live reload preview. |
| Markdown lint | `markdownlint`, `remark` | CI + optional pre-commit | Maintains consistency. |
| Front matter validation | Custom script | CI | Ensures required fields exist. |
| Link checking | `lychee` | Weekly + CI | Scheduled via GitHub Action cron job. |
| Deployment | GitHub Pages/Netlify | On push | Automated via GitHub Actions. |
| Backups | Obsidian Git + repo | Daily | Vault is version-controlled, ensuring redundancy. |

## 5. Implementation Plan

1. **Set Up Hugo Project**
   - Initialize Hugo site under `/` or `/site`.
   - Choose theme or build custom components.
   - Configure sections (`blog`, `journal`, `projects`, `certifications`, `learning`).
2. **Integrate Obsidian Workflow**
   - Move/duplicate existing Obsidian vault into repo.
   - Create sync script and document usage in README.
   - Optional: set up `obsidian-git` to auto-pull/push.
3. **Build Page Layouts**
   - Implement base templates (home, list, single).
   - Create partials for navigation, footers, badges, etc.
4. **Define Content Schemas**
   - Create front matter examples and validation scripts.
   - Draft initial content entries (projects, certifications, first journal entries).
5. **Configure CI/CD**
   - Add GitHub Action for lint → build → deploy.
   - Schedule link checker/health checks.
6. **Document Processes**
   - Update `README.md` with authoring workflow.
   - Provide instructions on adding new content via Obsidian.
7. **Continuous Improvement**
   - Collect feedback, adjust layout (accessibility, dark mode).
   - Add optional integrations (analytics, forms, RSS, newsletter).

## 6. Reader Experience Considerations

- Maintain clear typography hierarchy and generous spacing for readability.
- Provide contextual breadcrumbs and consistent navigation.
- Surface search and tag filters prominently on content-heavy pages.
- Offer quick action buttons (e.g., “View Resume”, “Contact Me”) on relevant pages.
- Ensure responsive design with mobile-first consideration, especially for timeline and card layouts.

With this plan, the system supports effortless content creation from Obsidian, keeps the website structured and navigable, and maintains a reliable automation pipeline for publishing updates. When ready, we can begin implementing the Hugo setup and automation scripts described above.
