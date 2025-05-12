#!/usr/bin/env bash

cd "$(dirname "$0")" || exit 1

echo "🎬 Video üretimi başlatılıyor..."

python3 generate_video_alt.py

echo "📤 Video üretimi tamamlandı, GitHub'a push atılıyor..."

bash github/auto_git_push.sh
