import os
from moviepy.editor import (
    AudioFileClip,
    ImageClip,
    CompositeVideoClip,
    concatenate_videoclips
)
from moviepy.video.tools.subtitles import SubtitlesClip
from pathlib import Path

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
INPUT_AUDIO_DIR = os.path.join(BASE_DIR, "data", "input_audio")
INPUT_IMAGE_DIR = os.path.join(BASE_DIR, "data", "input_images")
SUBTITLE_DIR = os.path.join(BASE_DIR, "data", "subtitles")
OUTPUT_DIR = os.path.join(BASE_DIR, "data", "video_output")

def make_subtitle_clip(sub_path, duration):
    if not os.path.exists(sub_path):
        return None
    generator = lambda txt: TextClip(txt, font='DejaVu-Sans', fontsize=40, color='white')
    return SubtitlesClip(sub_path, generator).set_duration(duration)

def process_scene(scene_id):
    audio_path = os.path.join(INPUT_AUDIO_DIR, f"{scene_id}.wav")
    image_path = os.path.join(INPUT_IMAGE_DIR, f"{scene_id}.png")
    subtitle_path = os.path.join(SUBTITLE_DIR, f"{scene_id}.srt")
    output_path = os.path.join(OUTPUT_DIR, f"{scene_id}.mp4")

    if not os.path.exists(audio_path):
        print(f"⛔ Ses bulunamadı: {audio_path}")
        return

    if not os.path.exists(image_path):
        print(f"⛔ Görsel bulunamadı: {image_path}")
        return

    audio = AudioFileClip(audio_path)
    image = ImageClip(image_path).set_duration(audio.duration).set_fps(24).resize(height=1080)

    subtitles = make_subtitle_clip(subtitle_path, audio.duration)
    if subtitles:
        final = CompositeVideoClip([image, subtitles]).set_audio(audio)
    else:
        final = image.set_audio(audio)

    final.write_videofile(output_path, fps=30, codec="libx264", audio_codec="aac")

def main():
    Path(OUTPUT_DIR).mkdir(parents=True, exist_ok=True)
    audio_files = sorted([f for f in os.listdir(INPUT_AUDIO_DIR) if f.endswith(".wav")])
    for f in audio_files:
        scene_id = Path(f).stem
        process_scene(scene_id)

if __name__ == "__main__":
    main()
