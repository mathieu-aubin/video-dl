# rai-bashdl
Rai.tv bash download script created by Daniil Gentili.
This script can be used on any Linux/Unix system (including Android, Mac OS X or iOS) and even on Windows!

# Usage:
rai.sh [ -af [ urls.txt ] ] URL URL2 URL3 ...

Options:
-a	Automatic mode: quietly downloads every video in maximum mp4 quality.

-f	Reads URLs from specified text file(s).

--help	Shows this extremely helpful message.

# Installation instructions

# Any Linux/Unix system (Ubuntu, Debian, Fedora, Redhat, openBSD, Mac OS X:
Execute this command:

wget https://github.com/danog/rai-bash-dl/raw/master/rai.sh -O rai.sh && chmod +x rai.sh

Run with ./rai.sh URL


To use from any directory install the script directly in $PATH using this command (run as root):

wget https://github.com/danog/rai-bash-dl/raw/master/rai.sh -O /usr/bin/rai.sh && chmod +x /usr/bin/rai.sh

And call it with:
rai.sh URL



# Android:
1. Install busybox, Jackpal's Terminal emulator and bash. Root is not mandatory.
2. Run this command:
cd /data/data/jackpal.androidterm/app_HOME/ && wget http://daniilgentili.magix.net/android/rai.sh -O rai.sh && chmod +x rai.sh

Run with:
bash rai.sh URL

To use this script from any directory install the script directly in $PATH using this command (run it as root):

su
mount -o remount,rw /system && wget http://daniilgentili.magix.net/android/rai.sh -O /system/bin/rai.sh && chmod +x /system/bin/rai.sh

And run with:
rai.sh URL

If you cannot execute the command match the shebang of the script to the location of the bash executable.

# iOS:
Jailbreak your device, install the terminal app and run the following command:

wget http://daniilgentili.magix.net/rai.sh -O rai.sh && chmod +x rai.sh

Run with:
./rai.sh URL


To view the downloaded video use iFile. 

To use from any directory install the script directly in $PATH using this command (run it as root):

wget http://daniilgentili.magix.net/rai.sh -O /usr/bin/rai.sh && chmod +x /usr/bin/rai.sh

And run with:
rai.sh URL


# Windows:
Install unxutils and win-bash, open up the command prompt and type:
bash
cd && wget http://daniilgentili.magix.net/win/rai.sh -O rai.sh && chmod +x rai.sh

Run with:
bash rai.sh

Or change the shebang to match the location of the bash executable and run with

./rai.sh

To run the script from any directory run the following commands:

cd $HOME
echo "export PATH="$PATH:C:/rai/" >>.bashrc
cd C:/rai
wget http://daniilgentili.magix.net/win/rai.sh -O rai.sh && chmod +x rai.sh

Change shebang to match the location of the bash executable (default is C:/usr/bin/bash)

And run with:
bash
rai.sh URL
