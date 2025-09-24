# Repository Guidelines

## Project Structure & Module Organization
The site uses the Hugo layout: authorship lives in `content/`, grouped by section (for example `content/go blog/` for long-form posts). Shared images, fonts, and other pipeline assets sit in `assets/`, with extended styling in `assets/css/extended/custom.css`. Files dropped in `static/` publish verbatim (e.g. `static/robots.txt`). Generated output belongs in `public/` and should stay untracked. Theme overrides live under `themes/PaperMod/`, and front matter defaults are defined in `archetypes/default.md`.

## Build, Test, and Development Commands
- `hugo server -D` — run a live preview with drafts enabled; rely on it during writing sessions.
- `hugo` — produce a production build into `public/`; the command fails fast if content or templates break.
- `hugo --gc --minify` — clean unused resources and emit optimized assets before publishing or deploying.
- `hugo new go-blog/<slug>.md` — scaffold a new drafted post with the archetype front matter.

## Coding Style & Naming Conventions
Write Markdown with the TOML front matter block produced by the archetype (`+++` fence, title-cased titles, ISO 8601 dates). Use lowercase, hyphenated filenames to match Hugo slug behaviour. Follow two-space indentation in TOML and CSS to stay consistent with existing files. When extending PaperMod, prefer reusable assets in `assets/` over editing theme templates directly, and document any shortcode additions inline.

## Testing Guidelines
Treat a clean `hugo --gc --minify` run as the regression check; investigate and resolve warnings about missing resources or front matter. Review rendered pages in the live preview for layout regressions and broken links. When adding assets, verify they resolve correctly via the `static/` path and that fingerprints appear in the final build.

## Commit & Pull Request Guidelines
Recent commits are short, informal summaries ("push bang", "up up"). Keep messages concise, present-tense, and under 50 characters, optionally adding detail in the body when necessary. For pull requests, describe the reader-facing change, reference related issues, and attach screenshots or build logs whenever the UI or theme changes. Confirm the Hugo build command used and note any follow-up work in the PR description.
