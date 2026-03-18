#!/bin/bash
set -e
cd ~/dev_modo_monstro
git pull origin main --rebase 2>/dev/null || true
git add -A
if ! git diff --cached --quiet; then
  git commit -m "sync: auto $(hostname) $(date '+%Y-%m-%d %H:%M')"
  git push -u origin main || sleep 2 && git push -u origin main
fi
