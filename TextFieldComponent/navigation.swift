{
  "accounts": [
    {
      "id": "123456789",
      "preferences": {
        "nickname": "My New Nickname"
      }
    }
  ]
}


curl -X PATCH "https://your-api-url.com/endpoint" \
-H "Content-Type: application/json" \
-H "Authorization: Bearer your-session-token" \
-d '{
  "accounts": [
    {
      "id": "123456789",
      "preferences": {
        "nickname": "My New Nickname"
      }
    }
  ]
}'
