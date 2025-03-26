#!/bin/bash
PROCESS_NAME="test"
LOG_FILE="/var/log/monitoring.log"
MONITOR_URL="https://test.com/monitoring/test/api"
if pgrep -x "$PROCESS_NAME" > /dev/null; then
    if [ ! -f /tmp/test_process_pid ]; then
        echo $$ > /tmp/test_process_pid
    else
        PREV_PID=$(cat /tmp/test_process_pid)
        if ! ps -p $PREV_PID > /dev/null; then
            echo "$(date): Process '$PROCESS_NAME' was restarted." >> $LOG_FILE
            echo $$ > /tmp/test_process_pid
        fi
    fi
    if ! curl -s --head --request GET "$MONITOR_URL" | grep "200 OK" > /dev/null; then
        echo "$(date): Monitoring server not reachable." >> $LOG_FILE
    else
        curl -s "$MONITOR_URL" > /dev/null
    fi
fi
