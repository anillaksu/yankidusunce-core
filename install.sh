#!/bin/bash

echo "Echo Agent kurulumu başlatılıyor..."
sudo apt update && sudo apt install -y python3 python3-pip git ffmpeg
pip3 install -r requirements.txt

echo "Kurulum tamamlandı."
