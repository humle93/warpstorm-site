# Warpstorm.online — status (16. november 2026, opdateret efter rettelser samme dag)

Målt live via Warp-MCP (Royal MCP) 16/11. Tidligere version: 25/10 (git-historik).

## Sitet
| | |
|---|---|
| Domæne | https://warpstorm.online (TLS ok). warpstorm.dk og grimdarkbuilds.com bruges ikke |
| Hosting | Hostinger · WordPress 7.1.4 · PHP 8.5 · MySQL 8.4 · 110 GB fri |
| Sprog / tid | `en_US` · Europe/Copenhagen |
| Tema | **Extendable 2.2.0** (ikke TT5 som i planen fra oktober) |
| Plugins | 21 aktive: Rank Math, Site Kit, Meow Analytics, Ads.txt Manager, W3 Total Cache, Imagify, Really Simple Security, AI Engine + Meow-pakken, Royal MCP, Novamira m.fl. |
| Kategorier | Hobby 8 · Guides 3 · Armies 3 · Lore 3 · News 0 · Strategy 0 (ingen "Workbench"-kategori) |
| Medier | 12 billeder (uploadet 16/11; før: 0) |

## Indhold live (17 posts, alle publiceret 25/10, sidst rettet 26/10)
| Gruppe | Posts (id) | Ord i repoet |
|---|---|---|
| Begynder (5) | best army (19) · how to start (20) · starter set (21) · Space Marines (22) · Necrons (23) | 900-1.230 |
| Workbench (8) | weathering (43) · 3D terrain (44) · airbrush (45) · hobby tools (46) · plasma (48) · kitbashing (49) · OSL (51) · rust (52) | 650-790 |
| Lore (4, eget univers) | factions (47) · lost expeditions (50) · warp travel (53) · what is the Warpstorm (54) | 470-670 |

Sider: Forside (forside) · Start Here · Workbench Hub · Lore Hub · About · Contact · Privacy Policy · Affiliate Disclosure.
Sider tilføjet 16/11: Terms & Conditions (id 161). Forsiden hedder nu "Home".

## Repo vs. live
- **Workbench (8):** repoet er foran med gear-tabeller med `/go/`-affiliate-links (på `main` siden 16/11), som endnu ikke er live. Før ændringen var repo og live ens.
- **Begynder (5):** live er **nyere** end repoet (og efter 16/11 har de lokale billeder og rettede knapper): `<!-- wp:html -->`-blok, billeder, udvidet disclosure (ikke tilknyttet Games Workshop) og en trademark-linje i bunden. Live er sandheden. Træk det ned før næste ændring (RUNBOOK v2, "Efter release").
- **Lore (4):** ikke sammenlignet byte for byte.

## Fejl fundet live 16/11 — og hvad der er gjort
| # | Fejl | Status |
|---|---|---|
| 1 | 11 "Shop →"-knapper gav blød 404 (`/shop/...`) | ✅ Rettet: Workbench → `#gear`, starter set → `#compare`, Marines/Necrons → starter set-guiden |
| 2 | Begynderbilleder hotlinket fra `steamgears.juno.page`, tomt mediebibliotek | ✅ Rettet: 12 billeder uploadet (id 163-174), URL'er skiftet, udvalgt billede på id 19-23 |
| 3 | `/workbench/`- og `/lore/`-stier i interne links | ✅ Var allerede rettet live (stikprøve af 5 posts; kun repo-kopierne havde dem). Repoet er nu rettet |
| 4 | Forsiden hed "Forside" | ✅ Omdøbt til "Home" |
| 5 | To privatlivssider | ◐ Kladden (id 3) i papirkurven. Den aktive side ligger stadig på `/privacy-policy-2/` (`/privacy-policy/` sender 301); slug skiftes i wp-admin |
| 6 | "How to Paint Your First Miniature" pegede på weathering-guiden | ✅ Linket peger nu på Best Hobby Tools med den rigtige titel |
| 7 | Menuen er WordPress' automatiske sideliste | ⏳ Ikke rørt (temaets navigation skal sættes op i Site Editor) |
| 8 | Novamira aktiv på produktion | ⏳ Ikke rørt (kan være i brug af en anden integration) — Henning beslutter |
| 9 | Kontaktsiden viste `PLACEHOLDER-EMAIL@warpstorm.online` | ◐ Pladsholderen fjernet; ingen kontaktadresse/formular endnu |
| 10 | Privatlivspolitikken nævnte ikke Google Analytics, værten eller affiliate-cookies | ✅ Skrevet om (id 15) |
| 11 | Terms & Conditions manglede | ✅ Oprettet (id 161, `/terms-conditions/`) |
| 12 | Intet cookie-samtykke, selvom Google Analytics kører (EU/Danmark) | ⏳ Kræver et samtykke-plugin + valg — Henning beslutter |

## Indtægt
- Plan (16/11): affiliate på hobby-udstyr først (Wayland 5 %, Amazon ~3-4 %), dernæst egne digitale malerguider til Warpstorm-fraktionerne. Annoncer sidst eller slet ikke: Games Workshops IP-politik nævner annonceindtægt eksplicit som kommerciel brug.
- `adsense/warpstorm-adsense` (plugin) og Ads.txt Manager findes, men der er ingen aktiv AdSense-konto i repoet.
- Affiliate-konti: **ingen endnu.** Uden dem virker `/go/`-linksene ikke (se `docs/affiliate-links.md`).

## Næste skridt (i rækkefølge — fuld version i [`docs/ROADMAP.md`](../docs/ROADMAP.md))
1. Henning: Amazon Associates + Wayland Games, udfyld `docs/affiliate-links.csv`.
2. Release 1 efter `deploy/RUNBOOK.md` (kirurgisk, `deploy/release1-gear-sections.json`): 34 redirects → 8 Workbench-posts → verifikation.
3. Henning: kontakt-e-mail eller formular, cookie-samtykke, privacy-slug, Novamira til/fra, menu.
4. Udvalgte billeder til de 12 Workbench- og Lore-posts (der findes ingen billeder til dem endnu).
5. Begynder-posts: gear-tabeller (starter-udstyr: maling, pensler, værktøj — ingen GW-produktnavne i tabellerne).
6. De resterende 17 artikler (nedenfor). Bemærk: GW's IP-politik siger, at fan-indhold skal være menneskeskabt (ikke generativ AI).

## Resterende artikler (forslag fra 25/10, ikke bekræftet)
- Warhammer: How to Paint Your First Miniature · Your First 500-Point Game · 40K Glossary for Beginners · Best Starter Paints · Combat Patrol explained
- Workbench: Wet Palette DIY · Batch Painting · Basing Guide · Contrast Paints · Miniature Photography
- Lore: The Beacons · Storm-metal · Ghost Ship Stories II · Faction: Zealots deep-dive · Nomads deep-dive · Cults deep-dive · Timeline of the Storm

"How to Paint Your First Miniature" bør komme først: to artikler linker allerede til den.

## Lukket siden 25/10
- WAF-karantænen på POST og den blokerede REST-adgang: sitet blev bygget 25/10, og adgang sker nu via MCP (Warp/Steam-connectorerne).
- TT5 + permalinks: sitet kører Extendable med `/%postname%/`.
