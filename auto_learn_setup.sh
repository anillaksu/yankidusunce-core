#!/bin/bash

echo "🔧 Echo Agent Gelişmiş Öğrenme Kurulumu Başlatılıyor..."

# Gerekli modüller
pip install --break-system-packages nltk openai pyttsx3

# NLTK modelleri
python3 -c "import nltk; nltk.download('punkt'); nltk.download('wordnet')"

# config klasörü ve json dosyası oluştur
mkdir -p config
echo '{"memory":[]}' > config/learned_memory.json

echo "✅ Kurulum tamamlandı. Agent artık öğrenmeye hazır!"
