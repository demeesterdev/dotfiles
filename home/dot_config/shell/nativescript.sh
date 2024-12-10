#! /bin/sh
ANDROID_HOME=$HOME/Library/Android/sdk
if [ -d "$ANDROID_HOME" ]; then
    export ANDROID_HOME
    export PATH=$PATH:$ANDROID_HOME/platform-tools
fi

export JAVA_HOME=$(/usr/libexec/java_home -v"17");
