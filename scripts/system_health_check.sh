#!/usr/bin/env bash
echo "✅ whisper_auto.sh: $(test -x whisper_auto.sh && echo OK || echo HATALI)"
echo "✅ config.yaml: $(test -f ../config/whisper_config.yaml && echo OK || echo HATALI)"
echo "✅ whisper: $(command -v whisper >/dev/null && echo OK || echo HATALI)"
echo "✅ Git sync: $(test -x ../github/auto_git_push.sh && echo OK || echo HATALI)"
systemctl --user status auto_whisper.service | grep Active:
