#!/bin/bash

bash /home/anil/yankidusunce-core/scripts/whisper_auto.sh &
exec /usr/bin/python3 /home/anil/yankidusunce-core/echo_agent.py
