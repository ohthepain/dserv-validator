#!/bin/bash
# Test PQS connectivity from nginx container

echo "Testing PQS connectivity from nginx container..."
echo ""

# Test with verbose output
echo "=== Full curl output ==="
docker compose exec -T nginx curl -v http://pqs:8080/livez 2>&1
echo ""

# Also test with timeout to see if it hangs
echo "=== Testing with timeout ==="
timeout 5 docker compose exec -T nginx curl -s http://pqs:8080/livez 2>&1 || echo "Timeout or connection failed"
echo ""

echo "=== Checking if PQS container is accessible ==="
docker compose exec -T nginx ping -c 1 pqs 2>&1 | head -3


