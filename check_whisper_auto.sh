echo "🧠 Kontroller başlatılıyor..."

# 1. Dosya var mı?
[[ -f ~/yankidusunce-core/scripts/whisper_auto.sh ]] && echo "✅ whisper_auto.sh dosyası bulundu." || echo "❌ whisper_auto.sh dosyası eksik."

# 2. İzin kontrolü
[[ -x ~/yankidusunce-core/scripts/whisper_auto.sh ]] && echo "✅ Çalıştırma izni var." || echo "❌ Çalıştırma izni eksik! chmod +x ile düzelt."

# 3. Gerekli klasörler
for dir in ~/yankidusunce-core/data/input_audio ~/yankidusunce-core/data/output_text ~/yankidusunce-core/logs; do
  [[ -d "$dir" ]] && echo "✅ Dizin mevcut: $dir" || echo "❌ Dizin eksik: $dir"
done

# 4. Log dosyası
[[ -f ~/yankidusunce-core/logs/whisper_auto.log ]] && echo "✅ Log dosyası mevcut." || echo "❌ Log dosyası eksik."

# 5. Config dosyası
[[ -f ~/yankidusunce-core/config/whisper_config.yaml ]] && echo "✅ Config dosyası mevcut." || echo "❌ Config dosyası eksik."

# 6. whisper komutu
command -v whisper >/dev/null && echo "✅ whisper komutu bulundu." || echo "❌ whisper komutu bulunamadı."

# 7. inotifywait komutu
command -v inotifywait >/dev/null && echo "✅ inotifywait komutu bulundu." || echo "❌ inotifywait eksik (sudo pacman -S inotify-tools)"

echo "🧩 Kontrol tamamlandı."
