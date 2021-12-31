#!/bin/sh
# This script will install osu! with low sound latency patches.

## Check at the start.
# If user executed this script as root, warn him.
[ "$USER" = "root" ] && printf "You can't execute this script as root.\n" && exit 1

# Check if user has internet connection.
! ping -c 1 1.1.1.1 >/dev/null 2>&1 && printf "Get internet in machine mate, then we can continue.\n" && exit 1

## Variables
osudownloadlink="https://m1.ppy.sh/r/osu!install.exe" # I set this as variable, because mirror link might be changed, who knows.

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

installwine() { # This one will install wine.
# Telling user, that we're about to install wine.
zenitynotif "We are about to install wine, the API, which allows us to run Windows programs under Linux."

# Check if user has multilib packages enabled, if not, then enable them.
zenitynotif "Installing wine and winetricks (utility for managing wine)" &
! grep "osu-install" >/dev/null 2>&1 < /etc/pacman.conf && printf "\n# Enabled by osu-install\n[multilib]\nInclude = /etc/pacman.d/mirrorlist\n" | sudo tee -a /etc/pacman.conf

# Install wine and winetricks
sudo pacman -Sy --noconfirm --needed wine winetricks >/dev/null 2>&1 || botherrors "wine or winetricks didn't install."

# Kill zenity, because user might not closed it.
killall zenity >/dev/null 2>&1

# Verify, if installation was successful.
command -v "wine" >/dev/null 2>&1 || botherrors "wine isn't still installed, that's weird."
command -v "winetricks" >/dev/null 2>&1 || botherrors "winetricks didn't install, that's odd."
}

## Commands
# Check if user has Arch-based distribution.
command -v "pacman" >/dev/null 2>&1 || errorterminal "you are not using Arch-based distribution."

# Check if user has zenity installed, if not, install it.
! command -v "zenity" >/dev/null 2>&1 && echo "installing zenity (dialog windows)" && sudo pacman -Sy --noconfirm --needed zenity >/dev/null 2>&1

# Check if zenity was installed right.
command -v "zenity" >/dev/null 2>&1 || errorterminal "zenity couldn't be installed"

# Welcome message!
clear
printf "Welcome!\nThis script will install osu!, but it won't do only that, it can also apply known low sound latency patches to your system.\n\n"

# Make user use sudo, so the password won't be required again for this script.
getpass

# Wait for any user input.
read -rsn1 -p"If you are ready, press any key."; clear

# Tell user, we're going inside zenity.
printf "We are moving to \`zenity\`, so you can leave your terminal, but don't close it!\n"

# Check if user has wine/winetricks installed.
command -v "wine" >/dev/null 2>&1 || installwine
command -v "winetricks" >/dev/null 2>&1 || installwine


# Telling user, that we have to install some packages needed for functionality.
zenitynotif "Now, when we have wine and winetricks ready, we have to install some additional packages needed for proper functionality, but don't worry, I've got your back. Sit down, and relax."

# Install this large list of packages (I don't have all of these on my machine, but I guess it depends on each unit.).
sudo pacman --noconfirm --needed -Sy giflib lib32-giflib libpng lib32-libpng libldap \
	lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils\
	lib32-v4l-utils libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib\
	libjpeg-turbo lib32-libjpeg-turbo libxcomposite lib32-libxcomposite libxinerama lib32-libxinerama\
	ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva\
	gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader cups samba dosbox >/dev/null 2>&1 || \
	botherrors "one or more of the packages couldn't be installed."

# Kill zenity, because user might not closed it.
killall zenity >/dev/null 2>&1

# Tell user, that we're about to make WINEPREFIX.
zenitynotif "We are about to make WINEPREFIX (a directory, where osu! will be located, and also other files needed for wine functionality.)\n\nIt's up to you to choose, where do you want it."

# Make user select directory.
! userdir="$(zenity --file-selection --directory)" && zenitynotif "You accidentaly closed window? No worries, I'll give you one more try." && userdir="$(zenity --file-selection --directory)"

# If user didn't select any directory, lets make one for him.
[ -z "$userdir" ] && userdir="$HOME/osu-wine" && zenitynotif "I didn't get any selected directory from you, so I chose one for you. It's $userdir."

# Tell user that we're starting.
zenitynotif "Good selection! It's $userdir.\nNow we will create WINEPREFIX, install .NET Framework, and then we can install the game itself!"

