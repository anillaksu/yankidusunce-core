#!/usr/bin/env bash

# Yankı Whisper Full Setup - Otomatik Kurulum
set -e

echo "📁 Gerekli dizinler oluşturuluyor..."
mkdir -p ~/yankidusunce-core/{data/input_audio,data/output_text,logs,scripts}
mkdir -p ~/.config/systemd/user

echo "📝 whisper_auto.sh oluşturuluyor..."
cat << 'EOF' > ~/yankidusunce-core/scripts/whisper_auto.sh
#!/usr/bin/env bash

INPUT_DIR="$HOME/yankidusunce-core/data/input_audio"
OUTPUT_DIR="$HOME/yankidusunce-core/data/output_text"
LOG_FILE="$HOME/yankidusunce-core/logs/whisper_auto.log"
MODEL="base"
LANGUAGE="Turkish"

mkdir -p "$INPUT_DIR" "$OUTPUT_DIR" "$(dirname $LOG_FILE)"

process_file() {
    local filepath="$1"
    local filename="\$(basename -- "\$filepath")"
    local name="\${filename%.*}"

    echo "\n[\$(date)] Başlıyor: \$filename" | tee -a "\$LOG_FILE"
    whisper "\$filepath" --language "\$LANGUAGE" --model "\$MODEL" --output_dir "\$OUTPUT_DIR" >> "\$LOG_FILE" 2>&1
    echo "[\$(date)] Tamamlandı: \$filename" | tee -a "\$LOG_FILE"
}

inotifywait -m -e close_write --format "%w%f" "\$INPUT_DIR" |
while read NEWFILE; do
    [[ "\$NEWFILE" =~ \.(mp3|wav|m4a|flac)$ ]] && process_file "\$NEWFILE"
done
EOF

echo "📝 auto_whisper.service oluşturuluyor..."
cat << EOF > ~/.config/systemd/user/auto_whisper.service
[Unit]
Description=Yankı Whisper Otomasyon Servisi
After=default.target

[Service]
ExecStart=/home/$USER/yankidusunce-core/scripts/whisper_auto.sh
Restart=always
RestartSec=5
StandardOutput=append:/home/$USER/yankidusunce-core/logs/whisper_auto.log
StandardError=append:/home/$USER/yankidusunce-core/logs/whisper_auto.log

[Install]
WantedBy=default.target
EOF

echo "🔐 İzinler ayarlanıyor..."
chmod +x ~/yankidusunce-core/scripts/whisper_auto.sh
chmod 644 ~/.config/systemd/user/auto_whisper.service

echo "🧠 systemd servisi etkinleştiriliyor..."
systemctl --user daemon-reexec
systemctl --user daemon-reload
systemctl --user enable --now auto_whisper.service

echo "✅ Kurulum tamamlandı. Servis aktif çalışıyor."
