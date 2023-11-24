#!/bin/bash

###############################################################################################
#
#                                                        ******
#                                        *...../    /    ******
# **************  *****/  *****/*****/***/*************/ ******  /**********
# ******/..*****/ *****/  *****/********//******/ ,*****/******,*****  ,*****/
# *****/    ***** *****/  *****/*****/    *****/   /**************************
# *******//*****/ *************/*****/    *********************/*******./*/*  ())
# *************    ******/*****/*****/    *****/******/. ******   ********** (()))
# *****/                                  *****/                              ())
# *****/                                  *****/
#
###############################################################################################
# NOTICE: UBUNTU-SPECIFIC SCRIPT, WE RECOMMEND 22.04 LTS
###############################################################################################
mkdir -p /opt/PurpleComputing/UptimeKuma/data
sudo apt-get remove docker docker-engine docker.io containerd runc -y
sudo apt-get update -y && \
sudo apt-get install \
		ca-certificates \
		curl \
		gnupg \
		lsb-release -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update -y

  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose -y
  

docker run -d --restart=always -p 3001:3001 -v /opt/PurpleComputing/UptimeKuma/data:/app/data --name uptime-kuma louislam/uptime-kuma:1
