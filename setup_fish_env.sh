#!/bin/bash

# PYENV kurulumu
echo "PYENV kurulumu başlatılıyor..."
if ! command -v pyenv &> /dev/null; then
    echo "PYENV mevcut değil, kuruluyor..."
    curl https://pyenv.run | bash
fi

# Ortam değişkenlerini Fish için ayarla
echo "Fish shell için ortam değişkenleri ekleniyor..."
if ! grep -q "pyenv init" ~/.config/fish/config.fish; then
    echo '
    # PYENV: Ortam değişkenleri
    set -x PYENV_ROOT $HOME/.pyenv
    set -x PATH $PYENV_ROOT/bin $PATH
    set -x PATH $PYENV_ROOT/shims $PATH

    # PYENV: Shell entegrasyonu (Fish uyumlu)
    if status is-interactive
        and test -e "$PYENV_ROOT/bin/pyenv"
        pyenv init - | source
        pyenv virtualenv-init - | source
    end

    # Locale ayarları (isteğe bağlı)
    set -x LANG tr_TR.UTF-8
    set -x LC_ALL tr_TR.UTF-8

    # Diğer ayarlar (isteğe bağlı)
    set -x EDITOR nano
    set -x VISUAL nano

    # venv otomatik aktifleştirme (isteğe bağlı)
    # source $HOME/yankidusunce-core/.venv311/bin/activate.fish
    ' >> ~/.config/fish/config.fish
    echo "Fish için gerekli ortam değişkenleri eklendi."
else
    echo "Fish için ortam değişkenleri zaten mevcut."
fi

# Python 3.11 kurulumunu kontrol et
echo "Python 3.11 kontrol ediliyor..."
if ! pyenv versions | grep -q "3.11"; then
    echo "Python 3.11 kurulumu başlatılıyor..."
    pyenv install 3.11.8
    pyenv global 3.11.8
    echo "Python 3.11 kuruldu."
else
    echo "Python 3.11 zaten kurulu."
fi

# Python paketleri kurulumu
echo "Python paketleri kuruluyor..."
source ~/.config/fish/config.fish
pip install --upgrade pip
pip install openai-whisper

echo "Kurulum tamamlandı. Sisteminiz hazır!"
