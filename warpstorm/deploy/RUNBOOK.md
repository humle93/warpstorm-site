# Warpstorm — deploy-plan v2 (opdatering af et live site)

**Skrevet 16. november 2026.** Erstatter "Grimdark-pakken" (v1, nu `RUNBOOK-v1-grimdark.md`), som byggede
sitet i oktober. v1 (`deploy.sh`) må **ikke** køres igen: trin 1 sætter sproget til `da_DK`, trin 4 opretter
danske kategorier, og den kender kun de 5 første artikler. Den ligger kun som historik.

## Udgangspunkt (målt live 16/11 via Warp-MCP)

| | Live |
|---|---|
| Site | https://warpstorm.online · WordPress 7.1.4 · `en_US` · Europe/Copenhagen |
| Indhold | 17 posts publiceret (id 19-23 begynder, 43-54 Workbench + Lore) |
| SEO / måling | Rank Math, Site Kit, Meow Analytics, Ads.txt Manager |
| Cache | W3 Total Cache (+ `advanced-cache.php`, `object-cache.php`) |
| Adgang for Claude | Royal MCP (`Warp`-connector) og Novamira (`Steam`-connector) |

**Drift mellem repo og live:** de 8 Workbench-posts svarer til repoet før gear-tabellerne
(fx best-hobby-tools 5.330 B live mod 5.328 B). De 5 begynder-posts er **nyere live** end
`payloads-final/` (9.660 B mod 9.000 B for best-army). Repoet må derfor aldrig skubbes blindt.

## Principper

1. **Kun det ændrede, kun på slug.** Opdater eksisterende posts (`update`), opret aldrig dubletter.
2. **Drift-tjek før hver skrivning.** Sammenlign live-indholdet med repoets *forrige* version. Afviger det,
   stop: live er blevet rettet et andet sted, og ændringen skal flettes i hånden.
3. **Backup før, revision efter.** WordPress' revisioner er rollback-planen, en JSON-backup er reserven.
4. **Redirects før indhold.** Et `/go/`-link uden redirect er en 404 på et live site.
5. **Én canary først.** Én artikel hele vejen igennem, så resten.
6. **Kirurgisk, ikke hele indholdet.** Live-indholdet afviger i småting fra alle repo-kopier (`<!-- wp:html -->`-blok,
   URL-linjer, rettelser lavet direkte i WordPress). Derfor skiftes kun det ændrede afsnit med `wp_replace_in_post`
   og `expected_count: 1`. Matcher teksten ikke præcis én gang, skrives intet: det er drift-tjekket.
   Release-filen (fx `release1-gear-sections.json`) har `find`/`replace` pr. post.

## Release 1: affiliate-gear-tabeller (8 Workbench-guides)

Branch `ccr-249cc9fd-ntazji` på GitHub. 38 `/go/`-links fordelt på 34 produkter.
Release-fil: [`release1-gear-sections.json`](release1-gear-sections.json) — 8 poster med `post_id`, `find` (den gamle
tabel + note under `<h2 id="gear">`) og `replace` (den nye tabel). Dry-run 16/11: id 44 og 51 matchede præcis 1 gang.

| Post | id | `/go/`-links |
|---|---|---|
| easy-weathering-techniques | 43 | 5 |
| 3d-printed-terrain | 44 | 4 |
| airbrush-for-beginners | 45 | 6 |
| best-hobby-tools | 46 | 6 |
| glowing-plasma-effects | 48 | 4 |
| kitbashing-guide | 49 | 5 |
| object-source-lighting | 51 | 4 |
| rust-and-battle-damage | 52 | 4 |

### Trin 0 — Forudsætninger (Henning)
- [ ] Konto hos Amazon Associates og Wayland Games' affiliate-program (Element Games via Awin: valgfri).
- [ ] `docs/affiliate-links.csv`: kolonnen `affiliate_url` udfyldt for alle 34 rækker
      (Amazon-URL med rigtigt tag i stedet for `YOUR-AMAZON-TAG`, eller Wayland-link fra dashboardet).
- [ ] Branchen flettet til `main` (så repoet er sandheden for det, der går live).

**Stop her, hvis CSV'en ikke er udfyldt.** Uden destinationer gør tabellerne siden dårligere.

### Trin 1 — Preflight (Claude, kun læsning)
- `wp_get_site_info` → `warpstorm.online`, `en_US`.
- `wp_get_posts` → de 8 id'er ovenfor findes og er `publish`.
- Drift-tjek pr. post: `wp_replace_in_post` med `dry_run: true` og `find` fra release-filen → `occurrences: 1`.
  0 eller flere → stop og hent posten for at se, hvad der er ændret.

### Trin 2 — Backup
- Gem hver posts live-indhold i `backups/live-2026MMDD/<slug>.json` (titel, slug, content, modified).
- Tag et Hostinger-snapshot (hPanel → Backups), hvis det er over en uge siden sidste.

### Trin 3 — Redirects (de 34 `/go/`-stier)
- Installér og aktivér pluginnet **Redirection** (gratis). Warp-MCP har værktøjer til det
  (`redirection_create_redirect`), og pluginnet logger klik, så klik pr. produkt kan måles uden ekstra kode.
  Rank Maths Redirections-modul kan bruges i stedet, men kan ikke styres herfra.
