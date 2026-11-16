# warpstorm-site

Versionstyring for **Warpstorm**: https://warpstorm.online, en uofficiel engelsksproget Warhammer 40K-fanside
(begynderguides, Workbench-hobbyguides og et eget sci-fi-univers). WordPress kører på Hostinger. Repoet holder
artikler, deploy-payloads, planer og design-assets.

**Status (16/11 2026):** live med 17 posts, 9 sider og 12 billeder. Roadmap: [`docs/ROADMAP.md`](docs/ROADMAP.md) ·
status pr. post og fejl: [`articles/00-status.md`](articles/00-status.md) · deploy: [`deploy/RUNBOOK.md`](deploy/RUNBOOK.md).

## Struktur
- `articles/` — de 5 begynderartikler (md) + `00-status.md` (projektstatus). Live er nyere end disse md-filer.
- `articles-v2/` → `html-v2/` → `payloads-final/` — Workbench + Lore (12 artikler): md er kilden, `payloads-final/json/` er det, der deployes.
- `deploy/RUNBOOK.md` — **deploy-plan v2** for det live site (drift-tjek, backup, redirects, canary, rollback).
  v1 = `RUNBOOK-v1-grimdark.md`; `deploy.sh` er v1 og nægter at køre uden `LEGACY_V1=1`.
- `docs/ROADMAP.md` — mål, færdigt, næste (med hvem), senere og fravalg.
- `deploy/release1-gear-sections.json` — release 1: find/replace pr. Workbench-post.
- `docs/affiliate-links.md` + `.csv` — de 34 `/go/`-affiliate-links i Workbench-guiderne og opsætningen af redirects.
- `docs/warpstorm-grimdark-plan.md`, `docs/kickoff-drejebog.md` — oprindelige planer fra oktober (historik; afvigelser står øverst i planen).
- `images/` — 12 begynderbilleder (live hotlinket fra en ekstern vært; skal uploades).
- `drive-docs/` — kildetekster og designkoncepter fra Drive-mappen "Warpstorm".
- `adsense/` — lille AdSense-plugin (ikke i brug).
- `meta-updates/`, `page-updates/`, `payloads*/` — ældre REST-payloads. `warpstorm/` er et spejl af hele repoet (holdes ens; skal ryddes op).

## Bindinger (IP-regel)
- Uofficiel fanside: guides, lore og cosplay er OK. Disclosure og "ikke tilknyttet Games Workshop" på alle artikler.
- Shop og gear-tabeller: ALDRIG Games Workshop-navne, -logoer eller -billeder — kun generiske produkter og tredjepartsmærker.
- `rel="sponsored nofollow"` på affiliate-links (`/go/`-stier).
- Ingen annonceindtægt på 40K-indhold uden at overveje GW's IP-politik (den nævner annonceindtægt som kommerciel brug).

## Noter
- Live-adgang for Claude: Warp-connectoren (Royal MCP) og Steam/Novamira. Containerens netværk når ikke warpstorm.online direkte.
- Ændringer går live efter `deploy/RUNBOOK.md`, aldrig ved at skubbe hele repoet.
