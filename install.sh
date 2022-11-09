#!/usr/bin/env bash

# System upgrades
apt-get update -y
apt-get full-upgrade -y

# Use cloudflare for DNS
if ! grep -q "nameserver 1.1.1.1" /etc/resolv.conf; then
    truncate -s0 c
    echo "nameserver 1.1.1.1" | sudo tee -a /etc/resolv.conf
    echo "nameserver 1.0.0.1" | sudo tee -a /etc/resolv.conf
fi

# Use cloudflare for NTP
if ! grep -q "NTP=time.cloudflare.com" /etc/systemd/timesyncd.conf; then
    truncate -s0 /etc/systemd/timesyncd.conf
    echo "[Time]" | sudo tee -a /etc/systemd/timesyncd.conf
    echo "NTP=time.cloudflare.com" | sudo tee -a /etc/systemd/timesyncd.conf
    echo "FallbackNTP=ntp.ubuntu.com" | sudo tee -a /etc/systemd/timesyncd.conf
fi

# Install zsh with p10k theme
if ! command -v zsh &>/dev/null; then
    apt-get install -y zsh
    chsh -s $(which zsh)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >>$HOME/.zshrc
fi

# Install docker
if ! command -v docker &>/dev/null; then
    curl -fsSL https://get.docker.com -o- | sh
    usermod -aG docker $USER
    newgrp docker
    chown "$USER":"$USER" /home/"$USER"/.docker -R
    chmod g+rwx "$HOME/.docker" -R
    systemctl enable docker.service
    systemctl enable containerd.service
fi

# Install bashtop for performance monitoring
if ! command -v bashtop &>/dev/null; then
    add-apt-repository ppa:bashtop-monitor/bashtop
    apt-get update -y
    apt-get install -y bashtop
fi

# Save some disk space
rm -rvf /usr/share/man/
apt-get autoremove -y
apt-get autoclean -y

# Download deployment files
wget \
    https://raw.githubusercontent.com/PokimaneSafety/minecraft-server/main/docker-compose.yaml \
    https://raw.githubusercontent.com/PokimaneSafety/minecraft-server/main/nginx.yaml

# Deploy
docker compose up -d
