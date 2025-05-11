#!/usr/bin/env bash

### 📌 Ayarlar (YAML'den çekilecek yerler)
CONFIG_FILE="$HOME/yankidusunce-core/config/whisper_config.yaml"

# YAML dosyasından değerleri oku
INPUT_DIR=$(grep input_dir "$CONFIG_FILE" | awk '{print $2}')
OUTPUT_DIR=$(grep output_dir "$CONFIG_FILE" | awk '{print $2}')
LOG_FILE=$(grep log_file "$CONFIG_FILE" | awk '{print $2}')
MODEL=$(grep model "$CONFIG_FILE" | awk '{print $2}')
LANGUAGE=$(grep language "$CONFIG_FILE" | awk '{print $2}')

### ✅ Komut Kontrolleri
command -v whisper >/dev/null 2>&1 || {
  echo "❌ HATA: 'whisper' komutu bulunamadı. PYENV ortamında mı çalışıyorsun?" >&2
  exit 1
}

command -v inotifywait >/dev/null 2>&1 || {
  echo "❌ HATA: 'inotifywait' yüklü değil. Kurmak için: sudo pacman -S inotify-tools" >&2
  exit 1
}

### 📁 Dizin Kontrolleri ve Oluşturma
[[ ! -d "$INPUT_DIR" ]] && echo "📁 Oluşturuluyor: $INPUT_DIR" && mkdir -p "$INPUT_DIR"
[[ ! -d "$OUTPUT_DIR" ]] && echo "📁 Oluşturuluyor: $OUTPUT_DIR" && mkdir -p "$OUTPUT_DIR"
[[ ! -f "$LOG_FILE" ]] && echo "📄 Oluşturuluyor: $LOG_FILE" && mkdir -p "$(dirname "$LOG_FILE")" && touch "$LOG_FILE"

### 🔒 İzin Ayarları
chmod 700 "$INPUT_DIR" "$OUTPUT_DIR"
chmod 644 "$LOG_FILE"

### 🛠 İşlem Fonksiyonu
process_file() {
  local filepath="$1"
  local filename="$(basename -- "$filepath")"
  echo -e "\n[$(date)] Başlıyor: $filename" | tee -a "$LOG_FILE"
  whisper "$filepath" --language "$LANGUAGE" --model "$MODEL" --output_dir "$OUTPUT_DIR" >> "$LOG_FILE" 2>&1
  echo "[$(date)] Tamamlandı: $filename" | tee -a "$LOG_FILE"

  # 🔄 GitHub push işlemi
  "$HOME/yankidusunce-core/github/auto_git_push.sh" >> "$LOG_FILE" 2>&1
}

### 🔄 Dinleme Döngüsü
echo "📡 Dinleniyor: $INPUT_DIR"
inotifywait -m -e close_write --format "%w%f" "$INPUT_DIR" | while read -r NEWFILE; do
  if [[ "$NEWFILE" =~ \.(mp3|wav|m4a|flac)$ ]]; then
    process_file "$NEWFILE"
  fi
done
