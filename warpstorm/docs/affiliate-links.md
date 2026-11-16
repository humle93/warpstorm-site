# Affiliate-links (Workbench-guides)

**Status 16/11 2026:** gear-tabeller med "Check price →" i alle 8 Workbench-guides (airbrush, hobby tools, glow, weathering, rust, kitbashing, 3D terrain, OSL). 34 produkter.

## Sådan virker det
- Artiklerne linker **aldrig direkte** til en butik, men til en intern sti: `/go/<produkt>/` (fx `/go/iwata-neo-cn/`).
- Alle `/go/`-links i HTML har `rel="sponsored nofollow noopener"` og `target="_blank"`.
- Destinationen sættes ét sted: en 301/307-redirect i WordPress. Skift butik eller tag → ingen artikel skal røres.
- Kortet over alle links: [`affiliate-links.csv`](affiliate-links.csv) (`go_path`, produkt, hvilke artikler, Amazon-søge-URL, tom kolonne `affiliate_url`).

## Før links virker (ellers giver de 404)
1. Tilmeld Amazon Associates og Wayland Games' affiliate-program (gratis; Wayland = 5 % pr. salg). Element Games: tjek sats i Awin.
2. Udfyld `affiliate_url` i CSV'en: Amazon-søge-URL'en med dit rigtige tag i stedet for `YOUR-AMAZON-TAG`, eller et Wayland-link fra deres affiliate-dashboard (bedst til maling, pensler og værktøj).
3. Opret redirects i Rank Math → Redirections (modulet skal slås til; Rank Math er allerede i plugin-pakken) — kilde `go/<produkt>/`, type 307, destination = `affiliate_url`. Alternativ: Pretty Links/ThirstyAffiliates.
4. Tjek ét link pr. artikel i et privat vindue.

## Regler
- Kun generiske produkter og tredjepartsmærker (Vallejo, AK Interactive, Army Painter, Iwata, Winsor & Newton …). **Aldrig** Games Workshop-produkter eller -navne i tabellerne (IP-reglen i README).
- Ingen priser i teksten — de ændrer sig; linket viser den aktuelle.
- Nye produkter: tilføj række i CSV + redirect, brug samme `/go/`-sti i alle artikler, der nævner produktet.
