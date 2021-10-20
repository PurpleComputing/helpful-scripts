#!/bin/bash
dt=$(date '+%d%m%Y.%H%M%S');
pid=$(ps aux | grep 'rmSBMBv2' | grep -v 'grep' | awk '{print$2}');
touch /tmp/rename-kill.log
echo Pause Entry $dt: Pausing $pid >> /tmp/rename-kill.log
kill -SIGSTOP $pid  >> /tmp/rename-kill.log
echo Pause Entry $dt: Finished >> /tmp/rename-kill.log