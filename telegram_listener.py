# ~/yankidusunce-core/telegram_listener.py

import os
import json
import logging
from telegram.ext import ApplicationBuilder, MessageHandler, filters

# Bot tokenı .env dosyasından al
from dotenv import load_dotenv
load_dotenv(dotenv_path=os.path.expanduser("~/yankidusunce-core/.env"))
BOT_TOKEN = os.getenv("BOT_TOKEN")

COMMANDS_JSON_PATH = "/mnt/yikimin_sesi_projecti/commands.json"

logging.basicConfig(
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    level=logging.INFO
)

async def handle_message(update, context):
    message = update.message.text.strip().lower()

    if "tezin sesi" in message:
        proje_adi = "001_tezin_sesi"
        await update.message.reply_text(f"📦 Komut alındı: {proje_adi}")
        update_json(proje_adi)
    else:
        await update.message.reply_text("❌ Anlaşılamadı. Örnek: 'Tezin sesi' yaz.")

def update_json(proje_adi):
    try:
        if os.path.exists(COMMANDS_JSON_PATH):
            with open(COMMANDS_JSON_PATH, "r") as f:
                data = json.load(f)
        else:
            data = []

        if not any(cmd["proje_adi"] == proje_adi and not cmd["islenmis"] for cmd in data):
            data.append({"proje_adi": proje_adi, "islenmis": False})
            with open(COMMANDS_JSON_PATH, "w") as f:
                json.dump(data, f, indent=2)
    except Exception as e:
        print(f"🚨 JSON güncelleme hatası: {e}")

if __name__ == "__main__":
    app = ApplicationBuilder().token(BOT_TOKEN).build()
    app.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, handle_message))
    print("🤖 Telegram bot başlatıldı...")
    app.run_polling()
