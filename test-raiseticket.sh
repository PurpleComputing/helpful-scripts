dt=$(date '+%d%m%Y.%H00');
host=$('hostname');

echo Command: WindowTitle: Create a Support Ticket >> /var/tmp/depnotify.log
echo Command: Website: https://www.cognitoforms.com/PurpleComputingLimited/SupportRequestForm >> /var/tmp/depnotify.log
echo Command: ContinueButton: Finished >> /var/tmp/depnotify.log
#echo Command: DeterminateManual: 7 >> /var/tmp/depnotify.log
#echo Command: Command: NotificationOn: >> /var/tmp/depnotify.log

# START DEPNOTIFY
curl -o /Users/Shared/.Purple/launch-dep-en.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/launch-dep-en.sh
chmod +x /Users/Shared/.Purple/launch-dep-en.sh
screen -dmS DEPFull /Users/Shared/.Purple/launch-dep-en.sh

echo Command: DeterminateManualStep: 1 >> /var/tmp/depnotify.log

echo Status: Creating System Report >> /var/tmp/depnotify.log
mkdir -p "/Users/Shared/.Purple/Diagnostics/"
mkdir -p "/Users/Shared/.Purple/Diagnostics/$dt/"
mkdir -p "/Users/Shared/.Purple/Diagnostics/$dt/DiagnosticReports"

system_profiler >> "/Users/Shared/.Purple/Diagnostics/$dt/system_report.$host.$dt.txt"
sleep 3s

echo Command: DeterminateManualStep: 2 >> /var/tmp/depnotify.log

echo Status: Copying Log Files >> /var/tmp/depnotify.log
sleep 5s
cp -r ~/Library/Logs/DiagnosticReports/* "/Users/Shared/.Purple/Diagnostics/$dt/DiagnosticReports"
#MORE TO BE ADDED

echo Command: DeterminateManualStep: 3 >> /var/tmp/depnotify.log

echo Status: Zipping Diagnostics Info >> /var/tmp/depnotify.log
sleep 5s
zip -r "/Users/Shared/.Purple/Diagnostics/"Diagnostics.$host.$dt.zip "/Users/Shared/.Purple/Diagnostics/$dt/"

echo Command: DeterminateManualStep: 4 >> /var/tmp/depnotify.log

echo Status: Sending Diagnotics to Purple Helpdesk >> /var/tmp/depnotify.log
sleep 20s

echo Status: "Once you have completed the above ticket request please click 'Finished'." >> /var/tmp/depnotify.log

#rm -rf /tmp/brandDEPinstall.sh
# END SCRIPT WITH SUCCESS
exit 0


