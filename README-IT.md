# video-dl
Programmi per scaricare video.

[![Build Status](https://travis-ci.org/danog/video-dl.svg?branch=master)](https://travis-ci.org/danog/video-dl)
[![npm version](https://badge.fury.io/js/video-dl.svg)](https://npmjs.org/package/video-dl)

[![Rank and dls](https://nodei.co/npm/video-dl.png?downloads=true&downloadRank=true&stars=true)](https://npmjs.org/package/video-dl)

[Read English version](https://github.com/danog/video-dl)

[Visualizza su Github](https://github.com/danog/video-dl/)


Creato da [Daniil Gentili](http://daniil.it).


This project is licensed under the terms of the GPLv3 license.


I programmi di questo progetto possono essere usati per scaricare i video di qualsiasi sito generico, inclusi i video del sito della [Rai](http://rai.tv) (incluso Rai Replay e siti iframe), [Mediaset](http://mediaset.it) (incluso Witty TV), [LA7](http://la7.it), [Dplay](http://dplay.com) e tanti altri siti. E grazie a youtube-dl adesso i programmi supportano tantissimi altri siti!


Questo progetto include:


* Uno [script Bash](#istruzioni-di-utilizzo-dello-script-bash) che può essere installato su:

 * [qualsiasi sistema Linux/Unix](#istruzioni-di-installazione-dello-script-bash)

 * [Android](#android)

 * [Mac OS X](#istruzioni-di-installazione-dello-script-bash)

 * [iOS](#ios) e persino su

 * [Windows](#windows)!


* Una [API](#api)!


* Un'[app Android](#metodo-1-app)!


* E persino una [versione web](#versione-web)!


* Che può essere [incorpororata](#incorporamento) in altri siti!


Sia la [API](#api) sia la [versione web](#web-version) usano un [database](https://github.com/danog/video-dl/blob/master/video_db.sql).



# Versione web

Questo progetto include anche una [versione web](https://video.daniil.it/).

![web version](https://github.com/danog/video-dl/raw/master/web.png)


Il codice sorgente della pagina può essere visualizzato [qui](https://github.com/danog/video-dl/blob/master/web).


Ho usato i seguenti script nella versione web:


* [Animazione di caricamento (pace.js)](https://github.com/HubSpot/pace)

* [Codificatore di entità HTML (he.js)](https://github.com/mathiasbynens/he)

* [Linkifier (linkify.js)](https://github.com/soapbox/linkifyjs/)


E mi sono basato sul seguente tema bootstrap:  


* [Bootstrap theme (freelancer)](https://github.com/IronSummitMedia/startbootstrap-freelancer)



# Incorporamento

Puoi anche incorporare la versione Jquery nel tuo sito!  
Semplicemente includi jquery e lo script video-dl con il seguente codice:  
```
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="//daniil.it/video-dl/video-dl.min.js"></script>
```  
O installa il tutto con npm.  
```
npm install video-dl
```

Ecco la lista delle funzioni e le istruzioni di utilizzo.  

##Funzione di scaricamento video.  

###Utilizzo:  
```
video_dl(output, inputurl, dlsupport, messageoutput)
```

###Parametri:  

###output: elemento html per l'output delle informazioni del video e gli indirizzi di scaricamento. Obbligatorio.  
Esempio: ```#result.```



###inputurl: Indirizzo del video. Obbligatorio.  
Esempio: ```$("input#urljs").val()```

###dlsupport: abilita o disabilita l'attributo html5 download negli indirizzi di scaricamento. Opzionale.  
0 abilita, qualsiasi altro valore incluso "" disabilita. 

###messageoutput: elemento html dell'output del testo del modulo di contatto. Opzionale.  
Esempio: ```#message```



###Esempio:  
```video_dl("#result", $("input#urljs").val(), "0", "#message"); ```


Diciamo che il campo di testo ```input#urljs``` ha valore ```"http://www.winx.rai.it/dl/RaiTV/programmi/media/ContentItem-a27ccfe8-b824-4e85-9a08-d15e57fb61a0.html#p=0"```.  

La funzione leggerà il valore del campo di testo ```input#urljs``` element, otterrà gli indirizzi di scaricamento dall'API e scriverà il seguente output sull'elemento ```#result```:  
```
<h1 style="font-style: italic;">Video download script.</h1><br><h2 style="font-style: italic;">Created by <a href="http://daniil.it">Daniil Gentili</a></h2><br><h1>Title:</h1> <h2>26 - Il potere degli animali fatati - Winx Club VII del 03/10/2015</h2><br><h1>Available versions:</h1><br><h2><a href="http://creativemedia4.rai.it/Italy/podcastcdn/junior/Winx/Winx_7_EP_Puntate/4524680.mp4" download="26_Il_potere_degli_animali_fatati_Winx_Club_VII_del_03102015.mp4">Normal quality (mp4, 267 MiB, 720x404)</a><br></h2>
```

Poi la funzione chiamerà la funzione ```mailtext``` con i seguenti Parametri:  
```mailtext(messageoutput, inputurl);```  

Per il risultato vedere la funzione mailtext.  


##Funzione di primo avvio.  
Usata per scrivere la lista dei siti supportati, preparare il messaggio del modulo di contatto e, soltanto su video.daniil.it, nascondere il modulo php ed usare la versione Jquery del programma.


###Utilizzo:
```
firstload(supportedurls, separatorstart, separatorend, messageoutput, videodaniilit)  
```

###Parametri:  

###supportedurls: elemento html di output per la lista dei siti supportati. Obbligatorio.  
Esempio: ```#supportedurls```. 

###separatorstart: il primo separatore della lista degli indirizzi: verrà inserito prima di ogni elemento della lista dei siti, se vuoto diventa ```<br>```. Opzionale, raccomandato.  
Esempio: ```<li>```  

###separatorend: il primo separatore della lista degli indirizzi: verrà inserito dopo ogni elemento della lista dei siti, se vuoto diventa ```<br>```. Opzionale, raccomandato. 
Esempio: ```</li>```  

###messageoutput: elemento html di output per il testo del modulo di contatto. Opzionale, raccomandato.  
Esempio: ```#contact ```


###videodaniilit: Se su video.daniil.it nasconde il modulo php ed usa la versione Jquery del programma.


###Esempio:  
```
firstload("#supportedurls", "<li>", "</li>", "#message");  
```

Diciamo che la lista dei siti supportati sia: ```a b c d```. 

L'output scritto su ```#supportedurls``` è:

```
<li>a</li><li>b</li><li>c</li><li>d</li><a href="http://lol.daniil.it" target="_blank">&#9786;</a></li>
```

Questo inserirà anche il testo nel modulo di contatto con  
```
mailtext("#message");  
```


##Funzione del modulo di contatto. 
Scrive un bel messaggio nel modulo di contatto con l'indirizzo se è dato, altrimenti soltanto con ```insert link```.  

###Utilizzo:  
```
mailtext(output, url);  
```

###Parametri:  

###output: elemento html dove scrivere il messaggio del modulo di contatto:  
Esempio: ```#contact```



###url: L'indirizzo del video da inserire nel messaggio.  Non Obbligatorio, se non dato viene sostituito da ```insert link```.

  

###Esempio:  
```
mailtext("#contact", "http://google.com");  
```

Scriverà  
```
The video:
http://google.com
does not download, could you please fix it
Thanks!
```

su ```#contact```.  



# Script Bash.

## Istruzioni di utilizzo dello script bash:  
```
video.sh [ -qabp=player ] URL URL2 URL3 ...
video.sh [ -qabfp=player ] URLS.txt URLS2.txt URLS3.txt ...

Non dimenticarti di mettere l'URL tra virgolette se contiene caratteri speciali come & o #.


Apri con ./video.sh se hai installato lo script in una directory non inserita nella $PATH.


Opzioni:




-q:	Modalità silenziosa. Utile per programmazioni in crontab, abilita automaticamente -a.


-a:	Modalità Automatica/Andrea: scarica automaticamente la massima qualità dei video.


-b:	Usa la API interna: richiede più programmmi aggiuntivi e potrebbe non funzionare su qualche dispositivo, ma potrebbe anche essere più veloce del server API.


-f:	Leggi gli URL da uno o più file di testo.


-p player:	Riproduci il video invece di scaricarlo utilizzando il player specificato, se non viene specificato viene usato mplayer.


--help:	Fa vedere questo messaggio.



```


## Istruzioni di installazione dello script bash:

### Sistemi debian o derivati (Ubuntu, Linux mint, Bodhi Linux, ecc...)

Su sistemi debian o derivate, esegui questo comando per aggiungere la mia repo al sistema:


```
sudo wget -q -O /etc/apt/sources.list.d/daniil.list http://dano.cu.cc/1IJrcd1 && wget -q -O - http://dano.cu.cc/1Aci9Qp | sudo apt-key add - && sudo apt-key adv --recv-keys --keyserver keys.gnupg.net 72B97FD1D9672C93 && sudo apt-get update
```


Dovresti vedere un OK se la operazione si conclude con successo.


E questo comando per installare lo script.


```
sudo apt-get update && sudo apt-get -y install video-dl
```



### Qualsiasi sistema Linux/Unix (Ubuntu, Debian, Fedora, Redhat, openBSD, Mac OS X):

Esegui questo comando per installare lo script:

```
wget http://daniilgentili.magix.net/video.sh -O video.sh || curl -L http://daniilgentili.magix.net/video.sh -o video.sh; chmod +x video.sh
```

Esegui il programma con: ```./video.sh``` nella directory dove l'hai scaricato.

Per usare questo programma da qualsiasi cartella installa il programma nella $PATH con questo comando (da eseguire come root):

```
wget http://daniilgentili.magix.net/video.sh -O /usr/bin/video.sh || curl -L http://daniilgentili.magix.net/video.sh -o video.sh; chmod +x /usr/bin/video.sh
```

Ora potrai eseguire lo script da qualsiasi cartella con: ```video.sh```



### Android:


### Metodo 1 (app).
Abilita sorgenti sconosciute e installa [questa applicazione](http://bit.ly/0192837465k).

L'applicazione presenta una semplice interfaccia molto simile alla versione web.

### Changelog:

1: versione iniziale

1.2: aggiunti i pulsanti non funziona, condividi e ringraziamenti

1.2.1: aggiunta l'opzione di condivisione dall'esterno, corretti problemi

1.2.2: Aggiustato il pulsante non funzione con URL ricevuti da condivisione esterna, aggiunto google analytics e aggiustato il malfunzionamento dei video rai replay con condivisione esterna.

1.3: Aggiunto l'aggiornamento automatico.

1.4: Aggiunto link nei ringraziamenti


### Da fare:

Dimmi tu cosa posso aggiungere nelle versioni sucessive!

### Metodo 2 (script).
### Installa [Busybox](https://play.google.com/store/apps/details?id=stericson.busybox), [Emulatore Terminale](https://play.google.com/store/apps/details?id=jackpal.androidterm) e [Bash](https://play.google.com/store/apps/details?id=com.bitcubate.android.bash.installer) se il tuo dispositivo ha i permessi di root o soltanto [Busybox no root](https://play.google.com/store/apps/details?id=burrows.apps.busybox) se il tuo dispositivo non è rootato. 


[Video tutorial](https://www.youtube.com/watch?v=4NLs2NzHbbc)


Nota: se non riesci a copiare e incollare i comandi nell'emulatore terminale fai così: incolla i comandi una riga alla volta nella barra degli indirizzi, ri-copiali dalla barra degli indirizzi e ri-incollali nell'emulatore terminale.
Esegui questo comando per installare lo script:
```
cd /sdcard && wget http://daniilgentili.magix.net/android/video.sh 
```

Eseguilo con:
```
bash /sdcard/video.sh
```



Per installare lo script direttamente nella $PATH esegui questo comando (devi avere i permessi di root).


```
su
mount -o rw,remount /system && wget http://daniilgentili.magix.net/android/video.sh -O /system/bin/video.sh && chmod 755 /system/bin/video.sh
```

Ora dovresti essere in grado di eseguire lo script con un ```video.sh```.


Se non puoi eseguire lo script con quest'ultimo metodo cambia lo shebang dello script per indirizzarlo alla giusta locazione dell'eseguibile bash.

### iOS:
Fai il Jailbreak al tuo dispositivo, aggiungi questa repo Cydia,

```
http://repo.daniil.it
```

... e installa mobileterminal e video-dl.


Esegui lo script con video.sh in mobileterminal.

Per eseguire e importare il video usa iFile o Filza.


### Windows:
Installa [Cygwin](https://www.cygwin.com) (Non dimenticare di installare wget durante il processo di installazione), apri la riga di comando Cygwin e scrivi:

```
wget http://daniilgentili.magix.net/win/video.sh -O video.sh
```

Esegui lo script con:
```
./video.sh "URL"
```

Nella directory dove lo hai scaricato.

Per usare lo script da qualsiasi directory usa questo comando.

```
cd /bin && wget http://daniilgentili.magix.net/win/video.sh -O video.sh && cd $OLDPWD
```


Ora dovresti essere in grado di eseguirlo con un: ```video.sh "URL"```.

# API

Questo progetto include anche una API.

Il codice sorgente della API può essere visualizzato [qui](https://github.com/danog/video-dl/blob/master/api).

La API usa [youtube-dl](https://github.com/rg3/youtube-dl) per ottenere i link di scaricamento per siti a parte la7/rai/mediaset/dplay/wittytv.

La API supporta richieste GET e il punto di accesso è http://api.daniil.it (supporta https).

### Esempio di utilizzo API

### Parametri supportati:


### url

Il valore di questo parametro deve essere l'indrizzo codificato (percent encoding) del video. La risposta sarà il titolo e una lista di indirizzi con il nome della corrispondente qualità, il formato, la risoluzione e la dimensione.


Esempio:

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

Nome per il salvataggio del video in un file  Nome originale del video per informazione


```
Highest quality (mp4, 286MB, 1024x576) http://creativemedia4.rai.it/Italy/podcastcdn/junior/Winx/Winx_6_puntate/2189463_1800.mp4
```

Nome della qualità (formato, dimensione, risoluzione) indirizzo del video

```
Medium-low quality (mp4, 131MB, 700x394) http://creativemedia4.rai.it/Italy/podcastcdn/junior/Winx/Winx_6_puntate/2189463_800.mp4
```

Nome della qualità (formato, dimensione, risoluzione) indirizzo del video

Le qualità sono ordinate in ordine decrescente della risoluzione.


### p

Supporta i seguenti valori:

```
websites
```

ritorna una lista accorciata dei siti supportati.


```
allwebsites
```

ritorna la lista completa dei siti supportati.



## Contribuisci


Se hai creato un'altra versione di questo programma utilizzando la API [contattami](http://daniil.it/) e io la metterò su questa pagina!



Ecco qua!

Buona visione!

[Daniil Gentili](http://daniil.it)
