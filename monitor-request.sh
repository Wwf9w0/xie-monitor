#!/bin/bash

LOG_DIR="$HOME/Desktop/log"
mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/monitor.log"

PORT=8080

function monitor_requests() {
    echo "Monitoring Application Started..." > "$LOG_FILE"
    echo "--------------------------------------" >> "$LOG_FILE"

    sudo tcpdump -i any -s 0 -A -l "port $PORT" > "$LOG_FILE.tmp" &

    TCPDUMP_PID=$!

    while true; do
        while IFS= read -r line; do
            echo "$line" >> "$LOG_FILE"

            if [[ "$line" == *"HTTP/"* ]]; then
                echo "New HTTP Request:" >> "$LOG_FILE"
                echo "$line" >> "$LOG_FILE"

                start_time=$(date +%s)  
                sleep 1  
                end_time=$(date +%s)  # 
                response_time=$(( (end_time - start_time) / 1000000 ))

        
                echo "Response Time: ${response_time} ms" >> "$LOG_FILE"

                memory_usage=$(ps -o rss= -p $(pgrep -f 'java -jar your-spring-boot-app.jar'))
                echo "Memory Used: $((memory_usage / 1024)) MB" >> "$LOG_FILE"
                echo "--------------------------------------------------" >> "$LOG_FILE"
            fi
        done < "$LOG_FILE.tmp"

        if ! ps -p $TCPDUMP_PID > /dev/null; then
            echo "TCPDump process has stopped." >> "$LOG_FILE"
            break
        fi
    done

    rm -f "$LOG_FILE.tmp"
}

monitor_requests
