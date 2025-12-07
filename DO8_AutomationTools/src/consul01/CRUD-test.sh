#!/bin/bash

API_URL="http://localhost:8082/hotels"
TEST_HOTEL_UID="test-hotel-123"

echo "=== CREATE Hotel ==="
CREATE_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST $API_URL \
-H "Content-Type: application/json" \
-d '{
  "name": "Test Hotel Script",
  "address": "Test Street 2",
  "rooms": 60,
  "cost": 1600.0
}')
echo "Create response code: $CREATE_RESPONSE"
echo

echo "=== READ all Hotels ==="
curl -s $API_URL | jq
echo

echo "=== UPDATE Hotel ==="
UPDATE_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X PUT "$API_URL/$TEST_HOTEL_UID" \
-H "Content-Type: application/json" \
-d '{
  "rooms": 70,
  "cost": 1700.0,
  "name": "Test Hotel Script Updated",
  "address": "Test Street 2"
}')
echo "Update response code: $UPDATE_RESPONSE"
echo

echo "=== DELETE Hotel ==="
DELETE_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE "$API_URL/$TEST_HOTEL_UID")
echo "Delete response code: $DELETE_RESPONSE"
echo
