
#!/bin/bash

# System Health Monitoring Script

# Thresholds
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80
PROCESS_THRESHOLD=300

LOG_FILE="./system-health.log"

# Logging function
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log_message "========== System Health Check Started =========="

# 1. CPU Usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}' | cut -d. -f1)

log_message "CPU Usage: ${CPU_USAGE}%"

if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
    log_message "ALERT: CPU usage is above ${CPU_THRESHOLD}%!"
fi

# 2. Memory Usage
MEMORY_USAGE=$(free | awk '/Mem:/ {printf "%.0f", ($3/$2)*100}')

log_message "Memory Usage: ${MEMORY_USAGE}%"

if [ "$MEMORY_USAGE" -gt "$MEMORY_THRESHOLD" ]; then
    log_message "ALERT: Memory usage is above ${MEMORY_THRESHOLD}%!"
fi

# 3. Disk Usage
DISK_USAGE=$(df / | awk 'NR==2 {gsub("%","",$5); print $5}')

log_message "Disk Usage: ${DISK_USAGE}%"

if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    log_message "ALERT: Disk usage is above ${DISK_THRESHOLD}%!"
fi

# 4. Running Processes
PROCESS_COUNT=$(ps -e --no-headers | wc -l)

log_message "Running Processes: ${PROCESS_COUNT}"

if [ "$PROCESS_COUNT" -gt "$PROCESS_THRESHOLD" ]; then
    log_message "ALERT: Process count is above ${PROCESS_THRESHOLD}!"
fi

log_message "========== System Health Check Completed =========="
