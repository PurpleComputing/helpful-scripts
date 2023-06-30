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
ELKPATH=/opt/es/
hostname elastic-stack

mkdir -p $ELKPATH

cd $ELKPATH

git clone https://github.com/elkninja/elastic-stack-docker-part-one.git

mv elastic-stack-docker-part-one elastic-stack
cd elastic-stack

curl -s https://raw.githubusercontent.com/PurpleComputing/helpful-scripts/main/install-docker-ubuntu.sh | bash

#docker-compose up -d
