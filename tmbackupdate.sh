#!/bin/sh
rm -f /tmp/TMBACKUPDATE.check
enabled=`/usr/bin/defaults read /Library/Preferences/com.apple.TimeMachine AutoBackup`
if [ "$enabled" == "1" ];then
lastBackupTimestamp=`date -j -f "%a %b %d %T %Z %Y" "$(/usr/libexec/PlistBuddy -c "Print Destinations:0:SnapshotDates" /Library/Preferences/com.apple.TimeMachine.plist | tail -n 2 | head -n 1 | awk '{$1=$1};1')" "+%Y-%m-%d %H:%M:%S"`
echo Last Backup": $lastBackupTimestamp" >> /tmp/TMBACKUPDATE.check
else
echo "Time Machine is Disabled" >> /tmp/TMBACKUPDATE.check
fi
