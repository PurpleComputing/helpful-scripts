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
# dockutil-labels.sh SCMv0NA
# Last Updated by Michael Tanner, 23/04/2023
####################################################################################################
echo "*** BEGIN dockutil-labels.sh ***"
DEPLOG=/var/tmp/depnotify.log
# ********************************************************************************************************************************
# APP LABELS
# ********************************************************************************************************************************
if [ -z "$DOCKPOS" ]; then
	echo "Dock Position is not set, adding $@ to the end of the dock"
	DOCKPOS=end
fi

# BROWSERS
if [[ " $@ " =~ "safari" ]]; then
	APPNA="Safari"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "googlechrome" ]]; then
	APPNA="Google Chrome"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "firefox" ]]; then
	APPNA="Firefox"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "brave" ]]; then
	APPNA="Brave Browser"
	APPPA="/Applications"

fi

# MICROSOFT OFFICE APPS
if [[ " $@ " =~ "microsoftword" ]]; then
	APPNA="Microsoft Word"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "microsoftexcel" ]]; then
	APPNA="Microsoft Excel"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "microsoftpowerpoint" ]]; then
	APPNA="Microsoft Powerpoint"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "microsoftoutlook" ]]; then
	APPNA="Microsoft Outlook"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "microsoftonenote" ]]; then
	APPNA="Microsoft OneNote"
	APPPA="/Applications"

fi

# CLOUD STORAGE APPS
if [[ " $@ " =~ "dropbox" ]]; then
	APPNA="Dropbox"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "microsoftonedrive" ]]; then
	APPNA="OneDrive"
	APPPA="/Applications"

fi

# VIDEO MEETING APPS
if [[ " $@ " =~ "slack" ]]; then
	APPNA="Slack"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "microsoftteams" ]]; then
	APPNA="Microsoft Teams"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "zoom" ]]; then
	APPNA="zoom.us"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "skype" ]]; then
	APPNA="Skype"
	APPPA="/Applications"

fi
# ADOBE APPS
if [[ " $@ " =~ "photoshop2022" ]]; then
	APPNA="Adobe Photoshop 2022"
	APPPA="/Applications/Adobe Photoshop 2022"

fi
if [[ " $@ " =~ "indesign2022" ]]; then
	APPNA="Adobe InDesign 2022"
	APPPA="/Applications/Adobe InDesign 2022"

fi
if [[ " $@ " =~ "illustrator2022" ]]; then
	APPNA="Adobe Illustrator"
	APPPA="/Applications/Adobe Illustrator 2022"

fi
if [[ " $@ " =~ "acrobatdc" ]]; then
	APPNA="Adobe Acrobat"
	APPPA="/Applications/Adobe Acrobat DC"

fi
if [[ " $@ " =~ "adobereaderdc" ]]; then
	APPNA="Adobe Acrobat Reader"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "adobecreativeclouddesktop" ]]; then
	APPNA="Creative Cloud"
	APPPA="/Applications/Utilities/Adobe Creative Cloud/ACC"

fi
#OTHERS
if [[ " $@ " =~ "console" ]]; then
	APPNA="Console"
	APPPA="/Applications/Utilities"

fi
if [[ " $@ " =~ "activitymonitor" ]]; then
	APPNA="Activity Monitor"
	APPPA="/Applications/Utilities"

fi
if [[ " $@ " =~ "diskutility" ]]; then
	APPNA="Disk Utility"
	APPPA="/Applications/Utilities"

fi
if [[ " $@ " =~ "terminal" ]]; then
	APPNA="Terminal"
	APPPA="/Applications/Utilities"

fi
if [[ " $@ " =~ "mail" ]]; then
	APPNA="Mail"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "maps" ]]; then
	APPNA="Maps"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "news" ]]; then
	APPNA="News"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "filezilla" ]]; then
	APPNA="FileZilla"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "teamviewer" ]]; then
	APPNA="TeamViewer"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "teamviewerhost" ]]; then
	APPNA="TeamViewer Host"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "appleremotedesktop" ]]; then
	APPNA="Remote Desktop"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "screensharing" ]]; then
	APPNA="Screen Sharing"
	APPPA="/System/Library/CoreServices/Applications"

fi
if [[ " $@ " =~ "microsoftremotedesktop" ]]; then
	APPNA="Microsoft Remote Desktop"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "1password8" ]]; then
	APPNA="1Password"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "1password7" ]]; then
	APPNA="1Password 7"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "filemakerpro" ]]; then
	APPNA="FileMaker Pro"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "keka" ]]; then
	APPNA="Keka"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "icons" ]]; then
	APPNA="Icons"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "cyberduck" ]]; then
	APPNA="Cyberduck"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "asana" ]]; then
	APPNA="Asana"
	APPPA="/Applications"

