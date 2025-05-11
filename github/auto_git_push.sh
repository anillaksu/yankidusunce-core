#!/usr/bin/env bash

cd "$HOME/yankidusunce-core" || exit 1

echo "🌀 Değişiklikler kontrol ediliyor..."
git add .
git commit -m "🧠 Otomatik push: $(date '+%Y-%m-%d %H:%M:%S')" || echo "🔎 Yeni commit yok."
git push origin main && echo "✅ GitHub senkron tamamlandı." || echo "❌ GitHub push başarısız."
