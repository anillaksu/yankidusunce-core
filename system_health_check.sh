#!/usr/bin/env bash

echo -e "\n🩺 [$(date)] Sistem Sağlık Kontrolü Başlatılıyor...\n"

### 📁 Dizin ve Dosya Kontrolleri
paths=(
  "$HOME/yankidusunce-core/scripts/whisper_auto.sh"
  "$HOME/yankidusunce-core/github/auto_git_push.sh"
  "$HOME/yankidusunce-core/config/whisper_config.yaml"
  "$HOME/yankidusunce-core/data/input_audio"
  "$HOME/yankidusunce-core/data/output_text"
  "$HOME/yankidusunce-core/logs"
)

for path in "${paths[@]}"; do
  if [[ -d "$path" ]]; then
    echo "✅ Dizin mevcut: $path"
  elif [[ -f "$path" ]]; then
    echo "✅ Dosya mevcut: $path"
  else
    echo "❌ Eksik: $path"
  fi
done

### 🔒 İzin Kontrolleri
check_permission() {
  [[ -x "$1" ]] && echo "🔓 Çalıştırılabilir: $1" || echo "🔐 Eksik İzin: $1 (chmod +x ile düzelt)"
}
check_permission "$HOME/yankidusunce-core/scripts/whisper_auto.sh"
check_permission "$HOME/yankidusunce-core/github/auto_git_push.sh"

### ⚙ Servis Kontrolü
echo -e "\n🔁 Systemd Servis Durumu:"
systemctl --user is-active auto_whisper.service &>/dev/null && \
echo "✅ Aktif: auto_whisper.service" || \
echo "❌ PASİF: auto_whisper.service (Muhtemelen restart gerekiyor)"

### 📦 whisper & inotifywait Komutları
for cmd in whisper inotifywait; do
  command -v "$cmd" &>/dev/null && echo "✅ Komut mevcut: $cmd" || echo "❌ Komut eksik: $cmd"
done

echo -e "\n🧩 Sistem Sağlık Kontrolü Tamamlandı.\n"
