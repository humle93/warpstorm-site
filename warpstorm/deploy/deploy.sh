#!/usr/bin/env bash
# ============================================================
# GRIMDARK PAKKE v1 — warpstorm.online one-shot deploy
# Kører: settings → plugins → tema → kategorier → sider → CSS
#        → permalinks/frontpage (helper) → artikel 1-5 som drafts
# Brug:  bash deploy.sh [BASE_URL]
# Kræver: AUTH i env eller /workspace/warpstorm/.wp-auth-online ("user:app-password")
# Env:   PUBLISH=1 (udgiv i stedet for drafts) · JETPACK=1 · SHORTPIXEL=1
# Idempotent: kan genkøres — eksisterende objekter springes over.
# ============================================================
set -u
BASE="${1:-https://warpstorm.online}"
HERE="$(cd "$(dirname "$0")" && pwd)"
AUTH_FILE="${AUTH_FILE:-/workspace/warpstorm/.wp-auth-online}"
AUTH="${AUTH:-}"
[ -z "$AUTH" ] && [ -f "$AUTH_FILE" ] && AUTH="$(head -1 "$AUTH_FILE" | tr -d ' \r\n')"
if [ -z "$AUTH" ]; then echo "FEJL: ingen auth. Opret $AUTH_FILE med 'bruger:app-password'"; exit 1; fi

STATUS_DRAFT="draft"; [ "${PUBLISH:-0}" = "1" ] && STATUS_DRAFT="publish"
SLEEP="${SLEEP:-3}"
MAP="$HERE/lib/catmap.env"; mkdir -p "$HERE/lib"; : > "$MAP"
FAILS=0

api() { # api METHOD PATH [JSON_BODY]
  local m="$1" p="$2" b="${3:-}" code out
  out="$(curl -sS -u "$AUTH" -X "$m" -H "Content-Type: application/json" \
        ${b:+--data "$b"} -o "$HERE/lib/last.json" -w "\n%{http_code}" \
        "$BASE/wp-json$p" 2>&1)" || { echo "  ! curl-fejl: $out"; return 1; }
  code="$(printf '%s' "$out" | tail -1)"
  if [ "$code" = "429" ] || [ "$code" = "503" ]; then
    echo "  … rate-limit ($code) — venter 60s og prøver igen"; sleep 60
    out="$(curl -sS -u "$AUTH" -X "$m" -H "Content-Type: application/json" \
          ${b:+--data "$b"} -o "$HERE/lib/last.json" -w "\n%{http_code}" "$BASE/wp-json$p")" && code="$(printf '%s' "$out" | tail -1)"
  fi
  [ "$code" = "200" ] || [ "$code" = "201" ] || { echo "  ! HTTP $code på $m $p"; head -c 300 "$HERE/lib/last.json"; echo; return 1; }
  return 0
}

get_id_by_slug() { # get_id_by_slug TYPE SLUG → id eller tom
  local type="$1" slug="$2" id
  api GET "/wp/v2/$type?slug=$slug&status=draft,publish,future,private&per_page=1" >/dev/null 2>&1 || { api GET "/wp/v2/$type?slug=$slug&per_page=1" >/dev/null 2>&1 || return 0; }
  id="$(jq -r '.[0].id // empty' "$HERE/lib/last.json" 2>/dev/null)"
  printf '%s' "$id"
}

echo "== 0/8 Preflight =="
api GET "/wp/v2/users/me?context=edit" >/dev/null || { echo "FEJL: auth afvist af $BASE"; exit 1; }
jq -r '"  auth: " + .name + " (id " + (.id|tostring) + ")"' "$HERE/lib/last.json"

echo "== 1/8 Indstillinger (sprog/tid/title) =="
api POST "/wp/v2/settings" '{"title":"Warpstorm","description":"Unofficial Warhammer 40K fan site — beginner guides, army picks and starter sets","language":"da_DK","timezone":"Europe/Copenhagen"}' \
  && echo "  OK: title/language=da_DK/timezone=Europe/Copenhagen" || FAILS=$((FAILS+1))
sleep "$SLEEP"

