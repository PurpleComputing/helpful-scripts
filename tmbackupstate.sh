#!/bin/sh
#WARNINGDAYS=14
#CRITICALDAYS=30
enabled=$(/usr/bin/defaults read /Library/Preferences/com.apple.TimeMachine AutoBackup)
	if [ "$enabled" == "1" ];then
		datetoday=$(date +%s)
		lastBackupTimestamp=`date -j -f "%a %b %d %T %Z %Y" "$(/usr/libexec/PlistBuddy -c "Print Destinations:0:SnapshotDates" /Library/Preferences/com.apple.TimeMachine.plist | tail -n 2 | head -n 1 | awk '{$1=$1};1')" "+%s"`
		difference=$(($datetoday-$lastBackupTimestamp))
		TMDAYSSINCE=$(($difference/(3600*24)))
		if (( $TMDAYSSINCE > $WARNINGDAYS ));
			then
                if (( $TMDAYSSINCE > $CRITICALDAYS ));
					then
                        TMBACKUPSTATE="CRITICAL"
					else
                        TMBACKUPSTATE="Warning"
				fi;
			else
                 TMBACKUPSTATE="COMPLIANT"
		fi;
	else
		TMBACKUPSTATE="Warning"
	fi
    
echo $TMBACKUPSTATE >> /tmp/TMBACKUPSTATE.check
