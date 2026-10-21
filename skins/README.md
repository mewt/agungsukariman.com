# Skins

Swappable looks for the site. The **active** skin is whatever lives in
`assets/css/extended/custom.css` (the file PaperMod bundles). Each skin here is
a complete, standalone replacement for that file.

| Skin            | Look                                                            |
|-----------------|-----------------------------------------------------------------|
| `geocities-90s` | GeoCities maximalist — starfield, neon, marquee, visitor counter |
| `hp-1998`       | HP.com 1998 corporate — white, dithered blue banners, cream nav |
| `clean`         | The original minimal Inter/Merriweather theme                   |

## Switch

```bash
./switch-skin.sh hp-1998        # activate
./switch-skin.sh                # list + show current
hugo server -D                  # preview
./deploy.sh                     # publish
```

Switching just copies `skins/<name>.css` over `assets/css/extended/custom.css`.
To tweak a skin, edit the file in `skins/`, then re-run `switch-skin.sh` to
apply it. (The theme toggle stays off for all skins; that's set once in
`hugo.toml` via `disableThemeToggle`.)

## Notes

- The GeoCities-only banners (marquee, under-construction, visitor counter,
  88×31 badges) are injected by `layouts/partials/extend_head.html` and
  `extend_footer.html`. The `hp-1998` and `clean` skins hide them with
  `#retro-topbar, #retro-footer { display:none }`.
- `hp-1998` uses the dithered blue banner images in `static/img/hp/`, produced
  with `scripts/retro-image.sh` (see below).

## 90s "distorted" images

That grainy, low-colour look on 1998 sites is **downscale + Floyd-Steinberg
dither to the 216-colour Netscape web-safe palette**, saved as GIF. Reproduce
it with `scripts/retro-image.sh`:

```bash
scripts/retro-image.sh photo.jpg                    # → photo-90s.gif (HP look)
scripts/retro-image.sh photo.jpg out.gif 320 o8     # chunkier ordered dither
scripts/retro-image.sh photo.jpg out.jpg 500 jpeg   # low-q JPEG artefacts
```

Under the hood (the essential ImageMagick command):

```bash
magick netscape: websafe.png                        # the 216-colour palette
magick in.jpg -resize 440x\> -dither FloydSteinberg -remap websafe.png out.gif
```
