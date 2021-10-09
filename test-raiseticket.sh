dt=$(date '+%d%m%Y.%H%M00');
host=$('hostname');
user=$('whoami');
key=$(cat '/Library/Application Support/Purple/.purplediagnose');
zippass=$(cat '/Library/Application Support/Purple/.purplez');

SMTPSRV=$(cat '/Library/Application Support/Purple/.SMTP/.smtpserver');
SMTPAUTH=$(cat '/Library/Application Support/Purple/.SMTP/.smtplogin');
SMTPFROM=$(cat '/Library/Application Support/Purple/.SMTP/.smtpfrom');
SMTPTO=$(cat '/Library/Application Support/Purple/.SMTP/.smtpto');
SMTPMSG="/Users/Shared/.Purple/Diagnostics/.mailhead.txt"

echo Command: WindowStyle: Activate >> /var/tmp/depnotify.log
echo Command: WindowTitle: Create a Support Ticket >> /var/tmp/depnotify.log
echo Command: MainTitle: Create a Support Ticket >> /var/tmp/depnotify.log
echo 'Command: Image: /Library/Application Support/Purple/logo.png' >> /var/tmp/depnotify.log
echo Command: MainText: In a few moments our support ticket form will open in Safari, please complete the form and provide as much information as possible. Whilst you are completing the form your Mac will upload diagnostic information to our Help Desk. You can hide this window as you will continue to get notifications. >> /var/tmp/depnotify.log
echo Status: Loading form... Thank you. >> /var/tmp/depnotify.log

# START DEPNOTIFY
curl -o /Users/Shared/.Purple/launch-dep.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/launch-dep.sh
chmod +x /Users/Shared/.Purple/launch-dep.sh
/Users/Shared/.Purple/launch-dep.sh

echo Command: WindowTitle: Create a Support Ticket >> /var/tmp/depnotify.log
echo Command: MainTitle: Create a Support Ticket >> /var/tmp/depnotify.log

sleep 6s

open -a safari http://purplecomputing.com/support

#echo Command: Website: https://www.cognitoforms.com/PurpleComputingLimited/SupportRequestForm >> /var/tmp/depnotify.log
echo Command: DeterminateManual: 5 >> /var/tmp/depnotify.log
echo Command: NotificationOn: >> /var/tmp/depnotify.log

echo Command: ContinueButton: Hide >> /var/tmp/depnotify.log

echo Status: Creating System Report, estimated time: 5 minutes >> /var/tmp/depnotify.log
rm -rf /Users/Shared/.Purple/Diagnostics/*
mkdir -p "/Users/Shared/.Purple/Diagnostics/"
mkdir -p "/Users/Shared/.Purple/Diagnostics/$dt/"
mkdir -p "/Users/Shared/.Purple/Diagnostics/$dt/DiagnosticReports"

system_profiler >> "/Users/Shared/.Purple/Diagnostics/$dt/system_report.$host.$dt.txt"
sleep 3s

#echo Command: DeterminateManualStep: 2 >> /var/tmp/depnotify.log

echo Status: Copying Log Files, estimated time: 4 minutes  >> /var/tmp/depnotify.log
sleep 5s
cp -r ~/Library/Logs/DiagnosticReports/* "/Users/Shared/.Purple/Diagnostics/$dt/DiagnosticReports"
defaults read /Library/Preferences/com.teamviewer.teamviewer.preferences.plist ClientID >> "/Users/Shared/.Purple/Diagnostics/$dt/teamviewerID.txt"
#MORE TO BE ADDED

echo Command: DeterminateManualStep: 2 >> /var/tmp/depnotify.log

echo Status: Zipping Diagnostics Info, estimated time: 3 minutes  >> /var/tmp/depnotify.log
cd "/Users/Shared/.Purple/Diagnostics/$dt/"
zip -er -P "$zippass" "/Users/Shared/.Purple/Diagnostics/"Diagnostics.$user.$host.$dt.zip .

echo Status: Uploading Diagnotics, estimated time: 2 minutes  >> /var/tmp/depnotify.log
rm -rf "/Users/Shared/.Purple/Diagnostics/"$dt.uploadurl.txt
curl --upload-file "/Users/Shared/.Purple/Diagnostics/"Diagnostics.$user.$host.$dt.zip https://purplediagnose-uk.keep.sh -H "Replace" >> "/Users/Shared/.Purple/Diagnostics/"$dt.uploadurl.txt

uploadurl=$(cat "/Users/Shared/.Purple/Diagnostics/$dt.uploadurl.txt");

echo Status: Sending Diagnotics to Purple Helpdesk Team, estimated time: 2 minutes  >> /var/tmp/depnotify.log

# REMOVE AND CREATE MESSAGE
rm -rf $SMTPMSG
echo "From: "Purple Diagnose" <$SMTPFROM>" >> $SMTPMSG
echo "To: "Purple Computing Team" <$SMTPTO>" >> $SMTPMSG
echo "Subject: Diagnostics for incoming ticket from $user" >> $SMTPMSG
echo "" >> $SMTPMSG
echo "Hi Purple Team," >> $SMTPMSG
echo "" >> $SMTPMSG
echo "A new file has been uploaded to: $uploadurl containing diagnostic information for $user on $host." >> $SMTPMSG
echo "" >> $SMTPMSG
echo "Warmest Regards," >> $SMTPMSG
echo "" >> $SMTPMSG
echo "Purple MDM Diagnostics Bot" >> $SMTPMSG
echo "" >> $SMTPMSG

curl --ssl-reqd \
  --url "$SMTPSRV" \
  --user "$SMTPAUTH" \
  --mail-from "$SMTPFROM" \
  --mail-rcpt "$SMTPTO" \
  --upload-file "$SMTPMSG"
  
echo Command: DeterminateManualStep: 4 >> /var/tmp/depnotify.log

echo Status: "Upload Finished. Once you have completed the ticket request please click 'Finished'." >> /var/tmp/depnotify.log
echo Command: ContinueButton: Finished >> /var/tmp/depnotify.log

# POST RUN CLEANUP
rm -rf "/Users/Shared/.Purple/Diagnostics/$dt/
rm -rf "/Users/Shared/.Purple/Diagnostics/*.zip

# END SCRIPT WITH SUCCESS
exit 0


