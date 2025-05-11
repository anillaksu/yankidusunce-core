#!/usr/bin/env bash

CONFIG="$HOME/yankidusunce-core/config/whisper_config.yaml"
INPUT_DIR=$(grep input_dir "$CONFIG" | awk '{print $2}')
OUTPUT_DIR=$(grep output_dir "$CONFIG" | awk '{print $2}')
LOG_FILE=$(grep log_file "$CONFIG" | awk '{print $2}')
TEST_FILE="$INPUT_DIR/test_whisper_pipeline.wav"
TRANSCRIPT_FILE="$OUTPUT_DIR/test_whisper_pipeline.txt"

echo "🔍 Kontrol başlatıldı: $(date)"

# 🔁 1. Dummy ses dosyası oluştur
echo "▶ Sahte ses dosyası oluşturuluyor: $TEST_FILE"
ffmpeg -f lavfi -i "sine=frequency=1000:duration=2" -ar 16000 -ac 1 "$TEST_FILE" -y -loglevel quiet

# ⏱ 2. Whisper'ın dosyayı işlemesini bekle
echo "⏳  Whisper'ın işlemesi için bekleniyor..."
TIMEOUT=20
while [[ ! -f "$TRANSCRIPT_FILE" && $TIMEOUT -gt 0 ]]; do
  sleep 1
  TIMEOUT=$((TIMEOUT - 1))
done

# ✅ 3. Transkript kontrolü
if [[ -f "$TRANSCRIPT_FILE" ]]; then
  echo "✅ Transkript oluşturuldu: $TRANSCRIPT_FILE"
else
  echo "❌ HATA: Transkript oluşturulamadı." >&2
  exit 1
fi

# 📄 4. Log kontrolü
echo "📄 Log kontrolü:"
grep "test_whisper_pipeline.wav" "$LOG_FILE" | tail -n 5 || echo "❌ HATA: Log dosyasına yazılmamış olabilir."

# 🔄 5. Git işlemi kontrolü
echo "🔁 Git kontrolü:"
cd "$HOME/yankidusunce-core"
git status --short
git log -1 --pretty=format:"🧾 Son commit: %h %s (%cr)"

echo "✅ Pipeline testi tamamlandı."
