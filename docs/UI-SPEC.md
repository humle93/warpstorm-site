# Warpstorm mobile-first UI specification — 2026-11-18

Status: feature branch only. NOT deployed on warpstorm.online.

## Objective
Modern, coherent grimdark editorial UX without copying protected franchise artwork, clutter, or navigation breakage. Keep existing 17 articles, page slugs, categories and site configuration intact.

## Information architecture
- Start Here: beginner guides
- The Workbench: Hobby articles and practical tutorials
- Original Lore: independent Warpstorm universe
- Explore Armies: orientation articles
- Latest: current WordPress posts (not placeholder cards)
Existing term slugs and destinations must be checked on production before launch.

## Design tokens
Background #0a0d13; panel #111722; elevated panel #17202d; text #eef1f5; muted #adb8c7; gold #ddb96d.
Typography: performant system stack; restrained, clear editorial headings. Card treatment: thin borders, subtle gradients and rounded 13px corners.
Fluid hero font; responsive card columns 1/2 at >=640px, article columns 1/2/3 at 0/640/1024px.
No remote fonts, animation libraries or intrusive popups.

## Built components
- Progressive enhancement WordPress plugin (no theme replacement).
- Body-scoped dark design layer for frontend.
- [warpstorm_hub] shortcode; hero, actual category archive cards, nine latest published articles, simple client-side filters, IP disclaimer.
- WordPress pattern allowing editor insertion into a staging/draft page.
- Mobile-friendly WordPress nav, table overflow handling, keyboard focus and motion preferences.
- Filtering works offline with existing server-rendered markup. With JavaScript off all articles remain visible.

## Release gates
1. CI: syntax and contract tests pass, package built with warpstorm-ui as ZIP root.
2. Staging: plugin activation no warnings/fatal errors, original articles unaffected.
3. Navigation: hamburger opens/closes with touch and keyboard; selecting nav item dismisses overlay; no scroll locking.
4. Viewports: 320, 375, 390, 768, 1024, 1440px; no horizontal page overflow.
5. Content: compare IDs, slugs, modified timestamps and URL responses before/after.
6. UX/a11y: meaningful headings, 44px targets, reduced motion, contrast, filters aria-pressed.
7. SEO: no duplicate H1, correct canonical tags, sitemap unaffected, minimal CWV regression.
8. Compliance: independent-site notice remains; no unapproved commercial links.
9. Rollback: deactivate plugin and restore page revision if shortcode was inserted.

## Scope exclusions
No automatic theme installation, published-page rewrites, affiliate redirect enablement, auto-publishing, taxonomy restructuring, deletions or domain changes.
