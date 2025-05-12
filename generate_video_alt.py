import os
from pathlib import Path
from moviepy.editor import AudioFileClip, ImageClip
from PIL import Image as PILImage
import subprocess

# 📁 Yol ayarları
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
INPUT_AUDIO_DIR = os.path.join(BASE_DIR, "data/input_audio")
INPUT_IMAGE_DIR = os.path.join(BASE_DIR, "data/input_images")
SUBTITLE_DIR = os.path.join(BASE_DIR, "data/subtitles")
TEMP_VIDEO_DIR = os.path.join(BASE_DIR, "data/temp_videos")
OUTPUT_DIR = os.path.join(BASE_DIR, "data/video_output")
PUSH_SCRIPT_PATH = os.path.join(BASE_DIR, "github/auto_git_push.sh")

# 🎬 Sahne ID
scene_id = "sahne1"

audio_path = os.path.join(INPUT_AUDIO_DIR, f"{scene_id}.wav")
image_path = os.path.join(INPUT_IMAGE_DIR, f"{scene_id}.png")
subtitle_path = os.path.join(SUBTITLE_DIR, f"{scene_id}.srt")
temp_output_path = os.path.join(TEMP_VIDEO_DIR, f"{scene_id}_no_sub.mp4")
final_output_path = os.path.join(OUTPUT_DIR, f"{scene_id}.mp4")

# 📂 Gerekli klasörleri oluştur
os.makedirs(TEMP_VIDEO_DIR, exist_ok=True)
os.makedirs(OUTPUT_DIR, exist_ok=True)

# 🎧 Ses dosyasını oku
audio = AudioFileClip(audio_path)

# 🖼️ Görsel boyutlandır
image = PILImage.open(image_path)
image_clip = (
    ImageClip(image_path)
    .set_duration(audio.duration)
    .set_audio(audio)
    .resize(height=720)
    .set_position("center")
)

# 🎥 Geçici altyazısız video oluştur
image_clip.write_videofile(temp_output_path, fps=24)
print(f"🎞️ Geçici video oluşturuldu: {temp_output_path}")

# 📝 Altyazı varsa ffmpeg ile göm
if os.path.exists(subtitle_path):
    print(f"📝 Altyazı ekleniyor: {subtitle_path}")
    cmd = [
        "ffmpeg",
        "-y",
        "-i", temp_output_path,
        "-vf", f"subtitles='{subtitle_path}'",
        "-c:a", "copy",
        final_output_path
    ]
    subprocess.run(cmd, check=True)
else:
    os.rename(temp_output_path, final_output_path)

print(f"✅ Final video: {final_output_path}")

# 📤 Otomatik Git Push
if os.path.exists(PUSH_SCRIPT_PATH):
    try:
        subprocess.run(["bash", PUSH_SCRIPT_PATH], check=True)
        print("✅ GitHub'a otomatik gönderildi.")
    except subprocess.CalledProcessError as e:
        print(f"❌ GitHub push başarısız: {e}")
else:
    print("❌ GitHub push scripti bulunamadı: ", PUSH_SCRIPT_PATH)
