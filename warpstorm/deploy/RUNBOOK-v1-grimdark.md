# Grimdark-pakken — RUNBOOK (køres af Juno)

**Trigger:** Så snart app-password til warpstorm.online er landet i `/workspace/warpstorm/.wp-auth-online` (format `bruger:xxxx app-password`).
**Kommando til Henning:** bare "kør Grimdark-pakken".

Regler: REST-kald med 3 s mellemrum · ved 429/503: vent 60 s og prøv igen · alt verificeres i svarene.

## Trin 0 — Preflight
1. `GET /wp-json` → site-navn/URL bekræftes
2. `GET /wp-json/wp/v2/users/me?context=edit` → auth virker + admin-rettigheder

## Trin 1 — Indstillinger
`POST /wp-json/wp/v2/settings` body: `{"title":"Warpstorm","description":"Unofficial Warhammer 40K fan site — beginner guides, army picks and starter sets","language":"da_DK","timezone":"Europe/Copenhagen"}`

## Trin 2 — Plugins (install+aktiv via REST, slug-baseret)
seo-by-rank-math · wpforms-lite · google-site-kit · imagify
(`JETPACK=1` tilføjer jetpack; `SHORTPIXEL=1` swapper imagify ud)
- check: `GET /wp/v2/plugins?search=<slug>` → aktiv? spring over
- ellers: `POST /wp/v2/plugins {"slug":"<slug>","status":"active"}`

## Trin 3 — Tema TT5
- `GET /wp/v2/themes?status=active` → hvis ikke twentytwentyfive:
- `POST /wp/v2/themes {"stylesheet":"twentytwentyfive"}` (fallback `PUT /wp/v2/themes/twentytwentyfive`)

## Trin 4 — Kategorier (Lore, Hære, Strategi, Hobby, Nyheder, Guides)
Pr. kategori: `GET /wp/v2/categories?slug=<slug>` → ellers `POST /wp/v2/categories {"name":"X","slug":"y"}`
Slugs: lore, haere, strategi, hobby, nyheder, guides. Gem id-map i `lib/catmap.env`.

## Trin 5 — Sider (som drafts)
Payloads klar i `payloads/pages/` (forside, start-her, om, kontakt, privatlivspolitik, affiliate-disclosure).
Pr. side: `GET /wp/v2/pages?slug=X` → ellers `POST /wp/v2/pages` med payload + `{"status":"draft"}`.

## Trin 6 — Grimdark CSS v1.1 + permalinks
Primær: upload `plugin/warpstorm-setup.zip` → `POST /wp/v2/plugins` (multipart `-F "package=@…"`) → aktivér → `POST /wp-json/warpstorm/v1/setup {"front":"forside","blog":"start-her"}` (sætter `/%postname%/`, statisk forside, flush rewrites, enqueue CSS).
Fallback (hvis multipart fejler): CSS via `POST /wp/v2/global-styles` `{"version":2,"settings":{},"styles":{"css":"<css>"}}`; permalinks sættes derefter i wp-admin (Settings → Permalinks → Save) — Juno klarer det via browser-session.
NB: global-styles-kaldet og plugin-uploaden kan give transient 401/500 → retry.

## Trin 7 — Artikler 1-5 (drafts)
Payloads i `payloads/articles/*.json` (HTML-konverteret, interlinks intakt, kategorier mappet via catmap).
Pr. artikel: `GET /wp/v2/posts?slug=X&status=draft,publish` → ellers `POST /wp/v2/posts` payload+status.
Billeder: IMAGE-01..12 peger på `/wp-content/uploads/IMAGE-…` — upload senere med samme filnavne, links knækker ikke.

## Trin 8 — Verifikation
- `GET /wp/v2/posts?status=draft` → 5 artikler
- `GET /wp/v2/pages?status=draft` → 6 sider
- `GET /wp/v2/settings` → language da_DK, timezone Europe/Copenhagen, show_on_front page
- `GET /wp/v2/themes?status=active` → twentytwentyfive
- `GET /wp/v2/plugins` → 4-5 aktive
- live check: `https://warpstorm.online/` HTML indeholder grimdark-baggrund (#0A0A0C) efter publish (kan først ses ved udgivelse pga. cache)

## Efter kørslen (ikke i denne pakke)
- Slet helper-plugin (valgfrit, efter verificering)
- Rank Math setup-wizard + Site Kit kræver OAuth (Henning-trin)
- Permalinks-fallback hvis plugin-upload fejlede
- Billedgenerering (IMAGE-01..12) og upload
- Publish = PUBLISH=1 eller udgiv drafts én for én