fi
# NOT KNOWN TO INSTALLOMATOR - USE FOR DOCK POPULATION ONLY

if [[ " $@ " =~ "zywallsecuextender" ]]; then
	APPNA="ZyWALL SecuExtender"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "redstorproese" ]]; then
	APPNA="Redstor Pro ESE"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "mitelconnect" ]]; then
	APPNA="Mitel Connect"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "transmit" ]]; then
	APPNA="Transmit"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "monday" ]]; then
	APPNA="monday.com"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "filemaker15" ]]; then
	APPNA="FileMaker Pro"
	APPPA="/Applications/FileMaker Pro 15"

fi
if [[ " $@ " =~ "excellcloudvoice" ]]; then
	APPNA="Excell Cloud Voice Plus"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "accountedgene" ]]; then
	APPNA="AccountEdge NE"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "3cx" ]]; then
	APPNA="3CX Desktop App"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "nordlayer" ]]; then
	APPNA="NordLayer"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "nordpass" ]]; then
	APPNA="NordPass"
	APPPA="/Applications"

fi
if [[ " $@ " =~ "btcloudphone" ]]; then
	APPNA="BT Cloud Phone"
	APPPA="/Applications"

fi
# ********************************************************************************************************************************
# END APP LABELS
# ********************************************************************************************************************************



# MOSYLE SELF SERVICE
if [[ " $@ " =~ "mosyless" ]]; then
	APPNA="Self-Service"
	APPPA="/Applications"
	DOCKPOS=2
fi

# SYSTEM PREFERENCES
if [[ " $@ " =~ "systempreferences" ]]; then
	APPNA="System Preferences"
	APPPA="/Applications"

fi

# SYSTEM PREFERENCES
if [[ " $@ " =~ "systemsettings" ]]; then
	APPNA="System Settings"
	APPPA="/Applications"

fi

# LAUNCHPAD
if [[ " $@ " =~ "launchpad" ]]; then
	APPNA="Launchpad"
	APPPA="/Applications"
	DOCKPOS=1
fi

# ********************************************************************************************************************************
# EXECUTE TASK
# ********************************************************************************************************************************
   if [[ " $@ " =~ "microsoftoffice365" ]]; then
		 APPNA="Microsoft Office"
		 echo "Status: adding $APPNA to the Dock" >> $DEPLOG
		 echo "removing $APPNA from the Dock"
		  /usr/local/bin/dockutil --remove "Microsoft Word" --allhomes --no-restart
		  sleep .5
		  /usr/local/bin/dockutil --remove "Microsoft Excel" --allhomes --no-restart
		  sleep .5
		  /usr/local/bin/dockutil --remove "Microsoft Powerpoint" --allhomes --no-restart
		  sleep .5
		  /usr/local/bin/dockutil --remove "Microsoft Outlook" --allhomes --no-restart
		 sleep .5
		 echo "adding Microsoft Office to the Dock"
		 sleep .5
		 /usr/local/bin/dockutil --add /Applications/Microsoft\ Word.app --position 6 --allhomes --no-restart
		 sleep .5
		 /usr/local/bin/dockutil --add /Applications/Microsoft\ Excel.app --position 7 --allhomes --no-restart
		 sleep .5
		 /usr/local/bin/dockutil --add /Applications/Microsoft\ Powerpoint.app --position 8 --allhomes --no-restart
		 sleep .5
		 /usr/local/bin/dockutil --add /Applications/Microsoft\ Outlook.app --position 9 --allhomes --no-restart
		 sleep .5
	 else
		echo "Status: adding $APPNA to the Dock" >> $DEPLOG
		echo "removing $APPNA from the Dock"
		/usr/local/bin/dockutil --remove "$APPNA" --allhomes --no-restart
		sleep .2
		echo "adding $APPNA to the Dock"
		/usr/local/bin/dockutil --add "$APPPA/$APPNA.app" --position $DOCKPOS --allhomes --no-restart
		sleep .2
   fi

# ********************************************************************************************************************************
# END EXECUTION
# ********************************************************************************************************************************

# ERROR RESPONSES
# if [[ " $@ " =~ '' ]]; then
# 	# whatever you want to do when array contains value
# 	echo No Label Provided
# fi

echo "*** END dockutil-labels.sh ***"
