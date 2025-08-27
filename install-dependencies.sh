#!/bin/sh

# check os and distro
OS=$(uname -s)
DISTRO=

if [ "$OS" = "Linux" ]; then
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO="$ID"
    fi
elif [ "$OS" = "Darwin" ]; then
    DISTRO="macos"
fi

echo "Detected OS: $OS, Distribution: $DISTRO"

install_dnf() {
    echo "Installing packages using dnf (Fedora/RHEL)"
    sudo dnf install -y \
        zsh \
        tmux \
        neovim \
        python3-pip \
        nodejs \
        npm \
        fzf \
        ripgrep \
        fd-find \
        ranger \
        qalc \

        # https://docs.docker.com/engine/install/fedora/
        # docker \ 
        # docker-compose
}

install_pacman() {
    echo "Installing packages using pacman (Arch)"
    sudo pacman -S --noconfirm \
        zsh \
        tmux \
        neovim \
        python-pip \
        nodejs \
        npm \
        fzf \
        ripgrep \
        fd \
        ranger \
        qalc \
        docker \
        docker-compose
}

case "$DISTRO" in
    fedora|rhel|centos)
        install_dnf
        ;;
    arch|manjaro)
        install_pacman
        ;;
    *)
        echo "Unsupported distribution: $DISTRO"
        exit 1
        ;;
esac
