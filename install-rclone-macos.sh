#!/bin/bash
echo Downloading Rclone
cd /tmp && curl -o rclone-current-osx-amd64.zip https://downloads.rclone.org/rclone-current-osx-amd64.zip
unzip -a rclone-current-osx-amd64.zip && cd rclone-*-osx-amd64
sudo mkdir -p /usr/local/bin
sudo mv rclone /usr/local/bin/
cd .. && rm -rf rclone-*-osx-amd64 rclone-current-osx-amd64.zip
