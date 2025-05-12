#!/usr/bin/env bash

cd "$(dirname "$0")/.." || exit 1

source .env

LOG_DIR="./logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/push.log"

echo "[$(date)] 🔁 Push işlemi başlıyor..." >> "$LOG_FILE"

git config --global user.name "$GIT_USER"
git config --global user.email "$GIT_EMAIL"

CHANGES=$(git status --porcelain)

if [ -z "$CHANGES" ]; then
    echo "[$(date)] ⏭️  Değişiklik yok, çıkılıyor." >> "$LOG_FILE"
    exit 0
fi

echo "[$(date)] 🌀 Değişiklikler ekleniyor..." >> "$LOG_FILE"
git add .

echo "[$(date)] 🧠 Commit atılıyor..." >> "$LOG_FILE"
git commit -m "🧠 Otomatik push: $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE" 2>&1

echo "[$(date)] 🚀 Push gönderiliyor..." >> "$LOG_FILE"
git push "$REPO_URL" "$BRANCH" >> "$LOG_FILE" 2>&1 && \
echo "[$(date)] ✅ GitHub push tamamlandı." >> "$LOG_FILE" || \
echo "[$(date)] ❌ Push sırasında hata oluştu." >> "$LOG_FILE"
