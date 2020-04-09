#!/usr/bin/env bash
# <UDF name="users" Label="User list (comma-delimited)" default="one,two,three,four" />
# <UDF name="docker_image" Label="Wireguard docker image" default="docker.pkg.github.com/dock0/wireguard/wireguard:latest" />

set -euo pipefail

function log() {
    local msg="$(date '+%Y-%m-%d_%H:%M:%S') -- $1"
    echo "$msg" | tee -a /root/log
}

log 'starting'

log 'system initial cleanup'
resize2fs /dev/sda
rm -f /etc/ssh/ssh_host*
ssh-keygen -A
sed -i '/^\/dev\/sdb/d' /etc/fstab

log 'updating'
pacman -Syu --noconfirm

log 'installing docker'
pacman -S --noconfirm docker
systemctl enable docker

echo <<EOF > /etc/systemd/system/wireguard-container@.service
[Unit]
Description=Wireguard container for %I
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=0
ExecStartPre=-/usr/bin/docker kill "wireguard-%I"
ExecStartPre=-/usr/bin/docker rm "wireguard-%I"
ExecStartPre=/usr/bin/docker pull "$DOCKER_IMAGE"
ExecStart=/usr/bin/docker run --name "wireguard-%I" -e "USER=%I" --mount "source=config-%I,target=/opt/config" "$DOCKER_IMAGE"

[Install]
WantedBy=multi-user.target
EOF

log 'creating user container services'
for user in $(echo "$USERS" | sed 's/,/ /g'); do
    systemctl enable "wireguard-container@${user}.service"
done

log 'disabling sshd'
# TODO: disable sshd
# systemctl disable sshd
