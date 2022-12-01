#!/bin/bash
# WORK IN PROGRESS

AUDITORNAME="Michael Tanner"
REPORTFILE="report.log"
LOGFILE="audit.log"
LOGDIR="/tmp/PurpleAudit/Log"
REPORTOUTPUT=/Users/$(stat -f "%Su" /dev/console)/Desktop/MacReport.rtf

export AUDITORNAME LOGDIR LOGFILE REPORTFILE

mkdir -p /tmp/PurpleAudit
mkdir -p /tmp/PurpleAudit/Log

cd /tmp/PurpleAudit

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install git


git clone https://github.com/CISOfy/lynis
cd lynis
./lynis audit system -Q --auditor="$AUDITORNAME" >> $REPORTOUTPUT

chmod 777 /var/log/lynis-report.dat
chmod 777 $REPORTOUTPUT
