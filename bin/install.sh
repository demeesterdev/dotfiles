#!/bin/bash
set -e
set -o pipefail

# install.sh
#   This script installs necesarry tools for my debian shells

export DEBIAN_FRONTEND=noninteractive

# Choose a user account to use for this installation
get_user() {
	if [[ -z "${TARGET_USER-}" ]]; then
		mapfile -t options < <(find /home/* -maxdepth 0 -printf "%f\\n" -type d)
		# if there is only one option just use that user
		if [ "${#options[@]}" -eq "1" ]; then
			readonly TARGET_USER="${options[0]}"
			echo "Using user account: ${TARGET_USER}"
			return
		fi

		# iterate through the user options and print them
		PS3='command -v user account should be used? '

		select opt in "${options[@]}"; do
			readonly TARGET_USER=$opt
            readonly TARGET_UID=$(getent passwd "$TARGET_USER" | cut -d: -f3)
            readonly TARGET_HOME=$(getent passwd "$TARGET_USER" | cut -d: -f6)
			break
		done
	fi
}

check_is_sudo() {
	if [ "$EUID" -ne 0 ]; then
		echo "Please run as root."
		exit
	fi
}

base_min() {
	apt update || true
	apt -y upgrade

	apt install -y \
        ca-certificates \
        git \
		make \
		--no-install-recommends

	apt autoremove -y
	apt autoclean -y
	apt clean -y
}

get_dotfiles() {
    # create subshell
    (   
        cd "$HOME"

        if [[ ! -d "${HOME}/.dotfiles" ]]; then
		# install dotfiles from repo
		    git clone https://github.com/demeesterdev/dotfiles.git "${HOME}/.dotfiles"
	    fi

        cd "${HOME}/.dotfiles"

	    # set the correct origin
	    git remote set-url origin git@github.com:demeesterdev/dotfiles.git

	    # installs all the things
	    make
    )
}



usage() {
	echo -e "install.sh\\n\\tThis script installs my basic setup for a debian laptop\\n"
	echo "Usage:"
	echo "  basemin                             - install base min pkgs"
	echo "  dotfiles                            - install dotfiles on system"
    echo "  fresh                               - install and configure dotfiles on a new machine"
}

main() {
    local cmd=$1

    if [[ -z "$cmd" ]]; then
        usage
        exit 1
    fi

    if [[ $cmd == "basemin" ]]; then
        check_is_sudo
        base_min
    elif [[ $cmd == "dotfiles" ]]; then
        get_user
        get_dotfiles
    elif [[ $cmd == "fresh" ]]; then
        check_is_sudo
        echo
	    echo "gathering Info..."
	    echo
        get_user

        #install packages
        echo
	    echo "Installing base packages..."
	    echo
        base_min

        #install dotfiles
        echo
	    echo "Installing dotfiles..."
	    echo
        export -f get_dotfiles 
        su $TARGET_USER -c 'bash -c get_dotfiles'
    else
		usage
	fi
}

main "$@"