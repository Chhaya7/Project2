#!/bin/bash

# Web server log file (e.g., /var/log/nginx/access.log or /var/log/apache2/access.log)
LOG_FILE=$1

# Check if log file is provided
if [ -z "$LOG_FILE" ]; then
  echo "Usage: $0 /path/to/webserver/logfile"
  exit 1
fi

# Check if file exists
if [ ! -f "$LOG_FILE" ]; then
  echo "Log file not found!"
  exit 1
fi

# Generate report header
echo "Analyzing log file: $LOG_FILE"
echo "======================================="
echo ""

# 1. Count the number of 404 errors
echo "Number of 404 errors:"
grep " 404 " $LOG_FILE | wc -l
echo ""

# 2. List the top 10 most requested pages (URLs)
echo "Top 10 most requested pages (URLs):"
awk '{print $7}' $LOG_FILE | sort | uniq -c | sort -nr | head -10
echo ""

# 3. List the top 10 IP addresses with the most requests
echo "Top 10 IP addresses with the most requests:"
awk '{print $1}' $LOG_FILE | sort | uniq -c | sort -nr | head -10
echo ""

# 4. Count total number of requests
echo "Total number of requests:"
wc -l $LOG_FILE | awk '{print $1}'
echo ""

# 5. List the top 10 referrers (sites that directed traffic)
echo "Top 10 referrers:"
awk -F\" '{print $4}' $LOG_FILE | grep -v '-' | sort | uniq -c | sort -nr | head -10
echo ""

# 6. List the top 10 user agents
echo "Top 10 User Agents:"
awk -F\" '{print $6}' $LOG_FILE | sort | uniq -c | sort -nr | head -10
echo ""

# End of report
echo "Log analysis complete."
