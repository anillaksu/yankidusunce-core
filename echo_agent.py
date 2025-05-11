import os
import logging
import uuid
import json
import time
import threading
from telegram import Update
from telegram.ext import ApplicationBuilder, ContextTypes, MessageHandler, filters
from dotenv import load_dotenv
from gtts import gTTS
from gpt4all import GPT4All

# Ortam değişkenleri
load_dotenv()
BOT_TOKEN = os.getenv("BOT_TOKEN")

# Modeli yükle
model = GPT4All("mistral-7b-instruct-v0.2.Q4_K_M.gguf")

# Logging
logging.basicConfig(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
                    level=logging.INFO,
                    filename="logs/bot.log")

# JSON veri okuma
def load_json_data(path):
    try:
        with open(path, "r", encoding="utf-8") as f:
            return json.load(f)
    except Exception as e:
        print(f"❌ {path} okunamadı: {e}")
        return {}

# Veri setleri
persona = open("data/persona.txt", "r", encoding="utf-8").read()
knowledge_bank = load_json_data("data/knowledge_bank.json")
response_style = load_json_data("data/response_style.json")

# GPT yanıtı
async def gpt_reply(message):
    output = model.generate(prompt=message, max_tokens=200, temp=0.7, top_k=40)
    return output.strip()

# Telegram mesajı yakala
async def handle_message(update: Update, context: ContextTypes.DEFAULT_TYPE):
    user_input = update.message.text
    chat_id = update.message.chat_id
    logging.info(f"Mesaj: {user_input}")

    prompt = f"""
Sen Anıl’ın kişisel yapay zekâ yardımcısısın. Kişilik Özellikleri:
{persona}

Bilgi bankası:
{json.dumps(knowledge_bank, indent=2, ensure_ascii=False)}

Anıl şunu sordu:
{user_input}

Eğer cevap bilgi bankanda yoksa, şu şablonu kullan:
{response_style.get("bilgi_yoksa", ["Bu konuda bilgim yok."])[0]}
"""
    reply = await gpt_reply(prompt)
    await context.bot.send_message(chat_id=chat_id, text=reply)

    tts = gTTS(text=reply, lang="tr", tld="com.tr")
    filename = f"voice_{uuid.uuid4()}.mp3"
    tts.save(filename)
    with open(filename, 'rb') as audio:
        await context.bot.send_voice(chat_id=chat_id, voice=audio)
    os.remove(filename)

# commands.json takipçisi
def monitor_commands():
    last_command = None
    while True:
        try:
            with open("commands.json", "r", encoding="utf-8") as f:
                data = json.load(f)
                cmd = data.get("command")
                if cmd and cmd != last_command:
                    print(f"\n🛰️ Komut geldi: {cmd}")
                    reply = model.generate(prompt=cmd, max_tokens=200)
                    print(f"🤖 Yanıt: {reply.strip()}\n")
                    last_command = cmd
        except Exception as e:
            print(f"Hata: {e}")
        time.sleep(5)

# Botu başlat
if __name__ == '__main__':
    app = ApplicationBuilder().token(BOT_TOKEN).build()
    app.add_handler(MessageHandler(filters.TEXT & (~filters.COMMAND), handle_message))
    threading.Thread(target=monitor_commands, daemon=True).start()
    print("🟢 Echo Agent aktif. Telegram ve komut dinleme başlatıldı.")
    app.run_polling()
