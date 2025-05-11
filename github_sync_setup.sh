#!/usr/bin/env bash

cd "$HOME/yankidusunce-core" || exit 1

if git status | grep -q "Changes not staged"; then
  git add .
  git commit -m "🔄 Otomatik senkron: $(date '+%Y-%m-%d %H:%M:%S')"
  git push origin main
  echo "✅ GitHub ile senkron tamamlandı."
else
  echo "ℹ️ Değişiklik yok, senkron gerekmiyor."
fi
