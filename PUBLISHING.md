# Publishing Guide — agungsukariman.com

How to write, add images, preview, and publish. Everything runs from this repo on your Mac.

---

## TL;DR — publish in one command

```bash
cd ~/agungsukariman.com
# ...write or edit a post in content/blog/...
./deploy.sh
```

`./deploy.sh` builds the site and pushes it to your homelab. Live in seconds at
**https://agungsukariman.com**. No GitHub, no VPS, no CI.

---

## 1. Write a new post

Scaffold a post (creates the file with front matter already filled in):

```bash
hugo new blog/my-post-title.md
```

- Use a **lowercase-hyphenated** filename — it becomes the URL
  (`my-post-title.md` → `/blog/my-post-title/`).
- The new file starts as a **draft** (`draft = true`), so it won't publish until you flip it.

### Front matter (the `+++` block at the top)

```toml
+++
date = '2026-10-20T14:00:00+07:00'
draft = true
title = 'My Post Title'
tags = ['Cycling', 'Jakarta']   # optional — add your own
+++

Your writing starts here, in Markdown.
```

- `draft = true` → hidden from the live site. **Set it to `false` (or delete the line) when ready to publish.**
- `tags = [...]` is optional; add any you like.
- Keep the `+++` fences (this site uses **TOML** front matter, not `---` YAML).

---

## 2. Add images  ⭐

Images live in the **`static/`** folder and are referenced from the site root with a leading `/`.

**Steps:**

1. Drop the image file into `static/`:
   ```
   static/bali-trip.jpg
   ```
2. Reference it in your post's Markdown (note: **no `static/` in the path**, just `/`):
   ```markdown
   ![A short description of the photo](/bali-trip.jpg)
   ```
3. Publish with `./deploy.sh`.

That's it. The site already styles images nicely (rounded corners, responsive, never overflow).

### Optional: a cover image (thumbnail + social preview)

Add this to the post's front matter to give it a cover (shows on the blog list and when shared on WhatsApp/LinkedIn/etc.):

```toml
[cover]
  image = "/bali-trip.jpg"
  alt = "A short description"
  caption = "Optional caption shown under the image"
```

### Image tips

- **Filenames:** lowercase, hyphenated, no spaces (`my-photo.jpg`, not `My Photo.JPG`).
- **Formats:** `.jpg` for photos, `.png` for screenshots/graphics, `.webp` if you want smaller files.
- **Size:** resize big phone photos down to ~1600px wide before adding — keeps the repo light and pages fast.
- The leading slash matters: `/bali-trip.jpg` ✅  — `bali-trip.jpg` or `static/bali-trip.jpg` ❌.

---

## 3. Preview before publishing

See drafts live as you write:

```bash
hugo server -D
```

Open **http://localhost:1313** — it auto-reloads on every save. Press `Ctrl+C` to stop.
(`-D` means "include drafts".)

---

## 4. Publish

```bash
./deploy.sh
```

What it does:
1. `hugo --gc --minify` → builds the static site into `public/`
2. `rsync --delete` → pushes only changed files to monarki (`~/agungsukariman-stack/site/`)
3. nginx serves the new files **instantly** — no restart needed

Then check **https://agungsukariman.com**.

> If your browser still shows the old version, it's a cache — hard-reload with **Cmd+Shift+R**.

---

## 5. How the hosting works (the short version)

```
Your Mac:  ./deploy.sh  →  hugo build  →  rsync over SSH
                                              │
monarki (homelab):  nginx container  →  Cloudflare Tunnel  →  agungsukariman.com
```

- **Hugo runs only on your Mac** (it's a build tool). monarki never runs Hugo — it just serves the finished HTML.
- No ports are opened on your network; all traffic comes through the Cloudflare Tunnel.
- The site files live on monarki at `~/agungsukariman-stack/site/`.

---

## 6. Handy commands

| Task | Command |
|---|---|
| New post | `hugo new blog/my-title.md` |
| Preview (with drafts) | `hugo server -D` → http://localhost:1313 |
| Publish | `./deploy.sh` |
| Update Hugo itself | `brew upgrade hugo` |
| Check current Hugo version | `hugo version` |

---

## 7. Notes & gotchas

- **Drafts stay hidden.** A post with `draft = true` is skipped by `./deploy.sh`. Flip to `false` to go live.
- **Deleting a post:** remove the `.md` file, then `./deploy.sh` — `rsync --delete` removes it from the live site too.
- **Updating Hugo** is optional and your call (`brew upgrade hugo`). The site builds fine on the current version; the deprecation warnings it prints are harmless.
- **`deploy.sh` is in this repo** — commit it to git if you want it version-controlled.
