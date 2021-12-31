```
		    _             _        _  _
 ___  ___ _ _  ___ <_>._ _  ___ _| |_ ___ | || |
/ . \<_-<| | ||___|| || ' |<_-<  | | <_> || || |
\___//__/`___|     |_||_|_|/__/  |_| <___||_||_|

  ▓▓▓▓▓▓▓▓▓▓
 ░▓ about  ▓ osu! installation script
 ░▓ author ▓ yurisuki <adam@adamnvrtil.fun>
 ░▓ web    ▓ https://yurisuki.github.io/osu-install/
 ░▓▓▓▓▓▓▓▓▓▓
 ░░░░░░░░░░

osu-install-arch.sh	> the main script which installs needed packages, creates WINEPREFIX, installs necessities for osu!, and also osu! by itself! (Arch Linux based distributions)

```

## table of contents
 - [introduction](#introduction)
 - [how do I execute this script?](#how-do-i-execute-this-script)
 - [experimental branch (should not be used)](https://github.com/yurisuki/osu-install/tree/experimental)
 - [distributions](#distributions)
 - [todo/wish](#todowish)
 - [contact](#contacting-me)

# introduction
Install osu! on Linux by executing one script and pressing ENTER! It just takes shy of ~8 minutes on my machine (Could take less on yours) to have fully functioning osu!.

Yes, exactly, that's what this script does do! No more need to hassle with the difficult and time-consuming installation.

# how do I execute this script?
It's really easy!


```
# If you have `curl` installed, use it, otherwise use `wget`.
curl https://raw.githubusercontent.com/yurisuki/osu-install/main/osu-install-arch.sh | sh

# Uncomment line under, if you don't have curl installed.
#wget -qO- https://raw.githubusercontent.com/yurisuki/osu-install/main/osu-install-arch.sh | sh
```

# distributions
I know, it's just for Arch Linux based distributions, but I plan making this for other distributions.

Please, write your distribution [here](https://github.com/yurisuki/osu-install/issues/2), it will help me decide, on which distribution I should focus next. Thank you.

# todo/wish
- Make a script, which will install `pipewire`, and make latency smallest as possible (if user will have any problems, he can revert back easily.)
- Determine, which distribution is used the most and based on that, recreate script to work on that distribution.
- Make script for other distributions.

# contacting me
You can contact me here on GitHub, but also on my e-mail: adam@adamnvrtil.fun
