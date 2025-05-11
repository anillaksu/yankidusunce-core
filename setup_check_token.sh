#!/bin/bash

WORKFLOW_DIR=".github/workflows"
WORKFLOW_FILE="$WORKFLOW_DIR/check_token.yml"

echo "🔍 Dosya yapısı kontrol ediliyor..."

# 1. Klasörleri oluştur
if [ ! -d "$WORKFLOW_DIR" ]; then
  echo "📁 $WORKFLOW_DIR dizini oluşturuluyor..."
  mkdir -p "$WORKFLOW_DIR"
else
  echo "✅ $WORKFLOW_DIR zaten mevcut."
fi

# 2. Eski dosya varsa sil ve sıfırla
if [ -f "$WORKFLOW_FILE" ]; then
  echo "🧹 Önceki check_token.yml dosyası temizleniyor..."
  > "$WORKFLOW_FILE"
else
  echo "📄 check_token.yml dosyası oluşturulacak."
fi

# 3. İçeriği yaz
cat <<EOF > "$WORKFLOW_FILE"
name: 🔐 Telegram Bot Token Health Check

on:
  push:
    branches:
      - main  # Ana dalda her push'ta çalışır
  workflow_dispatch:  # İstenirse manuel olarak da çalıştırılabilir

jobs:
  check-token-health:
    runs-on: ubuntu-latest  # GitHub'un sağladığı Ubuntu ortamı

    steps:
      - name: 🧱 Repo'yu klonla
        uses: actions/checkout@v3

      - name: 🐍 Python kurulumunu yap
        uses: actions/setup-python@v4
        with:
          python-version: '3.10'

      - name: 📦 Gereken bağımlılıkları yükle
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt

      - name: ✅ Bot Sağlık Kontrolünü Başlat
        env:
          TELEGRAM_BOT_TOKEN: \${{ secrets.TELEGRAM_BOT_TOKEN }}
        run: |
          echo ">>> Bot sağlık kontrolü başlatılıyor..."
          python scripts/bot_health_check.py
EOF

echo "✅ check_token.yml başarıyla oluşturuldu."

# 4. İzin kontrolü
echo "🔐 Yazma izni kontrolü yapılıyor..."
if [ -w "$WORKFLOW_FILE" ]; then
  echo "✅ Dosya yazılabilir durumda."
else
  echo "❌ Uyarı: $WORKFLOW_FILE yazılamıyor. İzinleri kontrol et!"
fi

# 5. Dosyayı nano ile açmak istersen
read -p "📝 Dosyayı nano ile açmak ister misin? (e/h): " yanit
if [[ "$yanit" =~ ^[eEyY]$ ]]; then
  nano "$WORKFLOW_FILE"
else
  echo "🚀 Hazırsan push et, kontrol başlasın."
fi
