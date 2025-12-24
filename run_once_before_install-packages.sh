#!/bin/bash

# 1. Handmatig de repo downloaden (omzeilt config-manager problemen)
sudo curl -Lo /etc/yum.repos.d/docker-ce.repo https://download.docker.com/linux/fedora/docker-ce.repo

# 2. Cache opschonen en repo forceren te laden
sudo dnf clean all
sudo dnf makecache

# 3. Installeer Docker
# We voegen --allowerasing toe voor het geval er conflicten zijn met podman
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin --allowerasing

# 4. Groep aanmaken als deze nog niet bestaat (voorkomt de 'groep bestaat niet' fout)
if ! getent group docker > /dev/null; then
    sudo groupadd docker
fi

# 5. Start Docker en voeg gebruiker toe
sudo systemctl enable --now docker
sudo usermod -aG docker $USER

# 6. Installeer DDEV
if ! command -v ddev &> /dev/null; then
    curl -fsSL https://raw.githubusercontent.com/ddev/ddev/master/scripts/install_ddev.sh | bash
fi



#Fedora pakketten

sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
sudo dnf install -y 1password-cli



