#!/bin/bash

echo "🚀 Yankı Düşünce: Echo Agent kuruluyor..."

# Gerekli paketler
sudo pacman -S --noconfirm python3 git espeak-ng

# Sanal ortam oluştur (virtualenv yüklüyse)
python3 -m venv venv
source venv/bin/activate

# Basit test betiği oluştur
echo 'print("Merhaba Anıl, Echo Agent çalışıyor!")' > echo.py

echo "✅ Kurulum tamamlandı."
echo "Çalıştırmak için: source venv/bin/activate && python echo.py"
