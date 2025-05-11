#!/bin/bash

REPO_DIR="$HOME/yankidusunce-core"

echo "🚨 Starting BFG Cleanup on: $REPO_DIR"
cd "$REPO_DIR" || { echo "❌ Repo not found at $REPO_DIR"; exit 1; }

# BFG ile geçmişten .env silinir
if ! command -v bfg &> /dev/null; then
    echo "🔧 BFG yüklü değil. Kurulum başlatılıyor..."
    sudo pacman -S bfg --noconfirm || brew install bfg
fi

bfg --delete-files .env

# Git geçmişini temizle
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# Değişiklikleri zorla pushla
git push origin --force

echo "✅ BFG cleanup tamamlandı ve force push atıldı. GitGuardian'ın sesi kesilecek :)"
