!/bin/bash

#### START SILENT DIALOG INSTALL OR UPDATE
######################################################################
# Installation using Installomator (enter the software to install separated with spaces in the "whatList"-variable)
whatList="dialog"
# Covered by Mosyle Catalog: "brave firefox googlechrome microsoftedge microsoftteams signal sublimetext vlc webex zoom" among others
LOGO="mosyleb" # or "mosylem"
######################################################################

## Mark: Code here

# No sleeping
/usr/bin/caffeinate -d -i -m -u &
caffeinatepid=$!
caffexit () {
    kill "$caffeinatepid"
    pkill caffeinate
    exit $1
}
# Mark: Start Installomator label(s) installation

# Count errors
errorCount=0

# Verify that Installomator has been installed
destFile="/usr/local/Installomator/Installomator.sh"
if [ ! -e "${destFile}" ]; then
    curl https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Installomator.sh | bash
fi

for what in $whatList; do
    #echo $item
    # Install software using Installomator
    cmdOutput="$(${destFile} ${what} LOGO=$LOGO NOTIFY=silent BLOCKING_PROCESS_ACTION=quit_kill || true)" # NOTIFY=silent BLOCKING_PROCESS_ACTION=quit_kill INSTALL=force
    # Check result
    exitStatus="$( echo "${cmdOutput}" | grep --binary-files=text -i "exit" | tail -1 | sed -E 's/.*exit code ([0-9]).*/\1/g' || true )"
    if [[ ${exitStatus} -ne 0 ]] ; then
        echo "Error installing ${what}. Exit code ${exitStatus}"
        #echo "$cmdOutput"
        errorOutput="$( echo "${cmdOutput}" | grep --binary-files=text -i "error" || true )"
        echo "$errorOutput"
        let errorCount++
    fi
done

echo
echo "Errors: $errorCount"
echo "[$(DATE)][LOG-END]"

caffexit $errorCount

#### END SILENT DIALOG INSTALL OR UPDATE


apps=(
    "Joining,/tmp/ztnetjoined.log"
    "Authorising,/tmp/ztnetauthed.log"
    "Ready to connect,/tmp/ztnetready.log"
)

# Dialog display settings, change as desired
title="Joining $ZTNETNAME's ZeroTier Network"
message="Please wait whilst we join the $ZTNETNAME network for you."

# location of dialog and dialog command file
dialogApp="/usr/local/bin/dialog"
dialog_command_file="/var/tmp/dialog.log"

# check we are running as root
if [[ $(id -u) -ne 0 ]]; then
  echo "This script should be run as root"
  exit 1
fi

# *** functions

# execute a dialog command
function dialog_command(){
  echo "$1"
  echo "$1"  >> $dialog_command_file
}

function finalise(){
  dialog_command "progresstext: Successfully Joined the $ZTNETNAME Network"
  dialog_command "progress: complete"
  dialog_command "button1text: Done"
  dialog_command "button1: enable" 
  exit 0
}

function appCheck(){
dialog_command "listitem: $(echo "$app" | cut -d ',' -f1): wait"
while [ ! -e "$(echo "$app" | cut -d ',' -f2)" ]
do
    sleep 2
done
dialog_command "progresstext: \"$(echo "$app" | cut -d ',' -f1)\" network"
dialog_command "listitem: $(echo "$app" | cut -d ',' -f1): ✅"
progress_index=$(( progress_index + 1 ))
echo "at item number $progress_index"
}

# *** end functions

# set progress total to the number of apps in the list
progress_total=${#apps[@]}

# set icon based on whether computer is a desktop or laptop
hwType=$(/usr/sbin/system_profiler SPHardwareDataType | grep "Model Identifier" | grep "Book")  
if [ "$hwType" != "" ]; then
  icon="SF=laptopcomputer.and.arrow.down,weight=thin,colour1=#51a3ef,colour2=#5154ef"
  else
  icon="SF=desktopcomputer.and.arrow.down,weight=thin,colour1=#51a3ef,colour2=#5154ef"
fi

dialogCMD="$dialogApp -p --title \"$title\" \
--message \"$message\" \
--icon \"$icon\" \
--progress $progress_total \
--button1text \"Please Wait\" \
--button1disabled"

# create the list of apps
listitems=""
for app in "${apps[@]}"; do
  listitems="$listitems --listitem '$(echo "$app" | cut -d ',' -f1)'"
done

# final command to execute
dialogCMD="$dialogCMD $listitems"

echo "$dialogCMD"

# Launch dialog and run it in the background sleep for a second to let thing initialise
eval "$dialogCMD" &
sleep 2

progress_index=0

(for app in "${apps[@]}"; do
  step_progress=$(( 1 + progress_index ))
  dialog_command "progress: $step_progress"
  appCheck &
done

wait)

# all done. close off processing and enable the "Done" button
finalise
rm -rf /tmp/ztnetauthed.log /tmp/ztnetready.log  /tmp/ztnetjoined.log
