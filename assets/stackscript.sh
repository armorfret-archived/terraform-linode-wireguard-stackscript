#!/usr/bin/env bash
# <UDF name="users" Label="User list (comma-delimited)" default="one,two,three,four" />
# <UDF name="deploy_repo" Label="Ansible deploy repo" default="https://github.com/akerl/deploy-wireguard-server" />

set -euo pipefail

function log() {
    local msg="$(date '+%Y-%m-%d_%H:%M:%S') -- $1"
    echo "$msg" | tee -a /root/log
}

log 'starting'

export DEBIAN_FRONTEND=noninteractive

log 'updating'
apt update

log 'upgrading'
apt upgrade -y

log 'installing deps'
apt install -y python3-pip python3-dev build-essential git vim-nox

log 'installing ansible'
pip3 install ansible

log 'cloning repo'
git clone "$DEPLOY_REPO" /opt/deploy

exit

ansible-playbook --extra-vars=ansible_python_interpreter=/usr/bin/python3 /opt/deploy/linode/setup.yml
ansible-playbook --extra-vars=ansible_python_interpreter=/usr/bin/python3 /opt/deploy/main.yml
