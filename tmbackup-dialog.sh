#!/bin/zsh
####################################################################################################
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
# ATTENTION - DISCLAIMER
# YOU USE THIS SCRIPT AT YOUR OWN RISK. THE SCRIPT IS PROVIDED FOR USE “AS IS” WITHOUT WARRANTY OF
# ANY KIND. TO THE MAXIMUM EXTENT PERMITTED BY LAW PURPLE COMPUTING DISCLAIMS ALL WARRANTIES OF ANY
# KIND, EITHER EXPRESS OR IMPLIED, INCLUDING, WITHOUT LIMITATION, IMPLIED WARRANTIES OR CONDITIONS
# OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. PURPLE COMPUTING CANNOT
# BE HELD LIABLE FOR DAMAGES CAUSED BY THE EXECUTION OF THIS CODE.
#
####################################################################################################
# TM-Login-Check.sh SCMv
# Last Updated by Michael Tanner, 31/05/2023
####################################################################################################
curl -s https://raw.githubusercontent.com/PurpleComputing/helpful-scripts/main/tmbackupdate.sh | bash
curl -s https://raw.githubusercontent.com/PurpleComputing/helpful-scripts/main/tmbackupstate.sh | bash

# CHECKING COMPLIANCE
 if grep -q 'COMPLIANT' /tmp/TMBACKUPSTATE.check;
 then
 	echo Compliant... Exiting...
    exit 0
 fi

# LAUNCHING DIALOG
  /usr/local/bin/dialog dialog --title none --message "**Your Mac has not been backed up in a long time.**\n\n Please connect your backup drive as soon as possible! \n\nStatus: \n $(cat "/tmp/TMBACKUPDATE.check")" --alignment centre --centericon --small --ontop --infobuttontext "Request Support" --infobuttonaction "https://purplecomputing.com/support" --icon warning --overlayicon "/System/Applications/Time Machine.app" --blurscreen --quitoninfo --button1text "Okay"

export WARNINGDAYS CRITICALDAYS
