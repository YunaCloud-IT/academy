#!/bin/bash

# Configuration
URL="http://34.110.236.67/api/districts"
TOTAL_REQUESTS=5000
CONCURRENT_DELAY=0.1 # Seconds between requests

echo "Starting rate limit test against $URL"
echo "------------------------------------------------"

for ((i=1; i<=TOTAL_REQUESTS; i++)); do
    # -o /dev/null hides the response body
    # -s silent mode
    # -w extracts the HTTP status code
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$URL")

    echo "Request $i: HTTP $STATUS"

    # Optional: adds a tiny delay to avoid crashing your local socket
    # sleep $CONCURRENT_DELAY
done

echo "------------------------------------------------"
echo "Test Complete."
