#!/bin/bash
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo "Script runs as a non-root user!"
fi

if ! command -v apt-get >/dev/null 2>&1; then
    echo "APT not found!"
    exit 1
fi

if ! command -v sudo >/dev/null 2>&1; then
    echo "Sudo not found!"
    exit 1
fi

sudo apt-get update
sudo apt-get install -y --no-install-recommends \
    curl \
    ca-certificates
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*

if [ "$(id -u)" -eq 0 ]; then
    # root user
    BREW_USER=brew
    id "$BREW_USER" >/dev/null 2>&1 || useradd -m -s /bin/bash "$BREW_USER"
    echo "$BREW_USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/brew
    chmod 0440 /etc/sudoers.d/brew

    su - "$BREW_USER" -c '
        BREW=/home/linuxbrew/.linuxbrew/bin/brew

        if [ ! -x "$BREW" ]; then
            NONINTERACTIVE=1 /bin/bash -c \
                "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi

        eval "$("$BREW" shellenv)"

        brew install fish
        brew install opencode
        brew install --cask antigravity-cli
    '
else
    # non-root user
    BREW=/home/linuxbrew/.linuxbrew/bin/brew

    if [ ! -x "$BREW" ]; then
        NONINTERACTIVE=1 /bin/bash -c \
            "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    eval "$("$BREW" shellenv)"

    brew install fish
    brew install opencode
    brew install --cask antigravity-cli
fi

echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.bashrc"
