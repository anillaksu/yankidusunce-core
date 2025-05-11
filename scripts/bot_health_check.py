# scripts/bot_health_check.py

import os
import requests
import sys

def main():
    token = os.getenv("TELEGRAM_BOT_TOKEN")
    if not token:
        print("❌ TELEGRAM_BOT_TOKEN not found in environment variables.")
        sys.exit(1)

    url = f"https://api.telegram.org/bot{token}/getMe"
    response = requests.get(url)

    if response.status_code == 200 and response.json().get("ok"):
        print("✅ Token is valid. Bot is alive.")
    else:
        print("❌ Invalid token or bot not reachable.")
        sys.exit(1)

if __name__ == "__main__":
    main()
