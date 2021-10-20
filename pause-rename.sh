#!/bin/bash
dt=$(date '+%d%m%Y.%H%M00');
pid=$(ps aux | grep 'rmSBMBv2' | grep -v 'grep' | awk '{print$2}'
echo Kill Entry $dt: Killing $pid >> /tmp/rename-kill.log
kill -SIGSTOP $pid  >> /tmp/rename-kill.log
echo Kill Entry $dt: Finished >> /tmp/rename-kill.log