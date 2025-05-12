#!/bin/bash

echo ""
echo "🛠️ Yankı Sistemi - Tam Sağlık Kontrolü Başlatılıyor..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# .env kontrolü
echo ""
echo "📂 .env Dosyası:"
if [ -f "/home/anil/yankidusunce-core/.env" ]; then
    echo "✅ .env dosyası mevcut."
else
    echo "❌ .env dosyası YOK!"
fi

# Gerekli Python modülleri
echo ""
echo "🐍 Python Modülleri:"
missing_modules=""
for module in telegram gtts dotenv requests gpt4all; do
    python3 -c "import $module" 2>/dev/null || missing_modules+="$module "
done

if [ -n "$missing_modules" ]; then
    echo "❌ Eksik modüller: $missing_modules"
else
    echo "✅ Tüm gerekli modüller kurulu."
fi

# Gerekli dosyalar
echo ""
echo "📄 Ana Dosya Kontrolü:"
required_files=(
  "echo_agent.py"
  "start_all.sh"
  "scripts/whisper_auto.sh"
  "scripts/system_health_check.sh"
  "scripts/check_whisper_pipeline.sh"
  "scripts/bot_health_check.py"
  "data/persona.txt"
  "data/knowledge_bank.json"
  "data/response_style.json"
)

for file in "${required_files[@]}"; do
  fullpath="/home/anil/yankidusunce-core/$file"
  if [ -f "$fullpath" ]; then
    echo "✅ $file"
  else
    echo "❌ $file eksik!"
  fi
done

# Servis kontrol
echo ""
echo "🧪 Systemd Servis Durumu:"
systemctl --user is-active auto_whisper.service &> /dev/null
if [ $? -eq 0 ]; then
    echo "✅ auto_whisper.service aktif."
else
    echo "❌ auto_whisper.service çalışmıyor!"
fi

echo ""
echo "✅ Kontrol tamamlandı."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
