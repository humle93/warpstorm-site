# Grimdark Pakke — warpstorm.online

Én-kommando deploy-pakke til Warpstorm (Warhammer 40K-fansitet). Alt er forberedt; intet rører sitet før app-passwordet er landet.

## Indhold
- `deploy.sh` — POSIX-sh-script der kører hele sekvensen (trin 0-8 i RUNBOOK.md), idempotent
- `RUNBOOK.md` — trin-for-trin med exact REST-kald + fallbacks (køres af Juno)
- `payloads/articles/` — 5 færdige artikler som WP-REST-payloads (draft, HTML, interlinks, excerpts)
- `payloads/pages/` — 6 side-payloads (forside, start-her, om, kontakt, privatlivspolitik, affiliate-disclosure)
- `css/grimdark-v1.1.css` — Grimdark CSS v1 + base/grim-komponenter (sort #0A0A0C, rød #8C1D2C, guld #B8963E)
- `plugin/warpstorm-setup/` + `.zip` — helper-plugin: permalinks /%postname%/, statisk forside, CSS-enqueue
- `tools/md2html.py` — markdown→HTML-konverter (kør via Juno scripts ved nye artikler)
- `tools/mkzip.py` — genbygger plugin-zippet

## Aktivering (når Henning har lavet app-password)
1. Gem `bruger:app-password` i `/workspace/warpstorm/.wp-auth-online`
2. Sig "kør Grimdark-pakken"

## IP-regler (binding)
Uofficiel fanside + disclosure på alt · ingen GW-logoer/billeder i shop · generiske produktnavne · rel="sponsored nofollow" på affiliate-links.
