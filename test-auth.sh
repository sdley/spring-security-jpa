#!/bin/bash

# Color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=================================="
echo "Spring Security JPA - Auth Tests"
echo "=================================="
echo ""

# Check if app is running
echo "Checking if application is running..."
if ! curl -s http://localhost:8080/ > /dev/null 2>&1; then
    echo -e "${RED}❌ Application is not running!${NC}"
    echo "Please start the application first:"
    echo "  ./mvnw spring-boot:run"
    exit 1
fi
echo -e "${GREEN}✅ Application is running${NC}"
echo ""

# Test 1: Public endpoint
echo "Test 1: Public endpoint (no auth)..."
RESPONSE=$(curl -s http://localhost:8080/)
if echo "$RESPONSE" | grep -q "Welcome"; then
    echo -e "${GREEN}✅ PASS${NC} - Public endpoint accessible"
else
    echo -e "${RED}❌ FAIL${NC} - Public endpoint not accessible"
fi
echo ""

# Test 2: Protected endpoint without credentials
echo "Test 2: Protected endpoint (no credentials)..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/user)
if [ "$HTTP_CODE" = "401" ] || [ "$HTTP_CODE" = "302" ]; then
    echo -e "${GREEN}✅ PASS${NC} - Unauthorized access rejected (HTTP $HTTP_CODE)"
else
    echo -e "${RED}❌ FAIL${NC} - Expected 401/302, got HTTP $HTTP_CODE"
fi
echo ""

# Test 3: User authentication
echo "Test 3: User authentication (user:password)..."
RESPONSE=$(curl -s -u user:password http://localhost:8080/user)
if echo "$RESPONSE" | grep -q "Welcome User"; then
    echo -e "${GREEN}✅ PASS${NC} - User authentication successful"
else
    echo -e "${RED}❌ FAIL${NC} - User authentication failed"
    echo "Response: $RESPONSE"
fi
echo ""

# Test 4: Admin authentication
echo "Test 4: Admin authentication (admin:admin)..."
RESPONSE=$(curl -s -u admin:admin http://localhost:8080/admin)
if echo "$RESPONSE" | grep -q "Welcome Admin"; then
    echo -e "${GREEN}✅ PASS${NC} - Admin authentication successful"
else
    echo -e "${RED}❌ FAIL${NC} - Admin authentication failed"
    echo "Response: $RESPONSE"
fi
echo ""

# Test 5: Wrong credentials
echo "Test 5: Invalid credentials (user:wrongpassword)..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -u user:wrongpassword http://localhost:8080/user)
if [ "$HTTP_CODE" = "401" ]; then
    echo -e "${GREEN}✅ PASS${NC} - Invalid credentials rejected (HTTP 401)"
else
    echo -e "${RED}❌ FAIL${NC} - Expected 401, got HTTP $HTTP_CODE"
fi
echo ""

# Test 6: Authorization - user trying to access admin
echo "Test 6: Authorization check (user trying /admin)..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -u user:password http://localhost:8080/admin)
if [ "$HTTP_CODE" = "403" ]; then
    echo -e "${GREEN}✅ PASS${NC} - Authorization enforced (HTTP 403)"
else
    echo -e "${RED}❌ FAIL${NC} - Expected 403, got HTTP $HTTP_CODE"
fi
echo ""

# Test 7: Admin can access user endpoint
echo "Test 7: Admin accessing user endpoint..."
RESPONSE=$(curl -s -u admin:admin http://localhost:8080/user)
if echo "$RESPONSE" | grep -q "Welcome User"; then
    echo -e "${GREEN}✅ PASS${NC} - Admin can access user endpoint"
else
    echo -e "${RED}❌ FAIL${NC} - Admin cannot access user endpoint"
fi
echo ""

echo "=================================="
echo "Test Suite Complete"
echo "=================================="

