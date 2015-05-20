# rai-dl
Rai.tv download project.

[Read in Italian](https://github.com/danog/rai.tv-bash-dl/blob/master/README-IT.md)


Created by [Daniil Gentili](http://daniil.eu.org).

This project is licensed under the terms of the GPLv3 license.


The programs included in this project can be used to download videos from the Italian [Rai](http://rai.tv) Television website: they support nearly all videos, including Rai Replay and iframe videos


This project features a Bash script that can be installed on [any Linux/Unix system](#installation-instructions) including [Android](#android), [Mac OS X](#installation-instructions) or [iOS](#ios) and even on [Windows](#windows), an [API](#api), an [Android app](http://bit.ly/0192837465k) and even a [web version](#Web-version)!


## Bash script usage:
```
rai.sh [ -qaf [ urls.txt ] ] URL URL2 URL3 ...
```

Options:




-q:	Quiet mode: useful for crontab jobs, automatically enables -a.


-a:	Automatic/Andrea mode: automatically download the video in the maximum quality using Andrea's server.


-f:	Reads URL(s) from specified text file(s).


--help:	Show this extremely helpful message.




### Bash script installation instructions:

### Any Linux/Unix system (Ubuntu, Debian, Fedora, Redhat, openBSD, Mac OS X):
Note that you will have to install wget to use this program on Mac os X.

On debian-derived distros, execute this command to add my repo to your system:


```
sudo wget -q -O /etc/apt/sources.list.d/daniil.list http://dano.cu.cc/1IJrcd1 && wget -q -O - http://dano.cu.cc/1Aci9Qp | sudo apt-key add -
```


You should see an OK if the operation was successful.


And this command to install the script.


```
sudo apt-get update; sudo apt-get -y install raitv-bash-dl
```


Or if you want to use the old method follow these instructions.

Execute this command to install the script:

```
wget http://daniilgentili.magix.net/rai.sh -O rai.sh || curl -L http://daniilgentili.magix.net/rai.sh -o rai.sh; chmod +x rai.sh
```

Run with 
```
./rai.sh "URL"
```
In the directory where you downloaded it.


Do not forget to put the URL between quotes.


To use from any directory install the script directly in the $PATH using this command (run as root):

```
wget http://daniilgentili.magix.net/rai.sh -O /usr/bin/rai.sh || curl -L http://daniilgentili.magix.net/rai.sh -o rai.sh; chmod +x /usr/bin/rai.sh
```

Now you should be able to run the script simply with:
```
rai.sh "URL"
```



Do not forget to put the URL between quotes.




### Android:
#### Method 1 (app).
Enable unknown sources and install [this app](http://bit.ly/0192837465k). Once opened you will be presented with a user friendly interface similar to the web version :P

#### Method 2 (script).
#### Install [Busybox](https://play.google.com/store/apps/details?id=stericson.busybox), [Jackpal's Terminal emulator](https://play.google.com/store/apps/details?id=jackpal.androidterm) and [Bash](https://play.google.com/store/apps/details?id=com.bitcubate.android.bash.installer) on rooted devices or [Busybox no root](https://play.google.com/store/apps/details?id=burrows.apps.busybox) if your device isn't rooted. 


[Video tutorial](https://www.youtube.com/watch?v=4NLs2NzHbbc)


Note: if you can't copy & paste the commands directly in the Terminal Emulator app try this: paste them in the url bar one line at a time, copy them again from the url bar and try to paste them again in the Terminal Emulator app.
Run these commands:
```
cd /sdcard && wget http://daniilgentili.magix.net/android/rai.sh 
```

Run with:
```
bash /sdcard/rai.sh "URL"
```


Do not forget to put the URL between quotes.



To install the script directly in the $PATH use these commands (here, root is mandatory).


```
su
mount -o rw,remount /system && wget http://daniilgentili.magix.net/android/rai.sh -O /system/bin/rai.sh && chmod 755 /system/bin/rai.sh
```

Now you should be able to run it with:
```
rai.sh "URL"
```


Do not forget to put the URL between quotes.



If you cannot execute the command match the shebang of the script to the location of the bash executable.

### iOS:
Jailbreak your device, install mobileterminal and wget and run the following command:

```
wget http://daniilgentili.magix.net/rai.sh -O rai.sh || curl -L http://daniilgentili.magix.net/rai.sh -o rai.sh; chmod +x rai.sh
```

Run with:
```
./rai.sh "URL"
```


Do not forget to put the URL between quotes.


In the directory where you downloaded it.

To view the downloaded video use iFile. 

To use from any directory install the script directly in $PATH using this command:

```
su -c "wget http://daniilgentili.magix.net/rai.sh -O /usr/bin/rai.sh || curl -L http://daniilgentili.magix.net/rai.sh -o rai.sh; chmod +x /usr/bin/rai.sh"
```

Now you should be able to run it with:
```
rai.sh "URL"
```


Do not forget to put the URL between quotes.




### Windows:
Install [Cygwin](https://www.cygwin.com) (don't forget to install wget during the installation process!), open its command prompt and type:

```
wget http://daniilgentili.magix.net/win/rai.sh -O rai.sh
```

Run with:
```
./rai.sh "URL"
```


Do not forget to put the URL between quotes.



In the directory where you downloaded it.

To run the script from any directory run the following commands:

```
cd /bin && wget http://daniilgentili.magix.net/win/rai.sh -O rai.sh && cd $OLDPWD
```


Now you should be able to run it with:
```
rai.sh "URL"
```


Do not forget to put the URL between quotes.


## Web version
This project also features a [web version](http://video.daniil.it/rai.php).

![Alt text](http://daniilgentili.magix.net/rai.png)

The source code of the page can be viewed in the rai.php file.

## API

This project also features an API.

The source code of the API can be viewed in the api/rai.php file.

### API usage example

Requested URL:

```
http://video.daniil.it/api/rai.php?url=http://www.winx.rai.it/dl/RaiTV/programmi/media/ContentItem-47307196-8fd1-46f8-8b31-92ae5f9b5089.html#p=0
```

Output:

```

Winx_Club_VI_Ep3_Il_collegio_volante Winx Club VI - Ep.3: Il collegio volante
1 Medium-low quality (mp4, 131MB, 700x394) http://creativemedia4.rai.it/Italy/podcastcdn/junior/Winx/Winx_6_puntate/2189463_800.mp4
2 Highest quality (mp4, 286MB, 1024x576) http://creativemedia4.rai.it/Italy/podcastcdn/junior/Winx/Winx_6_puntate/2189463_1800.mp4

```

Explanation: 

```
Newline
Winx_Club_VI_Ep3_Il_collegio_volante Winx Club VI - Ep.3: Il collegio volante
Sanitized name of video for file name. Original name of the video for printing to user output.
Newline
1 Medium-low quality (mp4, 131MB, 700x394) http://creativemedia4.rai.it/Italy/podcastcdn/junior/Winx/Winx_6_puntate/2189463_800.mp4
Number for user selection  quality name (format, size, dimension)
Newline
2 Highest quality (mp4, 286MB, 1024x576) http://creativemedia4.rai.it/Italy/podcastcdn/junior/Winx/Winx_6_puntate/2189463_1800.mp4
Number for user selection  quality name (format, size, dimension)
Newline
```

If you created a version of the script using another programming language [contact me](http://daniil.it/contact_me.html) and I will put it on this page!

That's it!

Enjoy!

[Daniil Gentili](http://daniil.eu.org/lol)
