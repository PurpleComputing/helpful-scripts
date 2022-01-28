
##-------------------------------##
##         SET VARIABLES         ##
##-------------------------------##
APPNAME="Application Name"
LOGFILE=/Library/Caches/com.purplecomputing.mdm/Logs/"$APPNAME".log
DEPLOG=/var/tmp/depnotify.log
URL="https://path/to/installer/package"
USER="User Credentials for download if required"
PASS="User Credentials for download if required"

##-------------------------------##
##       PREFLIGHT SCRIPT        ##
##-------------------------------##

# CLEAN UP PREVIOUS FILES
mkdir -p /Library/Caches/com.purplecomputing.mdm/Scripts/
rm -rf /Library/Caches/com.purplecomputing.mdm/Scripts/$SCRIPTNAME
rm -rf /Library/Caches/com.purplecomputing.mdm/Scripts/brandDEPinstall.sh
rm -rf /Library/Caches/com.purplecomputing.mdm/Apps/.appinstallname
rm -rf /Library/Caches/com.purplecomputing.mdm/Apps/pkg
rm -rf "$DEPLOG"
rm -rf "$LOGFILE"

# UPDATE PURPLE HELPERS
curl -o /tmp/purple-helpers.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/purple-helpers.sh
chmod +x /tmp/purple-helpers.sh
/tmp/purple-helpers.sh
sleep 2
rm -rf /tmp/purple-helpers.sh

##-------------------------------##
##       DEPNOTIFY WINDOW        ##
##-------------------------------##

# SET APP TITLE TO APPNAME
echo "$APPNAME" >> /Library/Caches/com.purplecomputing.mdm/Apps/.appinstallname

# SET DEP NOTIFY FOR REINSTALL
curl -o /Library/Caches/com.purplecomputing.mdm/Scripts/brandDEPinstall.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/brandDEPinstall.sh
chmod +x /Library/Caches/com.purplecomputing.mdm/Scripts/brandDEPinstall.sh
/Library/Caches/com.purplecomputing.mdm/Scripts/brandDEPinstall.sh NotificationOff >> /Library/Logs/com.purplecomputing.mdm/brandDEPinstall.log
sleep 2
chmod 777 "$DEPLOG"
rm -rf /Library/Caches/com.purplecomputing.mdm/Scripts/brandDEPinstall.sh

# START DEPNOTIFY
sudo -u $(stat -f "%Su" /dev/console) /Library/Application\ Support/Purple/launch-dep.sh

##-------------------------------##
##         START SCRIPT          ##
##-------------------------------##


# DOWNLOAD FILE
echo Status: Downloading >> "$DEPLOG"
/usr/bin/curl -L -u $USER:$PASS http://"$URL" -o /Library/Caches/com.purplecomputing.mdm/Apps/"$APPNAME" 2>&1 | tee -a "$LOGFILE" &

# GET DOWNLOAD PROGRESS INTO DEPnotify
 echo "Command: DeterminateManual: 100" >> "$DEPLOG"
        until [[ $current_progress_value -ge 100 ]]; do
            until [[ $current_progress_value -gt $last_progress_value ]]; do
                current_progress_value=$(tail -1 "$LOGFILE" | tr '\r' '\n' | awk 'END{print substr($1,1,3)}')
                sleep 2
                done
            echo "Command: DeterminateManualStep: $((current_progress_value-last_progress_value))" >> "$DEPLOG"
            echo "Status: Downloading - $current_progress_value%" >> "$DEPLOG"
            last_progress_value=$current_progress_value
            done