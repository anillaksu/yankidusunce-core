import os
from pathlib import Path
from moviepy.editor import (
    AudioFileClip,
    ImageClip,
    CompositeVideoClip,
    TextClip,
    concatenate_videoclips,
)
from moviepy.video.tools.subtitles import SubtitlesClip
from PIL import Image as PILImage
import subprocess

# 📁 Yol ayarları
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
INPUT_AUDIO_DIR = os.path.join(BASE_DIR, "data/input_audio")
INPUT_IMAGE_DIR = os.path.join(BASE_DIR, "data/input_images")
SUBTITLE_DIR = os.path.join(BASE_DIR, "data/subtitles")
OUTPUT_DIR = os.path.join(BASE_DIR, "data/video_output")
PUSH_SCRIPT_PATH = os.path.join(BASE_DIR, "github/auto_git_push.sh")

# 🎬 Sahne ID
scene_id = "sahne1"

audio_path = os.path.join(INPUT_AUDIO_DIR, f"{scene_id}.wav")
image_path = os.path.join(INPUT_IMAGE_DIR, f"{scene_id}.png")
subtitle_path = os.path.join(SUBTITLE_DIR, f"{scene_id}.srt")
output_path = os.path.join(OUTPUT_DIR, f"{scene_id}.mp4")

# ✅ Ses
audio = AudioFileClip(audio_path)

# ✅ Görsel
image = PILImage.open(image_path)
width, height = image.size
image_clip = ImageClip(image_path, duration=audio.duration).set_audio(audio).resize((width, height))

# ✅ Altyazı (varsa)
if os.path.exists(subtitle_path):
    try:
        generator = lambda txt: TextClip(txt, font="DejaVu-Sans", fontsize=32, color="white")
        subtitles = SubtitlesClip(subtitle_path, generator)
        video = CompositeVideoClip([image_clip, subtitles.set_position(("center", "bottom"))])
    except Exception as e:
        print(f"⚠️ Altyazı yüklenemedi: {e}")
        video = image_clip
else:
    video = image_clip

# ✅ Video çıkışı
video.write_videofile(output_path, fps=24)
print(f"🎬 Video oluşturuldu: {output_path}")

# 📤 Git push scriptini çalıştır
if os.path.exists(PUSH_SCRIPT_PATH):
    try:
        subprocess.run(["bash", PUSH_SCRIPT_PATH], check=True)
        print("✅ GitHub'a otomatik gönderildi.")
    except subprocess.CalledProcessError as e:
        print(f"❌ GitHub push başarısız: {e}")
else:
    print("❌ GitHub push scripti bulunamadı:", PUSH_SCRIPT_PATH)
