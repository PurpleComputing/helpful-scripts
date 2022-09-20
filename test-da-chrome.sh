#!/bin/sh
################################################################################################
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
################################################################################################
# SETS CHROME AS DEFAULT BROWSER AND MAIL APPLICATION
################################################################################################

curl -o /tmp/MSDA.pkg https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/msda.pkg
echo "Status: Running the installer"
installer -pkg /tmp/MSDA.pkg -target /
echo "Status: Cleaning up after the installer"
rm -rf /tmp/MSDA.pkg

# SETS WEB TRAFFIC to CHROME
/usr/local/bin/msda set com.google.chrome -p http -p https -u public.url all -u public.html viewer -u public.xhtml all -feu
/usr/local/bin/msda set com.google.chrome -p http -p https -u public.url all -u public.html viewer -u public.xhtml all -fut

# SETS MAIL to CHROME
/usr/local/bin/msda set com.google.chrome -p http -p https -p mailto -u public.url all -u public.html viewer -u public.xhtml all -fut
/usr/local/bin/msda set com.google.chrome -p http -p https -p mailto -u public.url all -u public.html viewer -u public.xhtml all -feu
