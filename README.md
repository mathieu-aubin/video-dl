# rai.tv-bash-dl
Rai.tv bash download script.

[Read in Italian](https://github.com/danog/rai.tv-bash-dl/blob/master/README-IT.md)


Created by [Daniil Gentili](http://daniil.eu.org), this script uses [Andrea Lazzarotto](http://andrealazzarotto.com/)'s [server](http://video.lazza.dk) to decode URLs.

This script can be used to download videos from the Italian [Rai](http://rai.tv) Television website: it supports nearly all videos, including Rai Replay and iframe videos.

If you find a video that won't work, [contact me]<daniil.gentili.dg@gmail.com>.


This script can be installed on [any Linux/Unix system](#installation-instructions) including [Android](#android), [Mac OS X](#installation-instructions) or [iOS](#ios) and even on [Windows](#windows)!

Also on Android you can use the [app](http://bit.ly/0192837465k) to download videos.

For every other platform there's the [web version](http://video.daniil.eu.org/rai.php).
## Usage:
```
rai.sh [ -qmf [ urls.txt ] ] URL URL2 URL3 ...
```

Options:




-q:	Quiet mode: useful for crontab jobs.


-m:	Manual mode: manually select the quality to download.


-f:	Reads URL(s) from specified text file(s).


--help:	Show this extremely helpful message.



## Installation instructions:

### Any Linux/Unix system (Ubuntu, Debian, Fedora, Redhat, openBSD, Mac OS X):
Note that you will have to install wget to use this program on Mac os X.
Execute this command to install the script:

```
wget http://daniilgentili.magix.net/rai.sh -O rai.sh || curl -L http://daniilgentili.magix.net/rai.sh -o rai.sh; chmod +x rai.sh
```

Run with 
```
./rai.sh URL
```
In the directory where you downloaded it.

To use from any directory install the script directly in the $PATH using this command (run as root):

```
wget http://daniilgentili.magix.net/rai.sh -O /usr/bin/rai.sh || curl -L http://daniilgentili.magix.net/rai.sh -o rai.sh; chmod +x /usr/bin/rai.sh
```

Now you should be able to run the script simply with:
```
rai.sh URL
```



### Android:
#### Method 1 (app).
Enable unknown sources and install [this app](http://bit.ly/0192837465k). Once opened you will be presented with a user friendly interface similar to the web version :P

#### Method 2 (script).
#### Install [Busybox](https://play.google.com/store/apps/details?id=stericson.busybox), [Jackpal's Terminal emulator](https://play.google.com/store/apps/details?id=jackpal.androidterm) and [Bash](https://play.google.com/store/apps/details?id=com.bitcubate.android.bash.installer) on rooted devices or [Busybox no root](https://play.google.com/store/apps/details?id=burrows.apps.busybox) if your device isn't rooted. 

Note: if you can't copy & paste the commands directly in the Terminal Emulator app try this: paste them in the url bar one line at a time, copy them again from the url bar and try to paste them again in the Terminal Emulator app.
Run these commands:
```
cd sdcard && wget http://daniilgentili.magix.net/android/rai.sh 
```

Run with:
```
bash /sdcard/rai.sh URL
```

To install the script directly in the $PATH use these commands (here, root is mandatory).


```
su
mount -o rw,remount /system && wget http://daniilgentili.magix.net/android/rai.sh -O /system/bin/rai.sh && chmod 755 /system/bin/rai.sh
```

Now you should be able to run it with:
```
rai.sh URL
```

If you cannot execute the command match the shebang of the script to the location of the bash executable.

### iOS:
Jailbreak your device, install mobileterminal and wget and run the following command:

```
wget http://daniilgentili.magix.net/rai.sh -O rai.sh || curl -L http://daniilgentili.magix.net/rai.sh -o rai.sh; chmod +x rai.sh
```

Run with:
```
./rai.sh URL
```
In the directory where you downloaded it.

To view the downloaded video use iFile. 

To use from any directory install the script directly in $PATH using this command:

```
su -c "wget http://daniilgentili.magix.net/rai.sh -O /usr/bin/rai.sh || curl -L http://daniilgentili.magix.net/rai.sh -o rai.sh; chmod +x /usr/bin/rai.sh"
```

Now you should be able to run it with:
```
rai.sh URL
```


### Windows:
Install [Cygwin](https://www.cygwin.com) (don't forget to install wget during the installation process!), open its command prompt and type:

```
wget http://daniilgentili.magix.net/win/rai.sh -O rai.sh
```

Run with:
```
./rai.sh
```
In the directory where you downloaded it.

To run the script from any directory run the following commands:

```
cd /bin && wget http://daniilgentili.magix.net/win/rai.sh -O rai.sh && cd $OLDPWD
```


Now you should be able to run it with:
```
rai.sh URL
```


That's it!

Enjoy!

[Daniil Gentili](http://daniil.eu.org/lol)
