import os
import logging
from telegram import Update, Voice
from telegram.ext import ApplicationBuilder, ContextTypes, MessageHandler, filters
from dotenv import load_dotenv
from gtts import gTTS
import openai
import uuid

# .env dosyasını yükle
load_dotenv()
BOT_TOKEN = os.getenv("BOT_TOKEN")
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")

# OpenAI ayarı
openai.api_key = OPENAI_API_KEY

# Logging ayarı
logging.basicConfig(
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    level=logging.INFO,
    filename="logs/bot.log"
)

# GPT'den cevap al
async def gpt_reply(message):
    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",  # Değiştirilebilir
        messages=[
            {"role": "user", "content": message}
        ]
    )
    return response["choices"][0]["message"]["content"]

# Mesaj geldiğinde çalışacak fonksiyon
async def handle_message(update: Update, context: ContextTypes.DEFAULT_TYPE):
    user_input = update.message.text
    chat_id = update.message.chat_id
    logging.info(f"Mesaj alındı: {user_input}")

    reply = await gpt_reply(user_input)

    # Yazılı yanıt gönder
    await context.bot.send_message(chat_id=chat_id, text=reply)

    # Sese çevir
    tts = gTTS(text=reply, lang="tr")
    filename = f"voice_{uuid.uuid4()}.mp3"
    tts.save(filename)

    # Sesli yanıt gönder
    with open(filename, 'rb') as audio:
        await context.bot.send_voice(chat_id=chat_id, voice=audio)

    os.remove(filename)

# Botu başlat
if __name__ == '__main__':
    app = ApplicationBuilder().token(BOT_TOKEN).build()
    app.add_handler(MessageHandler(filters.TEXT & (~filters.COMMAND), handle_message))
    print("Bot çalışıyor...")
    app.run_polling()
