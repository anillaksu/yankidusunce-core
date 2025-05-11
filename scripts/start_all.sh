#!/bin/bash

# whisper scriptini başlat
bash /home/anil/yankidusunce-core/scripts/whisper_auto.sh &

# Echo agent'ı başlat (ve foreground'da kalsın ki systemd takip edebilsin)
exec /usr/bin/python3 /home/anil/yankidusunce-core/echo_agent.py
