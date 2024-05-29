export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

if ! pgrep -x -u "${USER}" gpg-agent &> /dev/null; then
        gpg-connect-agent /bye &> /dev/null
fi