#!/bin/bash

# --- Helper Functions ---

# Function to print a formatted message
print_message() {
    echo "----------------------------------------"
    echo "$1"
    echo "----------------------------------------"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# --- Variable Setup ---

NVIM_CONFIG_REPO="bazarghan/nvim"

# The local directory where the Neovim config should be cloned
NVIM_CONFIG_DIR="${HOME}/.config/nvim"

# --- Main Logic ---

# 1. Determine the Operating System and Package Manager
OS=""
PACKAGE_MANAGER=""
UPDATE_CMD=""
INSTALL_CMD=""
NEEDS_SUDO="sudo"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    if command_exists apt; then
        PACKAGE_MANAGER="apt"
        UPDATE_CMD="sudo apt-get update"
        INSTALL_CMD="sudo apt-get install -y"
    elif command_exists pacman; then
        PACKAGE_MANAGER="pacman"
        UPDATE_CMD="sudo pacman -Syu"
        INSTALL_CMD="sudo pacman -S --noconfirm"
    elif command_exists dnf; then
        PACKAGE_MANAGER="dnf"
        INSTALL_CMD="sudo dnf install -y"
    else
        echo "Unsupported Linux distribution. Please install dependencies manually."
        exit 1
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    PACKAGE_MANAGER="brew"
    NEEDS_SUDO="" # Homebrew does not use sudo
    # Check if Homebrew is installed
    if ! command_exists brew; then
        print_message "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    UPDATE_CMD="brew update"
    INSTALL_CMD="brew install"
else
    echo "Unsupported operating system: $OSTYPE"
    exit 1
fi

print_message "Detected OS: $OS | Package Manager: $PACKAGE_MANAGER"

# 2. Update package manager repositories
print_message "Updating package lists..."
eval "$UPDATE_CMD"

# 3. Install Core Dependencies
print_message "Installing core dependencies..."
CORE_DEPS=(
    "git"          # For cloning the config and plugins
    "curl"         # For downloading installers
    "ripgrep"      # For Telescope live_grep
    "fd"           # For VenvSelect and Telescope
)

# Add build tools for Linux, which are often needed for compiling plugins
if [[ "$OS" == "linux" ]]; then
    if [[ "$PACKAGE_MANAGER" == "apt" ]]; then
        CORE_DEPS+=("build-essential")
    elif [[ "$PACKAGE_MANAGER" == "pacman" ]]; then
        CORE_DEPS+=("base-devel")
    elif [[ "$PACKAGE_MANAGER" == "dnf" ]]; then
        CORE_DEPS+=("make" "automake" "gcc" "gcc-c++" "kernel-devel")
    fi
fi

for dep in "${CORE_DEPS[@]}"; do
    if ! command_exists "$dep"; then
        print_message "Installing $dep..."
        eval "$INSTALL_CMD $dep"
    else
        echo "$dep is already installed."
    fi
done

# 4. Install Neovim (at least version 0.9)
print_message "Checking for Neovim..."
if ! command_exists nvim; then
    print_message "Neovim not found. Installing Neovim..."
    if [[ "$OS" == "macos" ]]; then
        brew install neovim
    elif [[ "$OS" == "linux" ]]; then
        # For Linux, we'll download the stable AppImage for maximum compatibility
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
        chmod u+x nvim.appimage
        sudo mv nvim.appimage /usr/local/bin/nvim
    fi
else
    echo "Neovim is already installed."
fi
# Verify version (optional but recommended)
nvim --version

# 5. Install Language-Specific Dependencies
print_message "Installing language-specific dependencies..."

# Node.js (for pyright, vtsls, etc.)
if ! command_exists node; then
    print_message "Installing Node.js..."
    if [[ "$OS" == "macos" ]]; then
        brew install node
    elif [[ "$OS" == "linux" ]]; then
        # Use nodesource installer for a recent version
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt-get install -y nodejs
    fi
else
    echo "Node.js is already installed."
fi

# 6. Clone Neovim Configuration
print_message "Setting up Neovim configuration..."
if [ ! -d "$NVIM_CONFIG_DIR" ]; then
    print_message "Cloning your Neovim configuration from GitHub..."
    git clone "https://github.com/$NVIM_CONFIG_REPO.git" "$NVIM_CONFIG_DIR"
else
    echo "Neovim configuration directory already exists. Skipping clone."
    # Optional: You could add logic here to pull the latest changes
    # print_message "Pulling latest changes for Neovim configuration..."
    # (cd "$NVIM_CONFIG_DIR" && git pull)
fi

# 7. Install Neovim Plugins
print_message "Installing Neovim plugins via lazy.nvim..."
# The `--headless` flag opens Neovim, runs the command, and exits.
# `Lazy sync` will install and clean up plugins based on your config.
nvim --headless "+Lazy! sync" +qa

print_message "Setup complete! You can now launch Neovim with 'nvim'."

