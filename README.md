# agungsukariman.com

Personal site built with Hugo to collect daily reflections, ride reports, and other experiments in public writing.

## Why This Exists
Sharing small stories keeps friends in the loop and creates an archive to revisit later. Hugo keeps the workflow light: write in Markdown, preview immediately, publish when ready.

## Getting Started
- Install the Hugo extended binary (v0.120+ recommended).
- Clone this repo, then run `hugo server -D` to preview drafts at `http://localhost:1313`.
- Draft new pieces with `hugo new "go blog/slug.md"`; long-form posts live under `content/go blog/` using lowercase hyphenated slugs.

## Writing Workflow
- Use TOML front matter wrapped in `+++`, add ISO-8601 dates, and keep titles in sentence case.
- Keep posts short and specific: ride notes, daily wins, weekend projects, or anything worth remembering.
- Drop photos or downloads into `static/`, then link with root-relative paths like `/images/ride-start.jpg`.

## Styling & Structure
- Global settings stay in `hugo.toml`; group related values with two-space indentation.
- Custom tweaks belong in `assets/css/extended/custom.css`; comment anything non-obvious.
- The generated `public/` folder is disposable—inspect builds there but never commit it.

## Publishing Rhythm
1. Write or update a post.
2. Preview locally with `hugo server -D`, clicking through navigation, embeds, and code blocks.
3. Run `hugo --gc --minify` for a clean release build.
4. Commit with an imperative summary like `share weekend ride recap`, then push.

## Learn More
`AGENTS.md` expands on contribution guidelines, build commands, and pull-request expectations for anyone helping maintain the site.
