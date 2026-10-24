# KICKOFF — WARHAMMER 40.000 SITE
*Startet 2026-10-21 efter drejebogen "Playbook: Steampunk Site Opskrift" (samme opskrift, nyt univers). Status pr. fase opdateres her.*

## 0. VIGTIG JURIDISK RAMME (læs først)
Warhammer 40.000 tilhører Games Workshop (trademark + copyright på navne, kapitler, designs).
- **Sikkert spor:** Cosplay/DIY-guides, props-teknik (EVA-foam generisk), fan-indhold, "inspired by" hardware-propdele, generiske sci-fi-navne i shop. Fan-art og guides er veletableret i hobbyen.
- **Risikabelt spor:** Merch med GW-navne/logoer (Space Marine, Adeptus Astartes, Imperium-ikonografi) på POD-produkter — GW er kendt for enforcement.
- **Strategi (anbefalet):** Indholdssite = guides + community + inspiration. Shop = generiske sci-fi/dieselpunk-props ("Inquisitor Coat", "Void Trooper Helmet") uden GW-navne. GW-fan-art-annoncer undgås.

## Fase 0 — Fundament (kræver Henning)
1. [ ] **Domain + hosting** (Simply som Steamgears? foreslå: warhammerworkshop.com / grimdarkbuilds.com / 40kworkshop.com — evt. "grimdark"-vinkel for IP-afstand)
2. [ ] WP oprettet → Juno admin/editor + app-passwords
3. [ ] Når login findes: resten af Fase 0-1 kører autonomt

## Fase 1 — Keyword- og SERP-kort (STARTET 21/10)
SERP-scan 21/10 (US/EN), status: konkurrentlandskabet er SPARSET vs. steampunk — stort hul:
- instructables.com/Gary-Sterleys-40k-Space-Marine (single guide, 2015'ish)
- spikeybits.com 40k Cosplay Guide (blog, senior men tynd)
- Reddit-tråde (int struktureret indhold) + Etsy-markedsider
- YouTube: EVA-foam-playlister (video-rank, få skriftlige guides)
- **Konklusion: ingen dominerende guide-site. Reddit+YouTube+2 blogs = slåbart felt. Høj efterspørgsel, lav indholdskvalitet.**

Foreslået keyword-klynge (prioritet 1-5, bekræftes med fuld scan når site findes):
| Keyword | Format | Prio |
|---|---|---|
| warhammer 40k costume guide | guide-hub | 5 |
| space marine armor diy / eva foam | tutorial-serie | 5 |
| warhammer cosplay for beginners | guide | 5 |
| 40k helmet diy (Mark VII-generisk) | projekt | 4 |
| imperial guard costume | projekt | 4 |
| warhammer prop weapons (chainsword, bolter) | tutorial | 5 |
| grimdark costume ideas | liste | 3 |
| cheap warhammer cosplay | guide | 4 |
| best foam for cosplay armor | købs-/info | 3 |
| warhammer halloween costume | sæson | 4 |

## Fase 2 — Design (skitse, afsluttes når WP findes)
- Palette: sort #0A0A0C · rød accent #8C1D2C (grimdark) · guld #B8963E · bone #E8E0D0 · stålgrå #6E7479
- Fonts: gotisk/display-header (Fx Cinzel eller Rye-ækvivalent) + Inter body
- Motiver: gothiske rammer, aquila-generiske vinger, rust/metalstrukturer, parchment
- CSS-template genbruges fra Steamgears v3 (workshop-stationer, projektkort) med grimdark-tema

## Fase 3+ — Indholdsmotor & butik
- Første 5 indlæg (klar til udgivelse når WP er oppe): 1) Warhammer 40k Cosplay for Beginners 2) EVA Foam 101 for Space Marine Armor 3) DIY Chainsword Prop 4) Imperial Guard Flak Vest 5) Grimdark Costume Ideas
- Butik: generiske grimdark-props + poster (ingen GW-IP) via Printify/AliExpress

## Status-log
- 2026-10-21: Kickoff + Fase 1 SERP-scan lavet. Venter på domain/hosting fra Henning (Fase 0).
- 2026-10-21 (2): Henning valgte **grimdarkbuilds.com** (verificeret ledig). Hostinger-koblet: abonnement "Ecommerce Growth" (trial, monthly, id Azq93yVYgqELVrcO). KENDT GRÆNSE: Hostinger-API kan IKKE oprette websites eller købe domains — Henning gør i hPanel: (1) køb grimdarkbuilds.com, (2) Add Website → WordPress → vælg domain. DEREFTER: Juno overtager 100% (Fase 0-7, autonom).
- Grimdark CSS v1 er skrevet offline (/workspace/tmp/warhammer/css-v1-grimdark.css) — Steamgears v3-komponenter (stationer/projektkort/portal/looks) genskrevet i grimdark-palette (#0A0A0C/#8C1D2C/#B8963E/#E8E0D0).
- 2026-10-21 (3): DOMAIN-ÆNDRING fra Henning: sitet hedder **warpstorm.dk** (ikke grimdarkbuilds.com). warpstorm.dk verificeret optaget (is_available=false), DNS resolverer endnu ikke (getaddrinfo fail) og ligger IKKE i Hostinger-kontoen endnu → sandsynligvis købt/under opsætning hos anden registrar (fx Simply) eller foretaget just nu. grimdarkbuilds.com blev købt 16:42 (Hostinger, aktiv) — refund-window (.com ~ først dage) kan udnyttes hvis navnet opgives. Status: afventer DNS/site-link fra Henning.
