#! /bin/sh
# shellcheck disable=SC2155 # ignoring as it is a profile script
path_append ()  {
    if [ -d "$1" ]; then
      path_remove "$1"
      export PATH="$PATH:$1"
    fi
}

path_prepend ()  {
    if [ -d "$1" ]; then
      path_remove "$1"
      export PATH="$1:$PATH"
    fi
}

path_remove ()  {
    export PATH="$( printf '%s' ":$PATH:" | sed "s#:$REMOVE:#:#g" | sed 's/^://' | sed 's/:$//'  )";
}

path_prepend "/opt/local/sbin"
path_prepend "/opt/local/bin"
path_prepend "$HOME/.local/bin"
path_prepend "$HOME/go/bin"
path_prepend "$HOME/bin"
path_prepend "${KREW_ROOT:-$HOME/.krew}/bin"

path_append "/usr/local/go/bin"
