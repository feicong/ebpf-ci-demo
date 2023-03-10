#!/usr/bin/env bash

# https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/github-debian.sh#L184
# https://github.com/cli/cli/issues/4634
# https://serverfault.com/questions/500764/dpkg-reconfigure-unable-to-re-open-stdin-no-file-or-directory

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
dpkg-reconfigure locales

sudo apt-get update && DEBIAN_FRONTEND=noninteractive sudo apt install -y tzdata && sudo apt-get install -y git curl wget apt-utils rsync

curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

sudo chmod 644 /usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod 644 /etc/apt/sources.list.d/github-cli.list

sudo apt-get update && sudo apt-get install gh -y
