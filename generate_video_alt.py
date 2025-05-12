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

INPUT_AUDIO_DIR = "data/input_audio"
INPUT_IMAGE_DIR = "data/input_images"
SUBTITLE_DIR = "data/subtitles"
OUTPUT_DIR = "data/video_output"

def process_scene(scene_id):
    audio_path = os.path.join(INPUT_AUDIO_DIR, f"{scene_id}.wav")
    image_path = os.path.join(INPUT_IMAGE_DIR, f"{scene_id}.png")
    subtitle_path = os.path.join(SUBTITLE_DIR, f"{scene_id}.srt")
    output_path = os.path.join(OUTPUT_DIR, f"{scene_id}.mp4")

    print(f"🎬 İşleniyor: {scene_id}")

    if not os.path.exists(audio_path):
        print(f"⛔ Ses dosyası bulunamadı: {audio_path}")
        return

    if not os.path.exists(image_path):
        print(f"⛔ Görsel dosyası bulunamadı: {image_path}")
        return

    # Ses ve görsel yükle
    audio = AudioFileClip(audio_path)
    image = ImageClip(image_path).set_duration(audio.duration).set_fps(24).resize(height=1080)

    clips = [image.set_audio(audio)]

    # Altyazı varsa ekle
    if os.path.exists(subtitle_path):
        generator = lambda txt: TextClip(txt, font="DejaVu-Sans", fontsize=40, color="white")
        subtitle = SubtitlesClip(subtitle_path, generator).set_position(("center", "bottom"))
        clips.append(subtitle)

    final = CompositeVideoClip(clips)
    final.write_videofile(output_path, fps=30, codec="libx264", audio_codec="aac")

def main():
    Path(OUTPUT_DIR).mkdir(parents=True, exist_ok=True)
    audio_files = sorted([f for f in os.listdir(INPUT_AUDIO_DIR) if f.endswith(".wav")])
    for f in audio_files:
        scene_id = Path(f).stem
        process_scene(scene_id)

if __name__ == "__main__":
    main()