## Wine part
# cd to the chosen directory.
mkdir -p "$userdir"
cd $userdir || botherrors "i couldn't get to the directory you've chosen."

# Some variables for wine.
export WINEPREFIX="$userdir"
export WINEARCH=win32

# Tell user that we're installing .NET Framework
zenitynotif "I have everything ready, now we will install .NET Framework\nThis might take 5-10 minutes, because .NET Frameworks' installer sucks."

# Let's start the installation.
winetricks dotnet40 gdiplus_winxp cjkfonts >/dev/null 2>&1 || botherrors "winetricks messed up something, don't blame me."

# Tell user about osu! installation.
zenitynotif "It took long time, right? I told you, people over at Microsoft can't even make proper installer.\\nAnyway, let's download osu! client, and install it.\n\nDon't change osu! directory, otherwise the game wouldn't start.\\nAfter it will be started, close the game, and press any key 3 times inside terminal."

# Check if curl is present on the system.
! command -v "curl" >/dev/null 2>&1 && pacman --noconfirm -S curl >/dev/null 2>&1

# Download osu! to /tmp
curl -Lo "/tmp/osuclient.exe" "$osudownloadlink" >/dev/null 2>&1 || botherrors "osu! couldn't be downloaded. Try checking your internet connection."

# Start the installation file.
wine /tmp/osuclient.exe >/dev/null 2>&1

# Wait for any user input.
read -rsn3 -p"If you're done, press any key 3 times."; sleep 3

# Ask user, if the game started.
! zenity --question --title="osu-install" --no-wrap --text="Did the game start?" && zenity --question --title="osu-install" --no-wrap --text="Are you sure it didn't started?" && zenitynotif "Okay, okay, I believe you.\nPlease, put an issue on GitHub repository, I'll gladly help you with that.\n~ yurisuki" && exit 0

# Let's create link folder, because the path to osu folder is complicated. (Only if user agrees)
# Use if, more simplier. - If user agrees, then let him select directory and the script will link it. If user doesn't agree, then nothing will happen.
if zenity --question --title="osu-install" --no-wrap --text="Would you like me to link your osu! folder more simplier, so you can get easily in osu! folder?\n\nCurrent path to osu! looks like this: $userdir/drive_c/users/$USER/AppData/Local/osu!, and it can look like this: $HOME/osufolder for example.";
then
		! [ -z "$linkdir" ] && linkdir="$HOME/osufolder"
		ln -sv "$userdir/drive_c/users/$USER/AppData/Local/osu!" "$linkdir" && $zenitynotif "Your new osu! directory is at $linkdir.\nIf you don't like it, you can change it in your file manager."
else
	zenitynotif "Alright, but if you will change your mind, you can run this script again, and select the same folder, this menu will be shown again."
fi

## Run script.
# This one generates run script. You can run game using `osu`.
echo "#!/bin/sh
export WINEPREFIX="$userdir"
export STAGING_AUDIO_DURATION=8000 # As low as you can get osu! stable with

cd "$userdir/drive_c/users/$USER/AppData/Local/osu!"
wine osu!.exe "$@"" | sudo tee /bin/osus

# This one generates kill script. You can kill game using osukill.
# You should only use this when the game freezes.
echo "#!/bin/sh
export WINEPREFIX="$userdir"

wineserver -k" | sudo tee /bin/osuskill

# Make it executable.
sudo chmod +x /bin/osus /bin/osuskill || botherrors "i couldn't chmod one of the files."

# Let's add entry to applications
# Make a directory, where application will be placed.
mkdir -p "~/.local/share/applications" >/dev/null 2>&1

echo "[Desktop Entry]
Type=Application
Name=osu!
Exec=osu %u
StartupWMClass=osu!.exe
Categories=Game;
MimeType=x-scheme-handler/discord-367827983903490050;x-scheme-handler/osu;" | sudo tee ~/.local/share/applications/osu!.desktop

zenitynotif "We have done the installation! If you want better sound latency, then you have to run my script \"blabla\". Thank you for your corporation, without you we wouldn't be able to install osu!.\nYou can start osu!, by typing \`osu\` in terminal, or find it in your applications (if your DE supports that.)\nIf osu! ever freezes, and you can't turn it off, then I prepared handy command for you. It's \`osukill\`, it will kill osu!, and wine.\n\nHave a nice day!"
