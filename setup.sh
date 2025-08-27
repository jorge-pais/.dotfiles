#!/bin/sh

# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
# It will safely back up any existing files before creating new symlinks.

# --- You have to run this from the root directory of the repository ---
DOTFILES_DIR=$(pwd)
echo "Dotfiles directory is: $DOTFILES_DIR"

# Create a directory to store old dotfiles for backup
BACKUP_DIR="$HOME/dotfiles_old"
echo "Creating backup directory for any existing dotfiles at $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# Function to create a symlink with a backup
create_symlink() {
    local source_file="$1"
    local target_file="$2"
    local backup_file="$BACKUP_DIR/$(basename "$target_file")_$(date +%Y%m%d_%H%M%S)"

    # Check if the source file exists in our repo
    if [ ! -e "$source_file" ]; then
        echo "WARNING: Source file $source_file does not exist in the repository, skipping."
        return 1
    fi

    # Check if the target already exists and is not a symlink
    if [ -e "$target_file" ] && [ ! -L "$target_file" ]; then
        echo "Backing up existing $target_file to $backup_file"
        mv "$target_file" "$backup_file"
    fi

    # If it's a symlink, just remove it
    if [ -L "$target_file" ]; then
        echo "Removing existing symlink: $target_file"
        rm "$target_file"
    fi

    # Create the parent directory if it doesn't exist
    local target_dir=$(dirname "$target_file")
    if [ ! -d "$target_dir" ]; then
        echo "Creating directory: $target_dir"
        mkdir -p "$target_dir"
    fi

    # Create the symlink
    echo "Creating symlink: $target_file -> $source_file"
    ln -s "$source_file" "$target_file"
}

# === oh-my-zsh ===
if [ ! -d "$HOME/.oh-my-zsh/" ]; then
    read -p "oh-my-zsh is not installed. Would you like to install it? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        echo "Skipping Oh My Zsh installation."
    fi
fi

# === enable docker completions on oh-my-zsh ===
if command -v docker >/dev/null 2>&1; then
    echo "Setting up Docker completions for oh-my-zsh..."
    mkdir -p "$HOME/.oh-my-zsh/completions"
    docker completion zsh > "$HOME/.oh-my-zsh/completions/_docker" 2>/dev/null || \
        echo "WARNING: Could not generate Docker completions. Docker might not be installed or available."
else
    echo "Docker not found, skipping adding completions to zsh."
fi

# === create symlink to .zshrc ===
create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

# === create symlink to neovim folder ===
if [ -d "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
    read -p "Neovim config directory already exists. Back it up before creating symlink? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        backup_path="$BACKUP_DIR/nvim_$(date +%Y%m%d_%H%M%S)"
        echo "Backing up existing nvim config to $backup_path"
        mv "$HOME/.config/nvim" "$backup_path"
    else
        echo "Skipping Neovim symlink creation to avoid overwriting existing config."
        # Skip the symlink creation
        NVIM_SKIP=true
    fi
fi

if [ -z "${NVIM_SKIP}" ]; then
    create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
fi

# === create symlink to ranger folder ===
# create_symlink "$DOTFILES_DIR/ranger" "$HOME/.config/ranger"

# === create symlink to qalc.cfg ===
# create_symlink "$DOTFILES_DIR/qalc.cfg" "$HOME/.config/qalc.cfg"

# === create symlink to tmux.conf ===
create_symlink "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
create_symlink "$DOTFILES_DIR/tmux/tmux.conf.local" "$HOME/.config/tmux/tmux.conf"

echo ""
echo "Setup complete!"
echo "Any existing files were backed up to: $BACKUP_DIR"
echo "You may need to restart your terminal or run 'source ~/.zshrc' for changes to take effect."
