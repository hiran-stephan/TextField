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


xcrun simctl privacy booted grant notifications com.cibc.enterprise.CIBC


{
  "aps": {
    "alert": { "title": "Fraud alert", "body": "Tap to review activity" },
    "sound": "default",
    "badge": 1,
    "interruption-level": "time-sensitive",   // helps bypass summary/focus
    "thread-id": "debug"
  },
  "channelId": "FRAUDALERT",
  "apns-push-type": "alert"
}
