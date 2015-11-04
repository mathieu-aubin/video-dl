# video-dl
Video download project.

[![Build Status](https://travis-ci.org/danog/video-dl.svg?branch=master)](https://travis-ci.org/danog/video-dl)
[![npm version](https://badge.fury.io/js/video-dl.svg)](https://npmjs.org/package/video-dl)


[Read in Italian](https://github.com/danog/video-dl/blob/master/README-IT.md)

[View on Github](https://github.com/danog/video-dl/)


Created by [Daniil Gentili](http://daniil.it).

This project is licensed under the terms of the GPLv3 license.


The programs included in this project can be used to download videos from any generic site including the Italian [Rai](http://rai.tv) Television website (including rai replay and iframe videos), the italian [Mediaset](http://mediaset.it) website (including iframes like the ones on the [Witty TV](http://wittytv.it) website), and the [LA7](http://la7.it) website. And thanks to youtube-dl now they support lots of other websites!

This project features:


* A Bash script that can be installed on

 * [Any Linux/Unix system](#bash-script-installation-instructions)

 * [Android](#android)

 * [Mac OS X](#bash-script-installation-instructions)

 * [iOS](#ios) and even on

 * [Windows](#windows)!


* An [API](#api)!


* An [Android app](#method-1-app)!


* And even a [web version](#web-version)!


* That can be [incorporated](#incorporation) in other websites!


Both the [API](#api) and the [web version](#web-version) use a [database](https://github.com/danog/video-dl/blob/master/video_db.sql).



# Web version
This project also features a [web version](https://video.daniil.it/).

![web version](https://github.com/danog/video-dl/raw/master/web.png)

The source code of the page can be viewed [here](https://github.com/danog/video-dl/blob/master/web).


I used the following programs in the web version:

* [Loading animation (pace.js)](https://github.com/HubSpot/pace)

* [HTML entity encoder (he.js)](https://github.com/mathiasbynens/he)

* [Linkifier (linkify.js)](https://github.com/soapbox/linkifyjs/)


And used the following theme as a base:  


* [Bootstrap theme (freelancer)](https://github.com/IronSummitMedia/startbootstrap-freelancer)



# Incorporation

You can incorporate this script in your website!  
Just include jquery and the video-dl script with:  
```
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="//daniil.it/video-dl/video-dl.min.js"></script>
```  
Or install it using npm.  
```
npm install video-dl
```

Here's a list of the functions and the usage instructions.  

##Video Download function.  

###Usage:  
```
video_dl(output, inputurl, dlsupport, messageoutput)
```

###Parameters:  

###output: output html element for the video info and the download urls. Required.  
example: ```#result.```



###inputurl: url of the video. Required.  
example: ```$("input#urljs").val()```

###dlsupport: enables or disables the download attribute in the download links. Optional.  
0 enables, anything disables. 

###messageoutput: output html element for the contact module. Optional.  
example: ```#message```



###Example:  
```video_dl("#result", $("input#urljs").val(), "0", "#message"); ```


Let's say the ```input#urljs``` text field has value ```"http://www.winx.rai.it/dl/RaiTV/programmi/media/ContentItem-a27ccfe8-b824-4e85-9a08-d15e57fb61a0.html#p=0"```.  

The function will get the value of the ```input#urljs``` element, get the download links from the API, and return the following output to the ```#result``` element:  
```
<h1 style="font-style: italic;">Video download script.</h1><br><h2 style="font-style: italic;">Created by <a href="http://daniil.it">Daniil Gentili</a></h2><br><h1>Title:</h1> <h2>26 - Il potere degli animali fatati - Winx Club VII del 03/10/2015</h2><br><h1>Available versions:</h1><br><h2><a href="http://creativemedia4.rai.it/Italy/podcastcdn/junior/Winx/Winx_7_EP_Puntate/4524680.mp4" download="26_Il_potere_degli_animali_fatati_Winx_Club_VII_del_03102015.mp4">Normal quality (mp4, 267 MiB, 720x404)</a><br></h2>
```

The function will then start the mailtext function with the following parameters:  
```mailtext(messageoutput, inputurl);```  

See mailtext description for the result.  


##First load function.  
Use to output supported websites list, prepare mail message and,
only on the video.daniil.it website, hide the php submit module and use javascript engine instead.  

###Usage:
```
firstload(supportedurls, separatorstart, separatorend, messageoutput, videodaniilit)  
```

###Parameters:  

###supportedurls: output html element for the supported websites list. Required.  
Example: ```#supportedurls```. 

###separatorstart: first separator for the supported urls list: it will be put before every item in the supported websites list, if empty defaults to ```<br>```.  
Optional, recommended.  
Example: ```<li>```  

###separatorend: the second separator for the supported urls list: it will be put after every url, if empty defaults to ```<br>```. Optional, recommended.  
Example: ```</li>```  

###messageoutput: output html element for default contact module text. Optional, recommended.  
Example: ```#contact ```


###videodaniilit: If on video.daniil.it hides php module and unhides javascript text field. Do not use.  

###Example:  
```
firstload("#supportedurls", "<li>", "</li>", "#message");  
```

Let's say the url list is: ```a b c d```. 

Output printed to #supportedurls is:

```
<li>a</li><li>b</li><li>c</li><li>d</li><a href="http://lol.daniil.it" target="_blank">&#9786;</a></li>
```

This will also create the default contact module text with
```
mailtext("#message");  
```


##Contact module function.  
Prints a nice message to the contact module text field, with the url if it's provided else just With ```insert link```.  

###Usage:  
```
mailtext(output, url)  
```

###Parameters:  

###output: html selector where to print out the contact message. Required.  
Example: ```#contact```



###url: url of the video to insert into the message.  Not required, if not provided defaults to insert link.

  

###Example:  
```
mailtext("#contact", "http://google.com");  
```

Will put 
```
The video:
http://google.com
does not download, could you please fix it
Thanks!
```

to ```#contact```.  


##Error function.  
Sends me an email if an error occurs.  

###Usage:  
```
error(output, url, error)  
```

###Parameters:  

###output: html selector where to output success or error message of request to mail sending php script. Required.  
example: ```#result```  

###url: url of the video that failed to download.   Required.  
example: ```http://google.com``` 

###error: actual error message. If empty defaults to
Empty Response. Recommended.  
example: ```error 404```  

###Example:  
```
error("#result", "http://google.com", "error 404");  
```

Will try to send me a mail and print ```"An error occurred and it was reported!"``` to ```#result```` if everything went fine, else it will print ```"An error occurred but it couldn't be reported! Please use the manual report module!"```.   


# Bash script.

## Bash script usage:

```
video.sh [ -qaf [ urls.txt ] ] URL URL2 URL3 ...

Do not forget to put the URL between quotes if it contains special chars like & or #.

Run with ./video.sh if you installed in a directory not in $PATH.

Options:




-q              Quiet mode: useful for crontab jobs, automatically enables -a.

-a              Automatic mode: automatically download the video in the maximum quality.

-b              Use built-in API engine: requires additional programs and may not work properly on some systems but may be faster than the API server.

-f              Read URL(s) from specified text file(s). If specified, you cannot provide URLs as arguments.

-p=player       Play the video instead of downloading it using specified player, mplayer if none specified.

--help          Show this extremely helpful message.

```



## Bash script installation instructions:

### Debian-derived distros (Ubuntu, Linux mint, Bodhi Linux, etc.)


On debian-derived distros, execute this command to add my repo to your system:


```
sudo wget -q -O /etc/apt/sources.list.d/daniil.list http://dano.cu.cc/1IJrcd1 && wget -q -O - http://dano.cu.cc/1Aci9Qp | sudo apt-key add - && sudo apt-key adv --recv-keys --keyserver keys.gnupg.net 72B97FD1D9672C93 && sudo apt-get update
```


You should see an OK if the operation was successful.


And this command to install the script.


```
sudo apt-get update; sudo apt-get -y install video-dl
```



### Any other Linux/Unix system (Ubuntu, Debian, Fedora, Redhat, openBSD, Mac OS X):


Execute this command to install the script:

```
wget http://daniilgentili.magix.net/video.sh -O video.sh || curl -L http://daniilgentili.magix.net/video.sh -o video.sh; chmod +x video.sh
```

Run with ./video.sh in the directory where you downloaded it.

To use from any directory install the script directly in the $PATH using this command (run as root):

```
wget http://daniilgentili.magix.net/video.sh -O /usr/bin/video.sh || curl -L http://daniilgentili.magix.net/video.sh -o video.sh; chmod +x /usr/bin/video.sh
```


### Android:


### Method 1 (app).
Enable unknown sources and install [this app](http://bit.ly/0192837465k). Once opened you will be presented with a user friendly interface similar to the web version.

### Changelog:

1: initial version

1.2: added not working, share and credits button

1.2.1: added external sharing option, fixed bugs

1.2.2: Fixed not working button on external share URL, added google analytics, fixed Rai Replay on external share.

1.3: Added auto update.

1.4: Added more credits.


### Todo: 

You tell me!


### Method 2 (script).
### Install [Busybox](https://play.google.com/store/apps/details?id=stericson.busybox), [Jackpal's Terminal emulator](https://play.google.com/store/apps/details?id=jackpal.androidterm) and [Bash](https://play.google.com/store/apps/details?id=com.bitcubate.android.bash.installer) on rooted devices or [Busybox no root](https://play.google.com/store/apps/details?id=burrows.apps.busybox) if your device isn't rooted. 


[Video tutorial](https://www.youtube.com/watch?v=4NLs2NzHbbc)


Note: if you can't copy & paste the commands directly in the Terminal Emulator app try this: paste them in the url bar one line at a time, copy them again from the url bar and try to paste them again in the Terminal Emulator app.
Run these commands:
```
cd /sdcard && wget http://daniilgentili.magix.net/android/video.sh 
```

Run with:
```
bash /sdcard/video.sh
```


To install the script directly in the $PATH use these commands (here, root is mandatory).


```
su
mount -o rw,remount /system && wget http://daniilgentili.magix.net/android/video.sh -O /system/bin/video.sh && chmod 755 /system/bin/video.sh
```


If you cannot execute the script match the its shebang (the #!) to the location of the bash executable.

### iOS:
Jailbreak your device, add the following repo to Cydia,

```
http://repo.daniil.it
```

... and install mobileterminal and video-dl.


Run with video.sh in mobileterminal.

To view and import the downloaded video to the gallery use iFile or Filza.


### Windows:
Install [Cygwin](https://www.cygwin.com) (don't forget to install wget and sed during the installation process!), open its command prompt and type:

```
wget http://daniilgentili.magix.net/win/video.sh -O video.sh
```

Run with ./video.sh In the directory where you downloaded it.

To run the script from any directory run the following commands:

```
cd /bin && wget http://daniilgentili.magix.net/win/video.sh -O video.sh && cd $OLDPWD
```


## API

This project also features an [API](http://video.daniil.it/api/).

The source code of the API can be viewed [here](https://github.com/danog/video-dl/blob/master/api).

The API uses [youtube-dl](https://github.com/rg3/youtube-dl) to get the links for non Rai/mediaset/la7 videos.

The API supports GET requests and the endpoint is http://api.daniil.it (supports https).

### Supported parameters:


### url


The value should be the URL of the video to download. The response will be a list of URLS with the corresponding quality name, format, size and dimension.


Example:

```
http://api.daniil.it/?url=http://www.winx.rai.it/dl/RaiTV/programmi/media/ContentItem-47307196-8fd1-46f8-8b31-92ae5f9b5089.html#p=0
```

Output:

```
Winx_Club_VI_Ep3_Il_collegio_volante Winx Club VI - Ep.3: Il collegio volante
Highest quality (mp4, 286MB, 1024x576) http://creativemedia4.rai.it/Italy/podcastcdn/junior/Winx/Winx_6_puntate/2189463_1800.mp4
Medium-low quality (mp4, 131MB, 700x394) http://creativemedia4.rai.it/Italy/podcastcdn/junior/Winx/Winx_6_puntate/2189463_800.mp4
```

Explanation: 

```
Winx_Club_VI_Ep3_Il_collegio_volante Winx Club VI - Ep.3: Il collegio volante
```

Sanitized name of video for file name  Original name of the video for printing to user output

```
Highest quality (mp4, 286MB, 1024x576) http://creativemedia4.rai.it/Italy/podcastcdn/junior/Winx/Winx_6_puntate/2189463_1800.mp4
```

Quality name (format, size, dimension) URL of the video

```
Medium-low quality (mp4, 131MB, 700x394) http://creativemedia4.rai.it/Italy/podcastcdn/junior/Winx/Winx_6_puntate/2189463_800.mp4
```

Quality name (format, size, dimension) URL of the video

The qualities are ordered in decreasing order by dimension.



### p

Supports the following values:

```
websites
```

returns a shortened list of supported websites:


```
allwebsites
```

returns a full list of supported websites.



## Contribute!


If you created a program that uses this API [contact me](http://daniil.it) and I will put it on this page!

That's it!

Enjoy!

[Daniil Gentili](http://daniil.it)
