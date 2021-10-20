#!/bin/bash
dt=$(date '+%d%m%Y.%H%M00');
pid=$(ps aux | grep 'rmSBMBv2' | grep -v 'grep' | awk '{print$2}');
touch /tmp/rename-kill.log
echo Resume Entry $dt: Resuming $pid >> /tmp/rename-kill.log
kill -SIGCONT $pid  >> /tmp/rename-kill.log
echo Resume Entry $dt: Finished >> /tmp/rename-kill.log