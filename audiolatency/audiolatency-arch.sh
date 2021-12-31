#!/bin/sh
############################
# DON'T USE YET, NOT DONE! #
############################
# This script should be continued after osu-install.sh

# If user executed this script as root, warn him.
[ "$USER" = "root" ] && printf "You can't execute this script as root.\n" && exit 1

## Functions
errorterminal() { # This one outputs error in terminal.
clear
printf '\e[31m%s\e[0m' "An error has occured, because $@"
printf "\n"
exit 1
}

errorzenity() { # This one outputs error in zenity.
killall zenity >/dev/null 2>&1
zenity \
	--error \
	--title="osu-install" \
	--text="An error has occoured, because $@" \
	--no-wrap
}

botherrors() { # This one outputs error to zenity and terminal, I just have this function here, to save me some time.
errorzenity "$@" & errorterminal "$@"
}

zenitynotif() { # This one opens zenity as notification.
zenity \
	--info \
	--title="osu-install" \
	--text="$@" \
	--no-wrap
}

zenitywarn() { # This one opens zenity as warning.
zenity \
	--warning \
	--title="osu-install" \
	--text="$@" \
	--no-wrap
}

getpass() { # Check if sudo needs password, if yes, then something there's something wrong with sudoers.
! /usr/bin/sudo -n true >/dev/null 2>&1 && \
	printf "We need your password, so we can continue further.\n" \
	&& /usr/bin/sudo true && printf "Thank you for your collaboration, mate! "
}

help() { # This one will show help message.
printf "This part of script \`osu-install\` will set audio latency to the lowest possible.\n\nARGUMENTS:\n-r/--revert: Will revert all changes that were done.\n-h/--help: Will show this message.\n"
exit 0
}

#revert() { # This one will revert any changes this script has done.
#exit 1
#}

## Command arguments

# This one checks command arguments.
case "$@" in
	--revert|-r) revert ;;
	--help|-h) help ;;
esac

# Make user use sudo, so the password won't be required again for this script.
getpass

# Wait for any user input.
read -rsn1 -p"If you are ready, press any key."; clear

# Remove `pulseaudio`, if pipewire is not installed, then install pipewire.
! command -v "pipewire" && sudo pacman --noconfirm -Rdd pulseaudio >/dev/null 2>&1 && \
	sudo pacman --noconfirm --needed -Sy pipewire pipewire-pulse pipewire-jack pipewire-alsa pipewire-media-session >/dev/null 2>&1

# Check if `pipewire` has been installed.
command -v "pipewire" || botherrors "PipeWire wasn't installed."

# Enable `pipewire`
systemctl enable --user pipewire >/dev/null 2>&1 || botherrors "PipeWire couldn't be enabled."
