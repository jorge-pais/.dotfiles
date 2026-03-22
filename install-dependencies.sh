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
        zoxide

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
        libqalculate \
        zoxide \
        docker \
        docker-compose
}

install_brew() {
    echo "Installing packages using Homebrew (macOS)"
    # ensure_homebrew # check for homebrew, not yet available

    brew update

    # CLI tools
    brew install \
        zsh \
        tmux \
        neovim \
        python \
        node \
        fzf \
        ripgrep \
        fd \
        ranger \
        libqalculate \
        zoxide

    # Optional: enable fzf keybindings/completion (safe if it already ran)
    if [ -x "$(brew --prefix)/opt/fzf/install" ]; then
        "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc || true
    fi

    # Docker Desktop is typically installed as a cask on macOS
    # Uncomment if you want it:
    # brew install --cask docker
}

case "$DISTRO" in
    fedora|rhel|centos)
        install_dnf
        ;;
    arch|manjaro)
        install_pacman
        ;;
    macos)
        install_brew
        ;;
    *)
        echo "Unsupported distribution: $DISTRO"
        exit 1
        ;;
esac

