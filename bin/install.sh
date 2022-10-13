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
            readonly TARGET_UID=$(getent passwd "$TARGET_USER" | cut -d: -f3)
            readonly TARGET_HOME=$(getent passwd "$TARGET_USER" | cut -d: -f6)
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
        man-db \
        adduser \
        bash-completion \
        coreutils \
        ca-certificates \
        curl \
        wget \
        findutils \
        grep \
        hostname \
        git \
        gnupg \
        gnupg2 \
        make \
        dnsutils \
        iptables \
        jq \
        less \
        lsof \
        mount \
        net-tools \
        silversearcher-ag \
        ssh \
        strace \
        sudo \
        tar \
        tree \
        unzip \
        xz-utils \
        zip \
        vim \
        --no-install-recommends

    apt autoremove -y
    apt autoclean -y
    apt clean -y
}

install_bw_cli() {
    export HOME=$TARGET_HOME
    TMP_DIR=$(mktemp -d)
    ZIPNAME=bw.zip
    EXENAME=bw

    # download and unzip binary
    curl -sSL 'https://vault.bitwarden.com/download/?app=cli&platform=linux' -o "${TMP_DIR}/${ZIPNAME}"
    unzip -qq -d "${TMP_DIR}" "${TMP_DIR}/${ZIPNAME}"

    #move binary and make executable
    chmod +x "${TMP_DIR}/${EXENAME}"
    mkdir -m 700 -p "${HOME}/bin"
    mv "${TMP_DIR}/${EXENAME}" "${HOME}/bin"

}

install_node() {
	curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add -

	# FROM: https://github.com/nodesource/distributions/blob/master/README.md
	# Replace with the branch of Node.js or io.js you want to install: node_6.x,
	# node_8.x, etc...
	VERSION=node_14.x
	# The below command will set this correctly, but if lsb_release isn't available, you can set it manually:
	# - For Debian distributions: jessie, sid, etc...
	# - For Ubuntu distributions: xenial, bionic, etc...
	# - For Debian or Ubuntu derived distributions your best option is to use
	# the codename corresponding to the upstream release your distribution is
	# based off. This is an advanced scenario and unsupported if your
	# distribution is not listed as supported per earlier in this README.
	DISTRO="$(lsb_release -s -c)"
	echo "deb https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee /etc/apt/sources.list.d/nodesource.list
	echo "deb-src https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee -a /etc/apt/sources.list.d/nodesource.list

	sudo apt update || true
	sudo apt install -y \
		nodejs \
		--no-install-recommends
}

get_dotfiles() {
    # create subshell
    
    (   
        export HOME=$TARGET_HOME
        cd "$HOME"

        RESET=0
        if [[ ! -d "${HOME}/dotfiles" ]]; then
        # install dotfiles from repo
            git clone https://github.com/demeesterdev/dotfiles.git "${HOME}/dotfiles"
        else
            RESET=1
        fi

        cd "${HOME}/dotfiles"

        if [[ RESET == 1 ]]; then
            git fetch
            git reset .
            git clean -df
            git checkout -- .
            git checkout origin/main
        fi
        # installs all the things
        make
    )
}

reset_dotfiles_owner() {
    if [ "$EUID" -eq 0 ]; then
        find $TARGET_HOME ! -user $TARGET_USER -exec chown -h $TARGET_USER. {} \;
    fi
}



usage() {
    echo -e "install.sh\\n\\tThis script installs my basic setup for a debian laptop\\n"
    echo "Usage:"
    echo "  basemin                             - install base min pkgs"
    echo "  dotfiles                            - install dotfiles on system"
    echo "  fresh                               - install and configure dotfiles on a new machine"
    echo "  bw                                  - install bitwarden cli"
    echo "  node                                - install node"
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
        reset_dotfiles_owner
    elif [[ $cmd == "bw" ]]; then
        get_user
        install_bw_cli
        reset_dotfiles_owner
    elif [[ $cmd == "fresh" ]]; then
        check_is_sudo
        echo
        echo "gathering Info..."
        echo
        get_user
        echo "Using user account: ${TARGET_USER}"
        echo "             UID  : ${TARGET_UID}"
        echo "             home : ${TARGET_HOME}"

        #install packages
        echo
        echo "Installing base packages..."
        echo
        base_min

        #install dev tools
        echo
        echo "Installing tools"
        echo 
        echo "  - bitwardenCLI"
        install_bw_cli

        #install dotfiles
        echo
        echo "Installing dotfiles..."
        echo
        get_dotfiles
        reset_dotfiles_owner
    else
        usage
    fi
}

main "$@"
