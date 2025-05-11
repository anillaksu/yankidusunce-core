
# Yankı Düşünce - Core

🎙️ Yapay zeka destekli sesli içerik üretim ve kontrol sistemi.  
Bu repo; Telegram bot kontrolü, TTS (Text-to-Speech) altyapısı, sistem sağlık kontrolleri ve otomatik loglama işlevlerini içerir.

---

## 📁 Dizin Yapısı

```
yankidusunce-core/
├── scripts/                 # Tüm script dosyaları burada
│   ├── bot_health_check.py
│   └── whisper_auto.sh
├── config/                  # Yapılandırma dosyaları
├── data/                    # Girdi / çıktı veri klasörü
├── .env                     # Gizli anahtarlar burada tanımlanır
├── .github/workflows/       # GitHub Actions workflow
│   └── check_token.yml
└── README.md
```

---

## 🔐 .env Dosyası

Ana dizine `.env` dosyası koyman gerekiyor. Örnek içerik:

```env
TELEGRAM_BOT_TOKEN=81499xxxxx:xxxxx
```

---

## ✅ Telegram Bot Sağlık Kontrolü

📄 `bot_health_check.py` dosyası `scripts/` dizinindedir.  
Çalıştırmak için:

```bash
cd yankidusunce-core
python scripts/bot_health_check.py
```

> Başarılıysa: `✅ Token is valid. Bot is alive.`  
> Aksi halde hata mesajı verir ve çıkış kodu 1 olur.

---

## ⚙️ GitHub Actions

Her push işleminde `check_token.yml` dosyası tetiklenir ve `bot_health_check.py` otomatik olarak çalıştırılır.

---

## 🛠 Geliştirme Aşamaları

- [x] `.env` desteği eklendi
- [x] Token doğrulama sistemi kuruldu
- [x] GitHub Actions üzerinden otomatik test sağlandı
- [ ] Loglama çıktısı JSON formatına alınacak
- [ ] Telegram üzerinden hata bildirimi entegre edilecek

---

💡 Her push işleminde sistemin sağlığını otomatik test etmek için tasarlanmıştır.  
🔐 Tokenlar `GitHub Secrets` üzerinden güvenle aktarılır.
