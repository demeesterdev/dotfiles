#! /bin/sh
# shellcheck disable=SC2155 # ignoring as it is a profile script

export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
gpgconf --launch gpg-agent

if ! pgrep -x -u "${USER}" gpg-agent > /dev/null 2>&1 ; then
        gpg-connect-agent updatestartuptty /bye > /dev/null 2>&1
fi

if [ -f "${HOME}/.gpg-agent-info" ]; then
    # shellcheck source=/dev/null
    . "${HOME}/.gpg-agent-info"
    export GPG_AGENT_INFO
    export SSH_AUTH_SOCK
fi
