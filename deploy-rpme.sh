#!/usr/bin/env bash
# Deploy RPME. The ROOT files are the single source of truth:
#   Fitness/index.html, manifest.json, sw.js
# /rpg/ is just a redirect now — don't edit it.
#
# Workflow: edit index.html (or copy a new build over it), then run:
#   ./deploy-rpme.sh "what changed"
# It bumps the service-worker cache so installed PWAs pick up the change,
# commits, and pushes (GitHub Pages auto-deploys from main).
set -e
cd "$(dirname "$0")"

cur=$(grep -oE "rpme-v[0-9]+" sw.js | head -1)
if [ -z "$cur" ]; then echo "no rpme-vN cache found in sw.js"; exit 1; fi
n=${cur#rpme-v}
next="rpme-v$((n + 1))"
sed -i "s/rpme-v${n}\b/${next}/g" sw.js
echo "service-worker cache: $cur -> $next"

git add index.html manifest.json sw.js icon-192.png icon-512.png
git commit -m "${1:-RPME deploy} (sw $next)"
git push origin main
echo "Pushed. Live in ~30-90s at https://0unitz.github.io/Workout"