echo "== 2/8 Plugins =="
PLUGINS="seo-by-rank-math wpforms-lite google-site-kit imagify"
[ "${JETPACK:-0}" = "1" ] && PLUGINS="$PLUGINS jetpack"
[ "${SHORTPIXEL:-0}" = "1" ] && PLUGINS="shortpixel-image-optimiser $PLUGINS imagify"
for slug in $PLUGINS; do
  if api GET "/wp/v2/plugins?search=$slug" >/dev/null 2>&1; then
    inst="$(jq -r '[.[] | select(.plugin | startswith("'$slug'"))][0].plugin // empty' "$HERE/lib/last.json" 2>/dev/null)"
  else inst=""; fi
  if [ -n "$inst" ]; then
    st="$(jq -r --arg p "$inst" '.[] | select(.plugin==$p) | .status' "$HERE/lib/last.json" 2>/dev/null)"
    if [ "$st" = "active" ]; then echo "  OK: $slug allerede aktiv"; else
      api PUT "/wp/v2/plugins/$inst" '{"status":"active"}' && echo "  OK: $slug aktiveret" || FAILS=$((FAILS+1)); fi
  else
    api POST "/wp/v2/plugins" "{\"slug\":\"$slug\",\"status\":\"active\"}" \
      && echo "  OK: $slug installeret + aktiveret" || { echo "  ! $slug FEJLEDE (fortsætter)"; FAILS=$((FAILS+1)); }
  fi
  sleep "$SLEEP"
done

echo "== 3/8 Tema: Twenty Twenty-Five =="
if api GET "/wp/v2/themes?status=active" >/dev/null 2>&1; then
  cur="$(jq -r '.[0].stylesheet // empty' "$HERE/lib/last.json" 2>/dev/null)"
  if [ "$cur" = "twentytwentyfive" ]; then echo "  OK: TT5 er allerede aktivt";
  else
    api POST "/wp/v2/themes" '{"stylesheet":"twentytwentyfive"}' && echo "  OK: TT5 aktiveret" \
      || { api PUT "/wp/v2/themes/twentytwentyfive" '{}' && echo "  OK: TT5 aktiveret (PUT)" || FAILS=$((FAILS+1)); }
  fi
fi
sleep "$SLEEP"

echo "== 4/8 Kategorier =="
cat_add() { # navn|slug
  local name="${1%%|*}" slug="${1#*|}" id
  id="$(get_id_by_slug categories "$slug")"
  if [ -n "$id" ]; then echo "  OK: $name (findes, id $id)"; else
    api POST "/wp/v2/categories" "{\"name\":\"$name\",\"slug\":\"$slug\"}" \
      && id="$(jq -r '.id' "$HERE/lib/last.json")" && echo "  OK: $name (id $id)" || FAILS=$((FAILS+1))
  fi
  [ -n "$id" ] && printf '%s=%s\n' "$name" "$id" >> "$MAP"
}
cat_add "Lore|lore"; sleep 1
cat_add "Hære|haere"; sleep 1
cat_add "Strategi|strategi"; sleep 1
cat_add "Hobby|hobby"; sleep 1
cat_add "Nyheder|nyheder"; sleep 1
cat_add "Guides|guides"; sleep 1

