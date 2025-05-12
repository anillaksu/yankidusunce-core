#!/bin/bash

BASE_DIR="$HOME/yankidusunce-core"
SCENE_FILE="$BASE_DIR/scene_list.json"

echo "🔁 JSON sahne listesi yükleniyor..."

if [ ! -f "$SCENE_FILE" ]; then
  echo "❌ scene_list.json bulunamadı: $SCENE_FILE"
  exit 1
fi

SCENES=$(jq -r '.[]' "$SCENE_FILE")

for SCENE_ID in $SCENES; do
  echo ""
  echo "🎬 İşleniyor: $SCENE_ID"
  python "$BASE_DIR/generate_video_alt.py" "$SCENE_ID"
  echo "✅ Tamamlandı: $SCENE_ID"
done

echo ""
echo "🎉 Tüm sahneler tamamlandı."
