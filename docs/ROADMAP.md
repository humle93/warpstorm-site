# Warpstorm — Roadmap

## Release 2 — Mobile-first UI and deploy automation (18/11/2026)
**Status: code committed on feature branch, NOT installed on production.** Repo-first work can proceed without a WordPress MCP connector.

| Priority | Deliverable | Repo status | Live status / gate |
|---|---|---|---|
| P0 | Opt-in Warpstorm UI WordPress plugin: dark design layer, mobile navigation, accessible Workshop Hub, filtered live articles | Implemented on branch `feat/warpstorm-ui-build-20261118` | Staging install + mobile verification required |
| P0 | Automated package/build and PHP/static contract tests | Script and GitHub Actions workflow added | CI run must pass; no claim of live test |
| P0 | Safe Release 2 runbook, mobile QA and rollback | Documented in `deploy/RUNBOOK.md` | Hostinger backup and staging required |
| P0 | Claude agent operating instructions | New root `CLAUDE.md` | Assistant may code in repo; no production access assumed |
| P1 | Live site audit (navigation, templates, 320/375px overflow, link destinations, H1, CWV) | Checklist ready | Live inspection not available in current session |
| P1 | Cookie consent, contact option, privacy slug and menu | Previously documented defects | Requires production access and verification |
| P1 | Refresh Workbench images / tutorial media | Plan, no fabricated images/tests | Rights-confirmed originals + human editorial review |
| P1 | Affiliate redirects and gear tables | Original Release 1 prepared, still gated | Real partner links, IP/legal review, canary first |
| P2 | GSC-informed SEO clusters and original-universe products | Research brief added | Needs real query and conversion baseline |

**Acceptance:** UI verified on staging at 320/375/390/768/1024/1440px; no horizontal overflow, mobile menu closes, accessible focus/filters, original posts untouched; package installs/rolls back; CI green. Never mark complete in production without evidence.

**Important:** Do not run legacy `deploy/deploy.sh`. Do not bulk overwrite live WordPress articles. See `docs/UI-SPEC.md`, `docs/RESEARCH-2026-11-18.md` and `CLAUDE.md`.


Status pr. **16. november 2026**. Sitet er live på https://warpstorm.online: 17 posts, 9 sider, 12 billeder,
engelsk, Extendable-tema. Al status her er målt live (Warp-MCP) eller i repoet — ikke gættet.
Detaljer pr. post og fejl: [`articles/00-status.md`](../articles/00-status.md). Sådan går ændringer live:
[`deploy/RUNBOOK.md`](../deploy/RUNBOOK.md).

## Mål (endgoal)

**Warpstorm skal være den mest brugbare begynder- og hobbyside for grimdark-miniaturer på engelsk, finansieret
af affiliate på hobbyudstyr og egne digitale produkter til det originale Warpstorm-univers — uden at bygge
forretningen på Games Workshops IP.**

Succeskriterium: **3 kvalificerede Amazon-salg inden for 180 dage efter release 1** (ellers lukker Amazon kontoen),
derefter en stabil månedlig affiliate-indtægt, der kan følges pr. produkt i Redirection-loggen.

Hvorfor den vej (research 16/11): GW's IP-politik siger, at indhold baseret på deres univers ikke må sælges eller
tjenes penge på, og nævner annonceindtægt eksplicit. Hobbyudstyr (pensler, airbrush, værktøj, maling fra andre
mærker) og vores egen lore er ikke GW-IP. Derfor: 40K-guides bringer trafik, udstyr og eget univers tjener pengene.

## Færdigt

| Dato | Hvad | Verifikation |
|---|---|---|
| 25/10 | Sitet bygget: 17 posts (5 begynder, 8 Workbench, 4 Lore), sider, kategorier, Rank Math, Site Kit (GA4) | `wp_get_posts` → 17 `publish` |
| 16/11 | Projektstatus målt live, 12 fejl fundet og dokumenteret | `articles/00-status.md` |
| 16/11 | Gear-tabeller med 34 produkter / 38 `/go/`-links til de 8 Workbench-guides (klar i repoet, **ikke live**) | `deploy/release1-gear-sections.json` |
| 16/11 | Deploy-plan v2: drift-tjek, backup, redirects før indhold, canary, kirurgiske ændringer, rollback. v1 (`deploy.sh`) spærret | `bash deploy/deploy.sh` → exit 2 |
| 16/11 | Live-rettelser: 11 døde shop-knapper, forkert link, billeder flyttet til eget mediebibliotek + udvalgte billeder, "Home", Terms & Conditions, privatlivspolitik, pladsholder-e-mail fjernet | `wp_verify_rendered_page` på `/`, `/best-hobby-tools/` (`#gear`), `/terms-conditions/` |

