# Warpstorm.online — Roadmap

*Startet 2026-11-11. Bygger på `docs/kickoff-drejebog.md`, `docs/warpstorm-grimdark-plan.md`, `drive-docs/tjekliste.txt`, `drive-docs/plan-struktur-monetisering.txt` og `articles/00-status.md`, sammenholdt med live-sitet samme dag.*

## Status lige nu (live-tjek 11/11)

| Område | Status |
|---|---|
| Site | warpstorm.online kører (WP 7.1.4, en_US, Europe/Copenhagen) |
| Indlæg | **17 publiceret** (5 Warhammer-begynder, 8 Workbench, 4 Lore), 0 drafts |
| Sider | Forside, Start Here, About, Contact, Affiliate Disclosure, Privacy Policy, Workbench Hub, Lore Hub (publiceret) |
| Kategorier | Armies 3 · Guides 3 · Hobby 8 · Lore 3 · Strategy 0 · News 0 |
| Plugins | Rank Math, Site Kit, Imagify, W3TC, Really Simple Security, Ads.txt, Meow Analytics, AI Engine m.fl. |
| Mediebibliotek | **0 filer** — ingen billeder eller featured images på sitet |
| Shop | Ingen WooCommerce/Printify endnu |

## Fundne problemer (skal løses først)

1. **Credentials i git:** `warpstorm/.wp-auth-juno` og `warpstorm/.wp-auth-online` er committet. → Fjernet fra tracking + `.gitignore` (Fase 0). **App-passwords skal roteres**, da de stadig ligger i historikken.
2. **Novamira-plugin aktivt i produktion.** Det giver AI-agenter PHP- og filsystemadgang og er ifølge sin egen beskrivelse kun til dev/staging. Det bør deaktiveres, når det ikke bruges.
3. **Dobbelt Privacy Policy:** side 3 (draft, WP-standard) og side 15 (publiceret på `/privacy-policy-2/`). Den skal ligge på `/privacy-policy/`.
4. **Terms & Conditions mangler live.** Payloaden findes (`payloads-final/json/page-7-terms-and-conditions.json`), og siden er lovpligtig før salg.
5. **Ingen billeder:** 12 guide-billeder ligger i `images/` og 10 konceptbilleder i `warpstorm/images/`, men intet er uploadet.
6. **Kategorier:** 4 lore-indlæg, men Lore viser kun 3. Strategy og News er tomme.
7. **Dobbelt kildetræ:** `warpstorm/` er en ældre kopi af roden med afvigende filer. Rodmapperne skal være eneste sandhedskilde.

## Fase 0 — Hygiejne & sikkerhed *(I GANG)*
- [x] Credentials fjernet fra git-tracking, `.gitignore` tilføjet
- [ ] Rotér WP app-passwords (Henning, wp-admin → Users → Profile)
- [ ] Deaktivér Novamira, når det ikke bruges
- [ ] Ryd op i `warpstorm/`-kopien (flet unikke filer ind i roden, og slet derefter mappen)
- [ ] Backup-plan (UpdraftPlus eller Hostinger-backup verificeret)

## Fase 1 — Lanceringsklar (juridisk + teknisk)
- [ ] Privacy Policy: publicér én version på `/privacy-policy/`, og slet dubletten
- [ ] Terms & Conditions + EU-fortrydelsesret (14 dage, produktionstid, forsendelse) live
- [ ] Cookie-banner (GDPR) — nødvendigt, fordi GA/Site Kit kører
- [ ] Footer-links: Privacy · Terms · Affiliate Disclosure · Contact
- [ ] Contact: fungerende formular (WPForms Lite er ikke installeret) eller e-mail
- [ ] Rank Math setup-wizard + Site Kit OAuth (Henning-trin)
- [ ] Mobil-test af forside, hubs og én artikel i hver cluster

## Fase 2 — Billeder & on-page SEO
- [ ] Upload IMAGE-01..12, og sæt featured images på de 5 begynderartikler
- [ ] Featured images til de 12 Workbench/Lore-artikler (genereres; ingen GW-IP)
- [ ] Alt-tekster, Rank Math-meta (title/description) pr. indlæg
- [ ] Ret kategorier: alle 4 lore-indlæg i Lore; overvej at skjule tomme kategorier
- [ ] Interne links: lore ↔ maleguides (fx Warpstorm → plasma-glow), hubs → alle artikler
- [ ] Indsend sitemap i Search Console

## Fase 3 — Indhold: artikel 18–34
Forslag fra `articles/00-status.md`, som skal bekræftes med Henning. Udgivelsestempo: 2–3 om ugen.
- **Warhammer (5):** How to Paint Your First Miniature · Your First 500-Point Game · 40K Glossary for Beginners · Best Starter Paints · Combat Patrol Explained
- **Workbench (5):** Wet Palette DIY · Batch Painting · Basing Guide · Contrast Paints · Miniature Photography
- **Lore (7):** The Beacons · Storm-metal · Ghost Ship Stories II · Zealots deep-dive · Nomads deep-dive · Cults deep-dive · Timeline of the Storm
- Fyld Strategy-kategorien (fx 500-point game, Combat Patrol)

## Fase 4 — Monetisering
1. **Affiliate:** Element Games, eBay, Amazon. Alle links skal have `rel="sponsored nofollow"`, og disclosure skal stå øverst i hvert indlæg.
2. **Print-on-demand (Printify + WooCommerce):** Kun originale grimdark/warp-motiver uden GW-navne og -logoer. Valuta/moms, fragtzoner og testordre før åbning.
3. **Digitale produkter:** Male-tabeller og guide-PDF'er (3–5 €).
4. **Annoncer sidst:** AdSense-plugin ligger klar i `adsense/`, og Ads.txt Manager er aktiv. Aktiveres efter trafik og godkendelse.

## Fase 5 — Vækst & måling
- Månedlig review: Search Console-forespørgsler, top-sider, CTR
- Opdatér "2026"-artikler årligt
- Overvej cosplay/props-klyngen fra kickoff (Fase 1-keywords) som ny sektion

## Bindinger (gælder altid)
Uofficiel fanside med disclosure · ingen GW-logoer eller billeder · generiske produktnavne i shop · `rel="sponsored nofollow"` på affiliate-links · backup før større ændringer.
