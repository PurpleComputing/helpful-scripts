DEPLOG=/var/tmp/depnotify.log


# ********************************************************************************************************************************
# APP LABELS
# ********************************************************************************************************************************

# BROWSERS
if [[ " $@ " =~ "safari" ]]; then
    APPNA="Safari"
    APPPA="/Applications"
    DOCKPOS=end
fi
if [[ " $@ " =~ "googlechrome" ]]; then
    APPNA="Google Chrome"
    APPPA="/Applications"
    DOCKPOS=end
fi
if [[ " $@ " =~ "firefox" ]]; then
    APPNA="Firefox"
    APPPA="/Applications"
    DOCKPOS=end
fi

# MICROSOFT OFFICE APPS
if [[ " $@ " =~ "microsoftword" ]]; then
    APPNA="Microsoft Word"
    APPPA="/Applications"
    DOCKPOS=end
fi
if [[ " $@ " =~ "microsoftexcel" ]]; then
    APPNA="Microsoft Excel"
    APPPA="/Applications"
    DOCKPOS=end
fi
if [[ " $@ " =~ "microsoftpowerpoint" ]]; then
    APPNA="Microsoft Powerpoint"
    APPPA="/Applications"
    DOCKPOS=end
fi
if [[ " $@ " =~ "microsoftoutlook" ]]; then
    APPNA="Microsoft Outlook"
    APPPA="/Applications"
    DOCKPOS=end
fi


# CLOUD STORAGE APPS
if [[ " $@ " =~ "dropbox" ]]; then
    APPNA="Dropbox"
    APPPA="/Applications"
    DOCKPOS=end
fi
if [[ " $@ " =~ "microsoftonedrive" ]]; then
    APPNA="OneDrive"
    APPPA="/Applications"
    DOCKPOS=end
fi

# VIDEO MEETING APPS
if [[ " $@ " =~ "slack" ]]; then
    APPNA="Slack"
    APPPA="/Applications"
    DOCKPOS=end
fi
if [[ " $@ " =~ "microsoftteams" ]]; then
    APPNA="Microsoft Teams"
    APPPA="/Applications"
    DOCKPOS=end
fi
if [[ " $@ " =~ "zoom" ]]; then
    APPNA="zoom.us"
    APPPA="/Applications"
    DOCKPOS=end
fi

# ADOBE APPS
if [[ " $@ " =~ "photoshop2022" ]]; then
    APPNA="Adobe Photoshop 2022"
    APPPA="/Applications/Adobe Photoshop 2022"
    DOCKPOS=end
fi
if [[ " $@ " =~ "indesign2022" ]]; then
    APPNA="Adobe InDesign 2022"
    APPPA="/Applications/Adobe InDesign 2022"
    DOCKPOS=end
fi
if [[ " $@ " =~ "illustrator2022" ]]; then
    APPNA="Adobe Illustrator"
    APPPA="/Applications/Adobe Illustrator 2022"
    DOCKPOS=end
fi
if [[ " $@ " =~ "acrobatdc" ]]; then
    APPNA="Adobe Acrobat"
    APPPA="/Applications/Adobe Acrobat DC"
    DOCKPOS=end
fi

#OTHERS
if [[ " $@ " =~ "mail" ]]; then
    APPNA="Mail"
    APPPA="/Applications"
    DOCKPOS=end
fi
if [[ " $@ " =~ "maps" ]]; then
    APPNA="Maps"
    APPPA="/Applications"
    DOCKPOS=end
fi
if [[ " $@ " =~ "news" ]]; then
    APPNA="News"
    APPPA="/Applications"
    DOCKPOS=end
fi

# ********************************************************************************************************************************
# END APP LABELS
# ********************************************************************************************************************************



# MOSYLE SELF SERVICE
if [[ " $@ " =~ "mosyless" ]]; then
    APPNA="Self-Service"
    DOCKPOS=2
fi



# ********************************************************************************************************************************
# EXECUTE TASK
# ********************************************************************************************************************************
    echo "Status: adding $APPNA to the Dock" >> $DEPLOG
    echo "removing $APPNA from the Dock"
    /usr/local/bin/dockutil --remove "$APPNA" --allhomes --no-restart
    sleep .5
    echo "adding $APPNA to the Dock"
    /usr/local/bin/dockutil --add "$APPPA/$APPNA.app" --position $DOCKPOS --allhomes --no-restart
    sleep .5
# ********************************************************************************************************************************
# END EXECUTION
# ********************************************************************************************************************************

# ERROR RESPONSES
if [[ " $@ " =~ '' ]]; then
    # whatever you want to do when array contains value
    echo No Label Provided
fi