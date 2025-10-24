xcode-select -p

/Applications/Xcode.app/Contents/Developer

sudo xcode-select --install

sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

xcrun simctl list

xcrun simctl push booted com.cibc.enterprise.CIBC /Users/Stephan/Documents/Payload.apns

--------------------------------------

ls -1 /Applications | grep -i xcode

# If it's the normal App Store Xcode:
sudo xcode-select -s "/Applications/Xcode.app/Contents/Developer"

# If it’s a differently named app, adjust the path, e.g.:
# sudo xcode-select -s "/Applications/Xcode 16.app/Contents/Developer"
# or
# sudo xcode-select -s "/Applications/Xcode-beta.app/Contents/Developer"


xcode-select -p
xcrun -f simctl
xcrun simctl list


xcrun simctl push booted com.cibc.enterprise.CIBC /Users/Stephan/Documents/Payload.apns


