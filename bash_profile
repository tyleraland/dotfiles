# ~/.bash_profile: executed by bash(1) for login-shells.

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
export PATH=$BRAZIL_CLI_BIN:$PATH
export JAVA_HOME=$(/usr/libexec/java_home)
#export ANDROID_HOME=/usr/local/opt/android-sdk
export ANDROID_HOME=/Users/ttyll/Library/Android/sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
export XCODE_HOME=/Applications/Xcode.app/Contents/Developer
