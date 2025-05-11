import os
import requests
import datetime
import sys

# 🔧 Log klasörü
LOG_DIR = "logs"
LOG_FILE = os.path.join(LOG_DIR, "bot_health_check.log")

# ⏰ Zaman damgası
now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

# 🛠️ Log klasörü yoksa oluştur
if not os.path.exists(LOG_DIR):
    os.makedirs(LOG_DIR)

def log(message, level="INFO"):
    formatted = f"[{now}] [{level}] {message}"
    print(formatted)
    with open(LOG_FILE, "a") as f:
        f.write(formatted + "\n")

# 🔐 Token kontrolü
token = os.getenv("TELEGRAM_BOT_TOKEN")
if not token:
    log("TELEGRAM_BOT_TOKEN çevresel değişkeni bulunamadı.", "ERROR")
    sys.exit(1)

url = f"https://api.telegram.org/bot{token}/getMe"

try:
    response = requests.get(url, timeout=10)
    data = response.json()

    if response.status_code == 200 and data.get("ok"):
        bot_info = data.get("result", {})
        bot_name = bot_info.get("username", "unknown")
        log(f"✅ Bot aktif. Kullanıcı adı: @{bot_name}")
        sys.exit(0)
    else:
        log(f"❌ Token geçersiz veya bağlantı reddedildi. Yanıt: {data}", "ERROR")
        sys.exit(1)

except requests.exceptions.RequestException as e:
    log(f"🔌 Hata oluştu: {str(e)}", "ERROR")
    sys.exit(1)
