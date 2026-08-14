#!/bin/bash
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo "Script must be run as root!"
    exit 1
fi

if ! command -v apt-get >/dev/null 2>&1; then
    echo "APT not found!"
    exit 1
fi

apt-get update
apt-get install -y --no-install-recommends \
    curl \
    ca-certificates
apt-get clean
rm -rf /var/lib/apt/lists/*

BREW_USER="${_REMOTE_USER:-$(getent passwd 1000 | cut -d: -f1)}"

if [ -z "$BREW_USER" ]; then
    echo "No non-root user found!"
    exit 1
fi

su - "$BREW_USER" -c '
    BREW=/home/linuxbrew/.linuxbrew/bin/brew

    if [ ! -x "$BREW" ]; then
        NONINTERACTIVE=1 /bin/bash -c \
            "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    eval "$("$BREW" shellenv)"

    brew install fish
    brew install --cask antigravity-cli
'
