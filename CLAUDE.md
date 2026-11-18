# CLAUDE.md — Warpstorm assistant/agent operating guide

Project: https://warpstorm.online; repo: humle93/warpstorm-site; default branch: main.
Published articles are in English; internal notes may be Danish.

## Verified baseline and sources of truth
- Last recorded live inspection: 2026-11-16, NOT a current live confirmation.
- README.md — project architecture/IP rules.
- articles/00-status.md — verified observations and outstanding issues.
- docs/ROADMAP.md — status, blockers and next steps.
- deploy/RUNBOOK.md — safe production updates, backup and rollback.
- wordpress/plugins/warpstorm-ui/ — opt-in mobile-first design plugin.
- docs/UI-SPEC.md — UI scope, quality gates and design tokens.
- docs/RESEARCH-2026-11-18.md — research and limitations.

## Hard requirements
1. DO NOT run deploy/deploy.sh (legacy installer resets site language and may clobber content).
2. DO NOT bulk-push payloads-final, older article copies or stale DB exports: live is newer.
3. Work on feature branches; submit PRs. A Git push is NOT a WordPress deploy.
4. WP writes: read exact live post/slug; compare drift; backup; dry run; edit surgically; canary; verify; rollback.
5. Posts start as draft, human approval before publishing. No unverified product-testing claims.
6. Do not commit passwords, API keys, tokens, cookies, sensitive user data or real affiliate tags.
7. Do not publish or monetize Games Workshop IP-derived fan content without legal/IP clearance. An unofficial disclaimer does not grant a license. Original Warpstorm universe and generic equipment content must remain separate.
8. No Games Workshop images/marks/names in shop listings or commercial tables; ensure proper affiliate disclosure and sponsored link annotations. Never publish placeholder affiliate links.
9. No direct production writes via Novamira/Royal MCP without confirmed narrow access, backups and an approved release.
10. Don't claim tests, progress percentages or live changes without verification.

## UI engineering
- Preserve WordPress Extendable and native block navigation. Don't replace core overlay state management.
- Mobile-first 320px+; 44px targets, visible focus, reduced-motion support, no page-width overflow.
- PHP: escape all dynamic output; never modify admin screens; no network calls/remote fonts.
- Use [warpstorm_hub] shortcode in a draft on staging first. Its hero includes H1: make sure page template does not add a duplicate visible H1.
- Review page slugs/canonical and accessibility before homepage promotion.
- Changes to an article are only via expected-count single-section replacements if live diff allows.

## Developer workflow
Run: bash scripts/build-warpstorm-ui.sh --check
Build: bash scripts/build-warpstorm-ui.sh --package
CI: .github/workflows/warpstorm-ui-ci.yml
Staging install: build/warpstorm-ui.zip (ZIP root: warpstorm-ui).
Manual QA: 320/375/390/768/1024/1440px; Android navigation; JS disabled; keyboard focus; active filters; contrast; original posts; page speed; rollback plugin deactivation.

## Deployment and reporting
Follow release 2 in deploy/RUNBOOK.md. Distinguish clearly:
- developed on branch
- tests passed
- PR opened/merged
- staging verified
- live installed and verified
Keep changes scoped to Warpstorm; don't mix into Command Center.
