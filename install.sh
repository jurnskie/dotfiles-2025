#!/bin/bash
set -e # Stop bij fouten

echo "🚀 Starting System Bootstrap..."

# 1. Detecteer Distro en installeer basis tools
if command -v dnf &> /dev/null; then
    sudo dnf install -y chezmoi 1password 1password-cli flatpak curl
elif command -v apt &> /dev/null; then
    sudo apt update && sudo apt install -y chezmoi 1password 1password-cli flatpak curl
fi

# 2. Installeer DDEV (deze ontbrak nog in de automatisering)
if ! command -v ddev &> /dev/null; then
    echo "📦 Installing DDEV..."
    curl -fsSL https://raw.githubusercontent.com/ddev/ddev/master/scripts/install_ddev.sh | bash
fi

# 3. Flathub toevoegen
echo "📦 Adding Flathub..."
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# 4. 1Password Check
echo "⚠️  Log nu in bij de 1Password Desktop App en zet 'CLI Integration' aan."
echo "Druk op Enter als je dat gedaan hebt..."
read -r

# 5. Chezmoi initialiseren
if [ ! -d "$HOME/.local/share/chezmoi" ]; then
    echo "setup Chezmoi..."
    # Vervang onderstaande URL door je eigen git repo!
    chezmoi init https://github.com/jurnskie/dotfiles-2025.git
else
    echo "✅ Chezmoi al aanwezig."
fi

# 6. De Grote Apply
echo "🪄 Applying dotfiles and installing apps..."
chezmoi apply --force

echo "🎉 Systeem is klaar! Herstart je terminal of run 'source ~/.bashrc'"
