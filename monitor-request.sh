#!/bin/bash

# Create a folder named log on the Desktop
LOG_DIR="$HOME/Desktop/log"
mkdir -p "$LOG_DIR"

# Path for the monitoring log file
LOG_FILE="$LOG_DIR/monitor.log"

# Specify the port number to listen on
PORT=8080

# Function to monitor incoming requests with TCPDump and write to the log file
function monitor_requests() {
    echo "Monitoring Application Started..." > "$LOG_FILE"
    echo "--------------------------------------" >> "$LOG_FILE"

    # Start tcpdump in the background and redirect output to a temp file
    sudo tcpdump -i any -s 0 -A -l "port $PORT" > "$LOG_FILE.tmp" &

    # Get the PID of the tcpdump process
    TCPDUMP_PID=$!

    # Monitor the temp log file for new lines
    while true; do
        # Read new lines from the temp log file
        while IFS= read -r line; do
            echo "$line" >> "$LOG_FILE"

            # Check if the line contains an HTTP request
            if [[ "$line" == *"HTTP/"* ]]; then
                echo "New HTTP Request:" >> "$LOG_FILE"
                echo "$line" >> "$LOG_FILE"

                # Start time measurement for the request response time
                start_time=$(date +%s)  # Get current time in nanoseconds

                # Simulate waiting for the request to be processed
                sleep 1  # Replace this with actual processing logic if needed

                # Calculate the response time for the request
                end_time=$(date +%s)  # Get current time in nanoseconds
                response_time=$(( (end_time - start_time) / 1000000 ))  # Convert nanoseconds to milliseconds

                # Log the response time
                echo "Response Time: ${response_time} ms" >> "$LOG_FILE"

                # Log the memory usage after the response has been returned
                memory_usage=$(ps -o rss= -p $(pgrep -f 'java -jar your-spring-boot-app.jar'))
                echo "Memory Used: $((memory_usage / 1024)) MB" >> "$LOG_FILE"
                echo "--------------------------------------------------" >> "$LOG_FILE"
            fi
        done < "$LOG_FILE.tmp"

        # Check if tcpdump process is still running
        if ! ps -p $TCPDUMP_PID > /dev/null; then
            echo "TCPDump process has stopped." >> "$LOG_FILE"
            break
        fi
    done

    # Cleanup temporary log file
    rm -f "$LOG_FILE.tmp"
}

# Run the monitoring function
monitor_requests
