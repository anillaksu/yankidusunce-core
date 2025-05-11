import json
import time
import subprocess
import os

COMMANDS_FILE = "/mnt/yikimin_sesi_projecti/commands.json"
PROJE_ROOT = "/mnt/yikimin_sesi_projecti/_PROJELER"
CHECK_INTERVAL = 5  # saniye

def load_commands():
    if not os.path.exists(COMMANDS_FILE):
        return []
    with open(COMMANDS_FILE, "r") as f:
        try:
            return json.load(f)
        except json.JSONDecodeError:
            print("❌ Hatalı JSON formatı!")
            return []

def save_commands(commands):
    with open(COMMANDS_FILE, "w") as f:
        json.dump(commands, f, indent=2)

def process_command(cmd):
    proje_adi = cmd.get("proje_adi")
    if not proje_adi:
        print("⚠️ Geçersiz komut (proje_adi yok).")
        return

    proje_yolu = os.path.join(PROJE_ROOT, proje_adi)
    tts_script = os.path.join(proje_yolu, "generate_tts.py")
    video_script = os.path.join(proje_yolu, "generate_video.py")

    if not os.path.exists(tts_script) or not os.path.exists(video_script):
        print(f"🚫 Eksik dosya: {proje_adi}")
        return

    print(f"🚀 {proje_adi} → TTS başlatılıyor...")
    subprocess.run(["python3", tts_script], cwd=proje_yolu)
    print(f"🎬 {proje_adi} → Video başlatılıyor...")
    subprocess.run(["python3", video_script], cwd=proje_yolu)
    print(f"✅ {proje_adi} → Tamamlandı.")

def main():
    print("🌀 Komut dinleyici başlatıldı...")
    while True:
        commands = load_commands()
        updated = False

        for cmd in commands:
            if not cmd.get("islenmis", False):
                process_command(cmd)
                cmd["islenmis"] = True
                updated = True

        if updated:
            save_commands(commands)

        time.sleep(CHECK_INTERVAL)

if __name__ == "__main__":
    main()
