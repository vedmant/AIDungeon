#!/bin/bash
cd "$(dirname "${0}")"
BASE_DIR="$(pwd)"

MODELS_DIRECTORY=generator/gpt2/models
MODEL_VERSION=model_v5
MODEL_NAME=model-550
MODEL_TORRENT_URL="magnet:?xt=urn:btih:b343b83b35bff774dab13e0281ce13b3daf37d3e&dn=model%5Fv5&tr=udp%3A%2F%2Ftracker.coppersurfer.tk%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.leechers-paradise.org%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.pomf.se%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.openbittorrent.com%3A80%2Fannounce&tr=udp%3A%2F%2Fp4p.arenabg.com%3A1337%2Fannounce&tr=udp%3A%2F%2F9.rarbg.me%3A2710%2Fannounce&tr=udp%3A%2F%2F9.rarbg.to%3A2710%2Fannounce&tr=udp%3A%2F%2Fexodus.desync.com%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.tiny-vps.com%3A6969%2Fannounce&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&tr=udp%3A%2F%2Fdenis.stalker.upeer.me%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.cyberia.is%3A6969%2Fannounce&tr=udp%3A%2F%2Fopen.demonii.si%3A1337%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker3.itzmx.com%3A6961%2Fannounce&tr=udp%3A%2F%2Fzephir.monocul.us%3A6969%2Fannounce&tr=udp%3A%2F%2Fxxxtor.com%3A2710%2Fannounce"
MODEL_TORRENT_BASENAME="$(basename "${MODEL_TORRENT_URL}")"

if [[ -d "${MODELS_DIRECTORY}/${MODEL_VERSION}" ]]; then
    echo "AIDungeon2 is already installed"
else
    echo "Installing dependencies"
    pip install -r requirements.txt > /dev/null
    apt-get install aria2 unzip > /dev/null
    
    echo "Downloading AIDungeon2 Model... (this may take a very, very long time)"
    mkdir -p "${MODELS_DIRECTORY}"
    cd "${MODELS_DIRECTORY}"
    mkdir "${MODEL_VERSION}"
    wget "${MODEL_TORRENT_URL}"
    unzip "${MODEL_TORRENT_BASENAME}"
    echo -e "\n\n==========================================="
    echo "We are now starting to download the model."
    echo "It will take a while to get up to speed."
    echo "DHT errors are normal."
    echo -e "===========================================\n"
    aria2c \
        --max-connection-per-server 16 \
        --split 64 \
        --bt-max-peers 500 \
        --seed-time=0 \
        --summary-interval=15 \
        --disable-ipv6 \
        "${MODEL_TORRENT_BASENAME%.*}"
    echo "Download Complete!"
fi
