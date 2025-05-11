#!/usr/bin/env bash

# Dizinleri oluştur
mkdir -p "$HOME/yankidusunce-core/scripts"
mkdir -p "$HOME/yankidusunce-core/logs"
mkdir -p "$HOME/yankidusunce-core/data/input_audio"
mkdir -p "$HOME/yankidusunce-core/data/output_text"
mkdir -p "$HOME/.config/systemd/user"

# whisper_auto.sh içeriğini oluştur
cat << 'EOF' > "$HOME/yankidusunce-core/scripts/whisper_auto.sh"
#!/usr/bin/env bash

INPUT_DIR="$HOME/yankidusunce-core/data/input_audio"
OUTPUT_DIR="$HOME/yankidusunce-core/data/output_text"
LOG_FILE="$HOME/yankidusunce-core/logs/whisper_auto.log"
MODEL="base"
LANGUAGE="Turkish"

mkdir -p "$INPUT_DIR" "$OUTPUT_DIR" "$(dirname $LOG_FILE)"

process_file() {
    local filepath="$1"
    local filename="$(basename -- "$filepath")"
    echo "\n[$(date)] Başlıyor: $filename" | tee -a "$LOG_FILE"
    whisper "$filepath" --language "$LANGUAGE" --model "$MODEL" --output_dir "$OUTPUT_DIR" >> "$LOG_FILE" 2>&1
    echo "[$(date)] Tamamlandı: $filename" | tee -a "$LOG_FILE"
}

inotifywait -m -e close_write --format "%w%f" "$INPUT_DIR" |
while read NEWFILE; do
    [[ "$NEWFILE" =~ \.(mp3|wav|m4a|flac)$ ]] && process_file "$NEWFILE"
done
EOF

chmod +x "$HOME/yankidusunce-core/scripts/whisper_auto.sh"

# Systemd servis dosyasını oluştur
cat << EOF > "$HOME/.config/systemd/user/auto_whisper.service"
[Unit]
Description=Yankı Whisper Otomasyon Servisi
After=default.target

[Service]
ExecStart=$HOME/yankidusunce-core/scripts/whisper_auto.sh
Restart=on-failure

[Install]
WantedBy=default.target
EOF

# Systemd ile servis kontrolü
systemctl --user daemon-reexec
systemctl --user daemon-reload
systemctl --user enable auto_whisper.service
systemctl --user start auto_whisper.service

# Durumu göster
systemctl --user status auto_whisper.service