- Gruppe "Affiliate". Pr. CSV-række: kilde `/go/<produkt>/`, type **307**, mål = `affiliate_url`.
- Test 3 tilfældige: `curl -sI https://warpstorm.online/go/<produkt>/` → `307` + `Location` med tag.

### Trin 4 — Canary: best-hobby-tools (id 46)
- `wp_replace_in_post` id 46 med `find`/`replace` fra release-filen og `expected_count: 1`. Kun afsnittet under
  `<h2 id="gear">` ændres; titel, slug, kategori, billeder og Rank Math-meta bliver liggende.
- Purge cachen for URL'en (W3 Total Cache).
- Tjek den renderede side (`wp_verify_rendered_page` eller `curl`):
  - tabellen har 4 kolonner og 6 rækker,
  - 6 links med `/go/` og `rel="sponsored nofollow noopener"` (WordPress' filter må ikke have fjernet `rel`/`target`),
  - ét klik giver 307 til butikken.
- OK → trin 5. Fejl → rollback (trin 8) og stop.

### Trin 5 — De 7 andre posts
- Som trin 4, én ad gangen, 3 sekunders pause, drift-tjek igen lige før hver skrivning.

### Trin 6 — Cache og indeks
- Tøm hele W3TC-cachen én gang.
- Rank Math: intet at gøre (slugs og meta er uændrede). Valgfrit: send de 8 URL'er til IndexNow.

### Trin 7 — Verifikation
- Pr. post: `/go/` findes det antal gange, tabellen ovenfor siger (dry-run med `find: "/go/"`), i alt 38.
  Knappen nederst (`href="#gear"`) hopper stadig til tabellen.
- Mobil: én side åbnet ved 375 px bredde. Tabellen må gerne scrolle vandret, men siden må ikke.
- Redirection-loggen viser de test-klik, der er lavet.
- Skriv resultatet i `articles/00-status.md` (dato, hvad gik live, hvad blev ikke verificeret).

### Trin 8 — Rollback
- Pr. post: `wp_restore_revision` til revisionen fra før trin 4/5, eller `wp_update_post` med indholdet fra
  backuppen i trin 2.
- Redirects kan blive liggende (de skader ikke), eller slås fra samlet ved at deaktivere gruppen "Affiliate".

### Efter release
- **Amazon:** kontoen lukkes, hvis den ikke har 3 kvalificerede salg inden for 180 dage. Følg op ved dag 60 og dag 120.
- Hver mandag: klik pr. `/go/`-sti i Redirection-loggen, sammenlignet med salget i affiliate-dashboards.
  Produkter uden klik efter 8 uger skiftes ud eller flyttes højere op i artiklen.
- Begynder-posts (id 19-23): træk live-indholdet ned i repoet (`articles/` + `payloads-final/`),
  før de får gear-tabeller. Ellers overskriver næste release nyere tekst.

## Udført direkte på live 16/11 (uden for release 1)
Alle ændringer lavet med `wp_replace_in_post` (`expected_count`) eller side-opdateringer; WordPress har en revision af hver.
- 11 døde "Shop →"-knapper: Workbench (8) hopper nu til gear-tabellen (`<h2 id="gear">` + `href="#gear"`); starter set → `#compare`;
  Space Marines/Necrons → starter set-guiden. "(affiliate links)" fjernet fra de 3 begynder-knapper.
- "How to Paint Your First Miniature"-linket (id 22, 23) → "Best Hobby Tools for Miniature Painting" (`/best-hobby-tools/`).
- 12 billeder uploadet til mediebiblioteket (id 163-174, med alt-tekst); begynder-posts peger nu på `warpstorm.online/wp-content/uploads/2026/11/`
  i stedet for `steamgears.juno.page`. Udvalgt billede sat på id 19-23, og det første billede i teksten fjernet (temaet viser det udvalgte øverst).
- Forsiden omdøbt "Forside" → "Home". WordPress' standard-privatlivskladde (id 3) i papirkurven.
- Ny side **Terms & Conditions** (id 161, `/terms-conditions/`).
- Kontaktsiden: synlig pladsholder-e-mail fjernet (ingen rigtig adresse sat — afventer Henning).
- Privatlivspolitikken (id 15) skrevet om: Hostinger, Google Analytics 4 (Site Kit), kommentarer, affiliate-cookies, GDPR-rettigheder, Datatilsynet.
- W3TC-cache tømt; forside, begynder-post, hobby tools, starter set, terms og et billede tjekket renderet (200, ankre findes).

## Driftsnoter
- **Novamira** er aktiv på produktion, men beskriver sig selv som "for development and staging only"
  (fuld PHP- og filadgang). Slå den fra, når den ikke er i brug.
- Fem kopier af hver artikel er for mange. Når release 1 er live: slet `payloads/`, `payloads-ready/`,
  `deploy/payloads/`, `deploy/lib/payloads-json/` og spejlet `warpstorm/`, og behold
  `articles-v2/` → `html-v2/` → `payloads-final/`.
- Alt indhold på engelsk. Ingen Games Workshop-navne, -logoer eller -billeder i shop og tabeller (IP-reglen i README).
