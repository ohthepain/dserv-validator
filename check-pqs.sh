#!/bin/bash
# Diagnostic script to check PQS connectivity and firewall

echo "🔍 Checking PQS connectivity and firewall status..."
echo ""

# Check if PQS container is running
echo "1. Checking PQS container status..."
if docker compose ps pqs | grep -q "Up"; then
    echo "   ✅ PQS container is running"
    docker compose ps pqs | grep pqs
else
    echo "   ❌ PQS container is NOT running"
    echo "   Run: docker compose up -d pqs"
fi
echo ""

# Check PQS logs for errors
echo "2. Checking recent PQS logs for errors..."
if docker compose logs --tail=20 pqs 2>&1 | grep -i "error\|exception\|failed" > /dev/null; then
    echo "   ⚠️  Found errors in logs:"
    docker compose logs --tail=20 pqs 2>&1 | grep -i "error\|exception\|failed" | head -5
else
    echo "   ✅ No obvious errors in recent logs"
fi
echo ""

# Check if port 9000 is listening
echo "3. Checking if port 9000 is listening..."
if sudo netstat -tlnp 2>/dev/null | grep -q ":9000" || sudo ss -tlnp 2>/dev/null | grep -q ":9000"; then
    echo "   ✅ Port 9000 is listening"
    sudo netstat -tlnp 2>/dev/null | grep ":9000" || sudo ss -tlnp 2>/dev/null | grep ":9000"
else
    echo "   ❌ Port 9000 is NOT listening"
fi
echo ""

# Check firewall status
echo "4. Checking firewall status..."
if command -v ufw > /dev/null; then
    if sudo ufw status | grep -q "Status: active"; then
        echo "   ⚠️  Firewall is ACTIVE"
        echo "   Checking if port 9000 is allowed:"
        if sudo ufw status | grep -q "9000"; then
            sudo ufw status | grep "9000"
        else
            echo "   ⚠️  Port 9000 is NOT explicitly allowed in firewall"
            echo "   However, firewall shouldn't block localhost connections"
        fi
    else
        echo "   ✅ Firewall is inactive (not blocking)"
    fi
else
    echo "   ℹ️  ufw not installed, checking iptables..."
    if sudo iptables -L -n | grep -q "9000"; then
        echo "   Found rules for port 9000:"
        sudo iptables -L -n | grep "9000"
    else
        echo "   ℹ️  No explicit rules for port 9000"
    fi
fi
echo ""

# Test connectivity from inside container
echo "5. Testing PQS from inside container..."
if docker compose exec -T pqs curl -s http://localhost:8080/livez 2>&1 | head -1 | grep -q "ok\|status"; then
    echo "   ✅ PQS responds from inside container"
    docker compose exec -T pqs curl -s http://localhost:8080/livez
else
    echo "   ❌ PQS does NOT respond from inside container"
    echo "   Response:"
    docker compose exec -T pqs curl -s http://localhost:8080/livez 2>&1 | head -3
fi
echo ""

# Test connectivity from host
echo "6. Testing PQS from host (localhost:9000)..."
if curl -s http://localhost:9000/livez 2>&1 | head -1 | grep -q "ok\|status"; then
    echo "   ✅ PQS responds from host"
    curl -s http://localhost:9000/livez
else
    echo "   ❌ PQS does NOT respond from host"
    echo "   Error: $(curl -s http://localhost:9000/livez 2>&1 | head -1)"
fi
echo ""

# Test via nginx proxy
echo "7. Testing PQS via nginx proxy..."
if curl -s http://localhost/livez -H "Host: pqs.localhost" 2>&1 | head -1 | grep -q "ok\|status"; then
    echo "   ✅ PQS responds via nginx proxy"
    curl -s http://localhost/livez -H "Host: pqs.localhost"
else
    echo "   ⚠️  PQS does NOT respond via nginx proxy"
    echo "   (nginx might need restart or config update)"
fi
echo ""

echo "📋 Summary:"
echo "   - If container is running but localhost:9000 fails: PQS is binding to 127.0.0.1"
echo "   - Solution: Use nginx proxy (http://pqs.localhost/livez) or configure PQS to bind to 0.0.0.0"
echo "   - If firewall is blocking: Add: sudo ufw allow 9000/tcp"

