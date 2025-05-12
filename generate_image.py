import os
import json
import sys
from PIL import Image
from io import BytesIO
import requests

# Sahne ID dışarıdan alınır
scene_id = sys.argv[1] if len(sys.argv) > 1 else "sahne1"

# 📁 Yol tanımları
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
IMAGE_DIR = os.path.join(BASE_DIR, "data/input_images")
SCENE_JSON = os.path.join(BASE_DIR, "scene_list.json")

# Dosyayı oluşturulmamışsa yarat
os.makedirs(IMAGE_DIR, exist_ok=True)

# Hedef dosya zaten varsa işlemi atla
output_path = os.path.join(IMAGE_DIR, f"{scene_id}.png")
if os.path.exists(output_path):
    print(f"🖼️ Görsel zaten var: {output_path}")
    sys.exit(0)

# JSON'dan prompt çek
with open(SCENE_JSON, "r", encoding="utf-8") as f:
    scenes = json.load(f)

prompt = next((s["prompt"] for s in scenes if s["id"] == scene_id), None)

if not prompt:
    print(f"❌ Prompt bulunamadı: {scene_id}")
    sys.exit(1)

print(f"🎨 Prompt: {prompt}")

# Görsel üret (OpenAI DALL·E API örneği - yerine kendi modelini koyabilirsin)
API_KEY = os.getenv("OPENAI_API_KEY")
headers = {
    "Authorization": f"Bearer {API_KEY}",
    "Content-Type": "application/json"
}
payload = {
    "prompt": prompt,
    "n": 1,
    "size": "512x512"
}

response = requests.post("https://api.openai.com/v1/images/generations", headers=headers, json=payload)

if response.status_code != 200:
    print("❌ Görsel üretimi başarısız:", response.text)
    sys.exit(1)

image_url = response.json()["data"][0]["url"]
image_data = requests.get(image_url).content
image = Image.open(BytesIO(image_data))
image.save(output_path)

print(f"✅ Görsel kaydedildi: {output_path}")
