# Warpstorm.online — status (16. november 2026)

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
| Medier | **0 filer i mediebiblioteket** |

## Indhold live (17 posts, alle publiceret 25/10, sidst rettet 26/10)
| Gruppe | Posts (id) | Ord i repoet |
|---|---|---|
| Begynder (5) | best army (19) · how to start (20) · starter set (21) · Space Marines (22) · Necrons (23) | 900-1.230 |
| Workbench (8) | weathering (43) · 3D terrain (44) · airbrush (45) · hobby tools (46) · plasma (48) · kitbashing (49) · OSL (51) · rust (52) | 650-790 |
| Lore (4, eget univers) | factions (47) · lost expeditions (50) · warp travel (53) · what is the Warpstorm (54) | 470-670 |

Sider: Forside (forside) · Start Here · Workbench Hub · Lore Hub · About · Contact · Privacy Policy · Affiliate Disclosure.
Mangler live i forhold til `payloads-final/`: **Terms & Conditions**.

## Repo vs. live
- **Workbench (8):** repoet er foran med gear-tabeller med `/go/`-affiliate-links (branch `ccr-249cc9fd-ntazji`), som endnu ikke er live. Før ændringen var repo og live ens.
- **Begynder (5):** live er **nyere** end repoet: `<!-- wp:html -->`-blok, billeder, udvidet disclosure (ikke tilknyttet Games Workshop) og en trademark-linje i bunden. Live er sandheden. Træk det ned før næste ændring (RUNBOOK v2, "Efter release").
- **Lore (4):** ikke sammenlignet byte for byte.

## Fejl fundet live 16/11
1. **11 "Shop →"-knapper giver 404.** `/shop/airbrush|paints|tools|weathering|printers|starter-sets|space-marines|necrons/` findes ikke. Siden svarer 200 med "Page Not Found" (blød 404, `noindex`). Rettes ved at pege knapperne på `/go/`-links eller artiklens gear-tabel.
2. **Billederne ligger uden for sitet.** De 12 begynderbilleder hotlinkes fra `steamgears.juno.page/warpstorm-cdn/`, og mediebiblioteket er tomt. Hvis den vært forsvinder, mister artiklerne alle billeder. Filerne ligger i `images/` og bør uploades. Workbench- og Lore-posts har ingen billeder og ingen udvalgte billeder.
3. **52 interne links bruger `/workbench/<slug>/` og `/lore/<slug>/`**, men posts ligger på `/<slug>/`. De virker kun, fordi WordPress gætter og sender 301. Bør rettes til de rigtige adresser.
4. **Forsiden hedder "Forside"** i titel og menu på et engelsk site ("Forside - Warpstorm" i Google). Omdøb til "Home".
5. **To privatlivssider:** id 3 (kladde, WordPress' standard) og id 15 på `/privacy-policy-2/` (`/privacy-policy/` sender 301 dertil). Slet kladden og giv id 15 slug `privacy-policy`.
6. **Linktekst passer ikke:** "How to Paint Your First Miniature" (Space Marines- og Necrons-guiden) peger på weathering-guiden; artiklen findes ikke.
7. **Menuen** er WordPress' automatiske sideliste (8 sider alfabetisk, ingen kategorier).
8. **Novamira** (fuld PHP-adgang, "for development and staging only") er aktiv på produktion.

## Indtægt
- Plan (16/11): affiliate på hobby-udstyr først (Wayland 5 %, Amazon ~3-4 %), dernæst egne digitale malerguider til Warpstorm-fraktionerne. Annoncer sidst eller slet ikke: Games Workshops IP-politik nævner annonceindtægt eksplicit som kommerciel brug.
- `adsense/warpstorm-adsense` (plugin) og Ads.txt Manager findes, men der er ingen aktiv AdSense-konto i repoet.
- Affiliate-konti: **ingen endnu.** Uden dem virker `/go/`-linksene ikke (se `docs/affiliate-links.md`).

## Næste skridt (i rækkefølge)
1. Henning: Amazon Associates + Wayland Games, udfyld `docs/affiliate-links.csv`.
2. Release 1 efter `deploy/RUNBOOK.md`: 34 redirects → 8 Workbench-posts → verifikation.
3. Ret fejl 1, 3-6 ovenfor (små indholdsrettelser, samme release-metode).
4. Upload de 12 billeder til mediebiblioteket og skift URL'erne; lav udvalgte billeder til alle 17 posts.
5. Træk begynder-posts ned i repoet og giv dem gear-tabeller.
6. De resterende 17 artikler fra planen (forslag nedenfor).

## Resterende artikler (forslag fra 25/10, ikke bekræftet)
- Warhammer: How to Paint Your First Miniature · Your First 500-Point Game · 40K Glossary for Beginners · Best Starter Paints · Combat Patrol explained
- Workbench: Wet Palette DIY · Batch Painting · Basing Guide · Contrast Paints · Miniature Photography
- Lore: The Beacons · Storm-metal · Ghost Ship Stories II · Faction: Zealots deep-dive · Nomads deep-dive · Cults deep-dive · Timeline of the Storm

"How to Paint Your First Miniature" bør komme først: to artikler linker allerede til den.

## Lukket siden 25/10
- WAF-karantænen på POST og den blokerede REST-adgang: sitet blev bygget 25/10, og adgang sker nu via MCP (Warp/Steam-connectorerne).
- TT5 + permalinks: sitet kører Extendable med `/%postname%/`.
