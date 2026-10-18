# Prosfora.cy v5 — complete no-AI prototype

This build implements the site end-to-end **without OpenAI**.

## What is already included

- Current retailer set: **Alphamega, Lidl, METRO, Sklavenitis**.
- Real public store addresses and direct Google Maps links.
- Current verified seeded offers from public Alphamega and Lidl pages (checked 1 Oct 2026).
- METRO current-offers adapter that refuses expired periods.
- Sklavenitis store/catalogue connection without inventing product-level offers.
- Search, store/city/category/discount filters, sorting and offer detail modal.
- Common English/Russian/Greek grocery aliases without AI.
- Store directory with storefront photo when a known source is configured and a local safe fallback.
- Optional official product image field. The UI only loads HTTPS images from allowlisted hosts and falls back to a local category visual.
- Scheduled GitHub Action every 6 hours.
- Last-known-good behaviour: a broken retailer parser does not wipe good current data.
- Data validation workflow on every push/PR.
- Optional Supabase schema with RLS and no public write policies.
- Production-style security header template (`_headers`).
- One-click-ish Mac launcher (`RUN-ME-MAC.command`).

## Important correction from v4

Papantoniou is no longer treated as a separate current chain. Its stores joined the Sklavenitis network; this build uses **Sklavenitis** as the retailer and keeps the current official Sklavenitis directory.

## Run on Mac

Easiest: double-click `RUN-ME-MAC.command`.

Or in Terminal:

```bash
cd ~/Downloads/prosfora-v5-complete-no-ai
python3 -m http.server 8000
```

Open http://localhost:8000

## GitHub Pages

Upload the whole folder. In the repo:

1. Settings → Pages → Deploy from branch → `main` → `/ (root)`.
2. Settings → Actions → General → Workflow permissions → Read and write permissions.
3. Run **Update Prosfora catalogue** manually once from Actions.

The site works even if the updater is never run; it uses the checked-in JSON catalogue.

## Product/store images

Store photos configured here are external source images used only as prototype references and carry a source link. Before a commercial launch, obtain retailer permission or replace them with licensed/self-shot images.

For product photos, the data model supports `imageUrl`. The browser only accepts allowlisted HTTPS retailer/image hosts. If no safe official product image is available, the UI shows a local visual instead of scraping random images from the web.

## Automatic offer collection

`scripts/update_offers.mjs` is deliberately conservative:

- URLs are hard-coded and allowlisted — users cannot make the server fetch arbitrary URLs.
- 12 s timeout, 2 MB response limit, HTTPS only, redirects rejected.
- Expired offers are not published.
- Parsers only publish records that contain product, old/new price and validity.
- If a source changes HTML and parsing fails, last-known-good current records are retained for Alphamega/Lidl.
- METRO is only published when its official page contains a current active period.
- Sklavenitis stays directory/catalogue-only until a reliable public product-level source is available.

## Supabase (optional)

`supabase/schema.sql` creates retailers, branches, offers and source-runs tables and enables RLS.
Public clients get SELECT only. There are intentionally no public write policies.

Keep `SUPABASE_SERVICE_ROLE_KEY` only in GitHub/Vercel/Cloudflare server secrets — never in `app.js`.

## No OpenAI

There is no OpenAI package, key, API call or hidden AI dependency anywhere in this build.
