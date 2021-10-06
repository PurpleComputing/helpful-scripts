dt=$(date '+%d/%m/%Y %H00');
host=$('hostname');

# SET DEP NOTIFY FOR REINSTALL
#curl -o /tmp/brandDEPinstall.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/brandDEPinstall.sh
#chmod +x /tmp/brandDEPinstall.sh
#/tmp/brandDEPinstall.sh
sleep 2s
chmod 777 /var/tmp/depnotify.log
#echo Status: >> /var/tmp/depnotify.log
echo Command: WindowTitle: Create a Support Ticket >> /var/tmp/depnotify.log
echo Command: Website: https://www.cognitoforms.com/PurpleComputingLimited/SupportRequestForm >> /var/tmp/depnotify.log
echo Command: ContinueButton: Finished >> /var/tmp/depnotify.log
echo Command: DeterminateManual: 7 >> /var/tmp/depnotify.log

# START DEPNOTIFY
curl -o /Library/Application\ Support/Purple/launch-dep-en.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/launch-dep-en.sh
chmod 777 /Library/Application\ Support/Purple/launch-dep-en.sh
screen -dmS DEPFull /Library/Application\ Support/Purple/launch-dep-en.sh

echo Command: DeterminateManualStep: 2 >> /var/tmp/depnotify.log

echo Status: Creating System Report >> /var/tmp/depnotify.log
mkdir -p /Library/Application\ Support/Purple/Diagnostics/
mkdir -p "/Library/Application Support/Purple/Diagnostics/$dt/"
mkdir -p "/Library/Application Support/Purple/Diagnostics/$dt/DiagnosticReports"

echo Command: DeterminateManualStep: 3 >> /var/tmp/depnotify.log

system_profiler >> "/Library/Application Support/Purple/Diagnostics/$dt/system_report.$host.$dt.txt"
sleep 3s

echo Command: DeterminateManualStep: 4 >> /var/tmp/depnotify.log

echo Status: Copying Log Files >> /var/tmp/depnotify.log
sleep 5s
cp -r ~/Library/Logs/DiagnosticReports/* "/Library/Application Support/Purple/Diagnostics/$dt/DiagnosticReports"
#MORE TO BE ADDED

echo Command: DeterminateManualStep: 5 >> /var/tmp/depnotify.log

echo Status: Zipping Diagnostics Info >> /var/tmp/depnotify.log
sleep 5s
zip -r "/Library/Application Support/Purple/Diagnostics/"Diagnostics.$host.$dt.zip "/Library/Application Support/Purple/Diagnostics/$dt/"

echo Command: DeterminateManualStep: 6 >> /var/tmp/depnotify.log

echo Status: Sending Diagnotics to Purple Helpdesk >> /var/tmp/depnotify.log
sleep 20s

echo Command: DeterminateManualStep: 7 >> /var/tmp/depnotify.log

echo Status: Once you have completed the above ticket request please click finished. >> /var/tmp/depnotify.log

#rm -rf /tmp/brandDEPinstall.sh
# END SCRIPT WITH SUCCESS
exit 0


