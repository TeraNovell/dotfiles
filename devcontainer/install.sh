#!/bin/bash
set -e

if ! command -v apt >/dev/null 2>&1; then
    echo "APT not found!"
    exit 1
fi

apt update
apt install -y --no-install-recommends \
    git \
    curl \
    ca-certificates
rm -rf /var/lib/apt/lists/*

BREW_USER="${_REMOTE_USER:-$(getent passwd 1000 | cut -d: -f1)}"

if [ -z "$BREW_USER" ]; then
    echo "No non-root user found!"
    exit 1
fi

BREW="/home/linuxbrew/.linuxbrew/bin/brew"

if [ ! -x "$BREW" ]; then
    if [ "$(id -u)" -eq 0 ]; then
        su - "$BREW_USER" -c \
            'NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    else
        NONINTERACTIVE=1 /bin/bash -c \
            "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
fi

eval "$("$BREW" shellenv)"

brew install fish
brew install --cask antigravity-cli
