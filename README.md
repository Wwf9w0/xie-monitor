# xie-monitor
this application is a monitoring tool application running on a specified port(8080)

# Before running
chmod +x build-deploy.sh

# Project Description

This application is a monitoring tool designed to observe and log incoming HTTP requests to a Spring Boot application running on a specified port. The key functionalities include:

Real-time Request Monitoring: The tool uses tcpdump to capture all incoming network traffic on a designated port, enabling it to log details about every HTTP request received by the application.

Response Time Calculation: For each request, the application records the response time, simulating a processing period to reflect how long it takes to handle each request. This information helps in understanding the performance of the application.

Memory Usage Tracking: After processing each request, the tool checks and logs the memory usage of the Spring Boot application, providing insights into how much RAM is consumed during request handling.

Log File Generation: All monitored data, including the details of the requests, response times, and memory usage, are written to a log file stored in a user-defined directory on the Desktop. This allows for easy access and review of the application's performance over time.
