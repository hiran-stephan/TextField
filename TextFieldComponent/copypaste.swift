{
  "aps": {
    "alert": { "title": "Fraud alert", "body": "Tap to review activity" },
    "sound": "default",
    "badge": 1
  },
  "channelId": "FRAUDALERT",
  "apns-push-type": "alert"
}

xcrun simctl push booted com.cibc.enterprise.CIBC /path/payload-alert.json


