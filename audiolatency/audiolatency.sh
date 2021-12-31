#!/bin/sh
############################
# DON'T USE YET, NOT DONE! #
############################
# This script should be continued after osu-install.sh

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

help() { # This one will show help message.
printf "This part of script \`osu-install\` will set audio latency to the lowest possible.\n\nARGUMENTS:\n-r/--revert: Will revert all changes that were done.\n-h/--help: Will show this message.\n"
}

revert() { # This one will revert any changes this script has done.
}

getpass() { # Check if sudo needs password, if yes, then something there's something wrong with sudoers.
! /usr/bin/sudo -n true >/dev/null 2>&1 && \
	printf "We need your password, so we can continue further.\n" \
	&& /usr/bin/sudo true && printf "Thank you for your collaboration, mate! "
}

## Command arguments

# This one checks command arguments.
case "$2" in
	--revert|-r) revert ;;
	*) help ;;
esac
