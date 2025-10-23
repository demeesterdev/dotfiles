#! /bin/sh
ANDROID_HOME=$HOME/Library/Android/sdk
if [ -d "$ANDROID_HOME" ]; then
    export ANDROID_HOME
    export PATH="$PATH:$ANDROID_HOME/platform-tools"
fi

if [ -e "/usr/libexec/java_home" ]; then
    JAVA_HOME="$(/usr/libexec/java_home -v "17" 2>/dev/null)"
    if [ -z "${JAVA_HOME}" ]; then
        unset JAVA_HOME
    else
    export JAVA_HOME;
    fi
fi