echo "== 5/8 Sider (status: $STATUS_DRAFT) =="
for f in "$HERE"/payloads/pages/*.json; do
  slug="$(jq -r '.slug' "$f")"; title="$(jq -r '.title' "$f")"
  id="$(get_id_by_slug pages "$slug")"
  if [ -n "$id" ]; then echo "  OK: side '$title' (findes, id $id)"; continue; fi
  api POST "/wp/v2/pages" "$(cat "$f" | jq -c '. + {status:"'$STATUS_DRAFT'"}')" \
    && echo "  OK: side '$title' (id $(jq -r '.id' "$HERE/lib/last.json"))" || FAILS=$((FAILS+1))
  sleep "$SLEEP"
done

echo "== 6/8 Grimdark CSS + permalinks (helper-plugin) =="
PLUGIN_ID=""
if api GET "/wp/v2/plugins?search=warpstorm-setup" >/dev/null 2>&1; then
  PLUGIN_ID="$(jq -r '[.[] | select(.plugin | startswith("warpstorm-setup"))][0].plugin // empty' "$HERE/lib/last.json" 2>/dev/null)"
fi
if [ -n "$PLUGIN_ID" ]; then
  echo "  OK: helper-plugin findes ($PLUGIN_ID)"
else
  up="$(curl -sS -u "$AUTH" -X POST -F "package=@$HERE/plugin/warpstorm-setup.zip" \
       -o "$HERE/lib/last.json" -w "%{http_code}" "$BASE/wp-json/wp/v2/plugins" 2>&1 | tail -1)"
  if [ "$up" = "200" ] || [ "$up" = "201" ]; then
    PLUGIN_ID="$(jq -r '.plugin // empty' "$HERE/lib/last.json" 2>/dev/null)"
    echo "  OK: helper-plugin uploadet ($PLUGIN_ID)"
  else
    echo "  ! Multipart-upload fejlede (HTTP $up) — CSS tages via global-styles; permalinks sættes manuelt senere"
    FAILS=$((FAILS+1))
  fi
fi
if [ -n "$PLUGIN_ID" ]; then
  api PUT "/wp/v2/plugins/$PLUGIN_ID" '{"status":"active"}' && echo "  OK: helper-plugin aktiv" || FAILS=$((FAILS+1))
  sleep "$SLEEP"
  api POST "/warpstorm/v1/setup" '{"front":"forside","blog":"start-her"}' \
    && jq -r '"  OK: setup → " + (.permalink_structure // "?") + " · front=" + ((.page_on_front // "-")|tostring) + " · blog=" + ((.page_for_posts // "-")|tostring)' "$HERE/lib/last.json" \
    || FAILS=$((FAILS+1))
else
  echo "  - Fallback: CSS injectes via global-styles"
  CSSJSON="$(jq -Rs . < "$HERE/css/grimdark-v1.1.css")"
  api POST "/wp/v2/global-styles" "{\"version\":2,\"settings\":{},\"styles\":{\"css\":$CSSJSON}}" \
    && echo "  OK: Grimdark CSS v1.1 via global-styles" || FAILS=$((FAILS+1))
fi
sleep "$SLEEP"

echo "== 7/8 Artikler 1-5 (status: $STATUS_DRAFT) =="
for f in "$HERE"/payloads/articles/*.json; do
  slug="$(jq -r '.slug' "$f")"; title="$(jq -r '.title' "$f")"
  id="$(get_id_by_slug posts "$slug")"
  if [ -n "$id" ]; then echo "  OK: artikel '$title' (findes, id $id)"; continue; fi
  cats=""; first=1
  for name in $(jq -r '.categories[]' "$f"); do
    cid="$(grep -F "$name=" "$MAP" | head -1 | cut -d= -f2)"
    [ -n "$cid" ] && { [ $first = 1 ] && cats="$cid" || cats="$cats,$cid"; first=0; }
  done
  body="$(cat "$f" | jq -c '. + {status:"'$STATUS_DRAFT'"} + {categories:['"${cats:-0}"']}' )"
  api POST "/wp/v2/posts" "$body" \
    && echo "  OK: artikel '$title' → id $(jq -r '.id' "$HERE/lib/last.json") (cats: ${cats:-none})" || FAILS=$((FAILS+1))
  sleep "$SLEEP"
done

echo "== 8/8 Verifikation =="
api GET "/wp/v2/posts?status=$STATUS_DRAFT&per_page=20&orderby=modified" >/dev/null 2>&1 \
  && echo "  Posts ($STATUS_DRAFT): $(jq -r 'map(.slug)|join(", ")' "$HERE/lib/last.json" 2>/dev/null)"
api GET "/wp/v2/pages?status=$STATUS_DRAFT&per_page=20" >/dev/null 2>&1 \
  && echo "  Pages ($STATUS_DRAFT): $(jq -r 'map(.slug)|join(", ")' "$HERE/lib/last.json" 2>/dev/null)"
api GET "/wp/v2/settings" >/dev/null 2>&1 \
  && echo "  Settings: lang=$(jq -r '.language' "$HERE/lib/last.json") tz=$(jq -r '.timezone' "$HERE/lib/last.json") front=$(jq -r '.show_on_front' "$HERE/lib/last.json")"
api GET "/wp/v2/themes?status=active" >/dev/null 2>&1 \
  && echo "  Tema: $(jq -r '.[0].stylesheet' "$HERE/lib/last.json")"

echo ""
[ $FAILS = 0 ] && echo "✅ GRIMDARK-PAKKEN KØRT — 0 fejl. Artikler ligger som drafts." \
              || echo "⚠️ FÆRDIG MED $FAILS FEJL — se ovenfor."