## Næste (anbefalet rækkefølge)

| # | Opgave | Hvem | Status i dag | Hvorfor nu |
|---|---|---|---|---|
| 1 | **Affiliate-konti** (Amazon Associates, Wayland Games; Element Games via Awin valgfrit) og `affiliate_url` udfyldt i `docs/affiliate-links.csv` | Henning | Ingen konti; CSV har kun søge-URL'er med `YOUR-AMAZON-TAG` | Blokerer al indtægt |
| 2 | **Release 1: gear-tabeller live** — Redirection-plugin, 34 redirects (307), 8 kirurgiske udskiftninger, verifikation | Claude | Release-fil klar; dry-run matchede id 44 og 51 | Første indtægt; ~20 min. når punkt 1 er gjort |
| 3 | **Cookie-samtykke** til Google Analytics (EU/Danmark) | Henning vælger plugin, Claude sætter op | GA4 kører uden samtykke-banner | GDPR-krav, ikke en "senere"-ting |
| 4 | **Kontakt**: offentlig e-mail eller formular | Henning | Siden har ingen kontaktmulighed | Privatlivspolitikken henviser til kontaktsiden |
| 5 | **Småting i wp-admin**: privacy-slug → `privacy-policy`, menu i Site Editor, Novamira fra hvis ubrugt | Henning | Uændret | 10-15 min. i alt |
| 6 | **Gear-tabeller i begynder-posts** (starter-udstyr: værktøj, maling, pensler — ingen GW-produktnavne) | Claude | Live er nyere end repoet; skal trækkes ned først | Begynder-posts er de mest søgte |
| 7 | **"How to Paint Your First Miniature"** (første nye artikel) | Henning skriver, Claude redigerer/SEO | Mangler; to artikler linker til emnet | GW's politik: fan-indhold skal være menneskeskabt |
| 8 | **Udvalgte billeder** til de 12 Workbench- og Lore-posts (egne fotos af eget arbejde er bedst) | Henning | Ingen billeder | Klikrate i Google og deling |

## Senere

- **Digitale produkter til eget univers**: PDF-malerguider og farveskemaer til de tre fraktioner (Industrial Zealots, Void Nomads, Corrupt Cults) via Gumroad/Payhip. Kræver trafik først.
- **De øvrige 16 artikler** fra planen (Workbench: Wet Palette DIY, Batch Painting, Basing, Contrast Paints, Photography; Warhammer: 500-Point Game, Glossary, Starter Paints, Combat Patrol; Lore: 7 stk.).
- **Print-on-demand** med originale Warpstorm-motiver (35 Printify-designs findes i Drive) — kun uden GW-navne og -ikonografi.
- **Command Center-projekt** for warpstorm.online (søgeord, AI-synlighed, crawl) — se Command Centers roadmap.
- **Oprydning i repoet**: behold `articles-v2/` → `html-v2/` → `payloads-final/` + `deploy/`; slet `payloads/`, `payloads-ready/`, `deploy/payloads/`, `deploy/lib/payloads-json/` og spejlet `warpstorm/`.
- **Annoncer**: kun hvis affiliate ikke bærer, og efter en vurdering af GW's IP-politik. AdSense-pluginnet i `adsense/` er ikke i brug.

## Bevidst fravalgt

- Salg af regler, hærlister eller STL-filer af GW-modeller (IP).
- AI-genererede artikler og billeder til nyt fan-indhold (GW's politik kræver menneskeskabt indhold).
- STL-Patreon med egne modeller: stort potentiale, men et job, ikke passiv indtægt.

## Sådan holder vi den ærlig

1. Hvert punkt har en status, der kan tjekkes live eller i repoet.
2. Et punkt flyttes til "Færdigt" med dato og verifikation, først når det er live og tjekket.
3. Roadmap og `articles/00-status.md` opdateres i samme commit som ændringen.
