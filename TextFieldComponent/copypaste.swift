nano ~/.zshrc

export PATH=$PATH:$HOME/Library/Android/sdk/platform-tools


source ~/.zshrc

adb devices


adb shell settings put global http_proxy 10.0.0.142:9090

adb shell settings put global http_proxy :0
