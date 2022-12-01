#!/bin/bash
# WORK IN PROGRESS

AUDITORNAME="Michael Tanner"
REPORTFILE="report.log"
LOGFILE="audit.log"
LOGDIR="/tmp/PurpleAudit/Log"
REPORTOUTPUT=/Users/$(stat -f "%Su" /dev/console)/Desktop/MacReport.txt

rm -f $REPORTOUTPUT
export AUDITORNAME LOGDIR LOGFILE REPORTFILE

mkdir -p /tmp/PurpleAudit
mkdir -p /tmp/PurpleAudit/Log

cd /tmp/PurpleAudit

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install git
brew install python@3.8

git clone https://github.com/CISOfy/lynis
cd lynis
sudo ./lynis audit system -Q --auditor "$AUDITORNAME" >> $REPORTOUTPUT
sudo ./lynis audit system --pentest --auditor "$AUDITORNAME" >> $REPORTOUTPUT
sudo chmod 777 /var/log/lynis-report.dat
sudo chmod 777 $REPORTOUTPUT
sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/PurpleComputing/helpful-scripts/main/SecScripts/test-lockdown.sh)"

