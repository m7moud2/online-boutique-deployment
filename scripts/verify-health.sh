#!/usr/bin/env bash
set -e

ENDPOINT="${1:-http://localhost:8080}"
echo "=========================================="
echo " Probing Online Boutique Service: $ENDPOINT"
echo "=========================================="

MAX_RETRIES=20
COUNT=0

until curl -s -f "$ENDPOINT" > /dev/null || [ $COUNT -eq $MAX_RETRIES ]; do
    echo "Waiting for Frontend service to become ready... ($COUNT/$MAX_RETRIES)"
    sleep 3
    COUNT=$((COUNT+1))
done

if [ $COUNT -eq $MAX_RETRIES ]; then
    echo "❌ Timeout waiting for $ENDPOINT"
    exit 1
fi

echo "✅ Frontend is responding successfully (HTTP 200)!"

# Verify expected page title
PAGE_CONTENT=$(curl -s "$ENDPOINT")
if echo "$PAGE_CONTENT" | grep -q "Online Boutique"; then
    echo "✅ Content verification passed: 'Online Boutique' rendered properly."
else
    echo "⚠️ Warning: 'Online Boutique' text not found in response payload."
fi

echo "=========================================="
echo " System Health Check Completed."
echo "=========================================="
