# SECURITY.md — Prosfora.cy v5

## Browser
- No OpenAI keys, Supabase service role, scraper credentials or admin passwords.
- No third-party JavaScript.
- No `innerHTML` with user or retailer data; DOM nodes use `textContent`/`createElement`.
- Search values are bounded and never become fetch URLs.
- External URLs are HTTPS and checked against an allowlist.
- External links use `noopener noreferrer`.
- CSP blocks inline/remote scripts, objects, forms and framing.
- No analytics, cookies or user accounts in this prototype.

## Scraper / updater
- Hard-coded source URLs only: no user-controlled URL fetches (SSRF defence).
- HTTPS only and host allowlist.
- Redirects rejected.
- 12-second timeout and 2 MB maximum body.
- No embedded retailer JavaScript is executed.
- Expired offer periods are rejected.
- Parse failure preserves last-known-good catalogue where appropriate.
- GitHub Action only receives `contents: write`.

## Database
- Supabase RLS enabled on every table in the included schema.
- Public read is limited to active offers and directory data.
- No public INSERT/UPDATE/DELETE policies.
- Service-role secrets must stay server-side.

## Images
- UI accepts only allowlisted HTTPS image hosts.
- Image load failure falls back locally.
- For production, prefer licensed/self-hosted images. Do not create an arbitrary image proxy.

## Before commercial launch
- Put the site behind Cloudflare/Vercel/another host that can return real HTTP security headers.
- Add admin authentication + MFA only if an admin panel is introduced.
- Add rate limits to any future API.
- Add structured logs without personal data.
- Review each retailer's terms/robots.txt and, where possible, use permissioned feeds or partnerships.
- Add monitoring that alerts on stale sources rather than silently showing old discounts.
