import os
from pathlib import Path
from moviepy.editor import (
    AudioFileClip,
    ImageClip,
    CompositeVideoClip,
    TextClip,
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
image_clip = (
    ImageClip(image_path)
    .set_duration(audio.duration)
    .set_audio(audio)
    .resize(height=720)
    .set_position("center")
)

final_size = image_clip.size

# ✅ Altyazı (taşmaz, dinamik boyutlu)
if os.path.exists(subtitle_path):
    try:
        video_height = final_size[1]
        dynamic_fontsize = int(video_height * 0.05)  # Yüksekliğin %5'i

        def generator(txt):
            return TextClip(
                txt,
                font="DejaVu-Sans",
                fontsize=dynamic_fontsize,
                color="white",
                stroke_color="black",
                stroke_width=2,
                method="caption",
                size=(final_size[0] * 0.9, None),
            )

        subtitles = SubtitlesClip(subtitle_path, generator)
        video = CompositeVideoClip(
            [image_clip, subtitles.set_position(("center", "bottom"))],
            size=final_size
        )
    except Exception as e:
        print(f"⚠️ Altyazı yüklenemedi: {e}")
        video = image_clip
else:
    video = image_clip

# 🎞️ Video üret
video.write_videofile(output_path, fps=24)
print(f"🎬 Video oluşturuldu: {output_path}")

# 📤 Git Push
if os.path.exists(PUSH_SCRIPT_PATH):
    try:
        subprocess.run(["bash", PUSH_SCRIPT_PATH], check=True)
        print("✅ GitHub'a otomatik gönderildi.")
    except subprocess.CalledProcessError as e:
        print(f"❌ GitHub push başarısız: {e}")
else:
    print("❌ GitHub push scripti bulunamadı:", PUSH_SCRIPT_PATH)
