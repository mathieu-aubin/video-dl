# rai.tv-bash-dl
Rai.tv bash download script.

[Read English version](https://github.com/danog/rai.tv-bash-dl)

Creato da [Daniil Gentili](http://daniil.eu.org), questo script usa il [server](http://video.lazza.dk) di [Andrea Lazzarotto](http://andrealazzarotto.com/) per decodificare gli indirizzi.

Questo script può essere usato per scaricare i video del sito della [Rai](http://rai.tv).


Questo script è in grado di scaricare i video di tutti i siti della Rai, incluso Rai Replay.


Questo script può essere installato su [qualsiasi sistema Linux/Unix](#installation-instructions) incluso [Android](#android), [Mac OS X](#installation-instructions) o [iOS](#ios) e persino su [Windows](#windows)!

È anche disponible [un'applicazione per Android](http://bit.ly/0192837465k).

E per tutte le altre piattaforme c'è la [versione web](http://video.daniil.eu.org/rai.php)!

## Istruzioni di utilizzo:
```
rai.sh [ -qaf [ urls.txt ] ] URL URL2 URL3 ...
```
Opzioni:




-q:	Modalità silenziosa. Utile per programmazioni in crontab, abilita automaticamente -a.


-a:	Modalità Automatica/Andrea: scarica automaticamente la massima qualità dei video utlizzando il server di Andrea.


-f:	Leggi gli URL da uno o più file di testo.


--help:	Fa vedere questo messaggio.



## Istruzioni di installazione:

### Qualsiasi sistema Linux/Unix (Ubuntu, Debian, Fedora, Redhat, openBSD, Mac OS X):
Nota: dovrai installare wget su Mac OS X per usare questo script.
Esegui questo comando per installare lo script:

```
wget http://daniilgentili.magix.net/rai.sh -O rai.sh || curl -L http://daniilgentili.magix.net/rai.sh -o rai.sh; chmod +x rai.sh
```

Esegui il programma con:
```
./rai.sh "URL"
```


Ricorda che è necessario racchiudere l'URL tra virgolette.


Nella directory dove l'hai scaricato.

Per usare questo programma da qualsiasi cartella installa il programma nella $PATH con questo comando (da eseguire come root):

```
wget http://daniilgentili.magix.net/rai.sh -O /usr/bin/rai.sh || curl -L http://daniilgentili.magix.net/rai.sh -o rai.sh; chmod +x /usr/bin/rai.sh
```

Ora potrai eseguire lo script da qualsiasi cartella con:
```
rai.sh "URL"
```


Ricorda che è necessario racchiudere l'URL tra virgolette.





### Android:
#### Metodo 1 (app).
Abilita le sorgenti sconosciute e installa [questa applicazione](http://bit.ly/0192837465k).

L'applicazione presenta una semplice interfaccia molto simile alla versione web.

#### Metodo 2 (script).
##### Installa [Busybox](https://play.google.com/store/apps/details?id=stericson.busybox), [Emulatore Terminale](https://play.google.com/store/apps/details?id=jackpal.androidterm) e [Bash](https://play.google.com/store/apps/details?id=com.bitcubate.android.bash.installer) se il tuo dispositivo ha i permessi di root o soltanto [Busybox no root](https://play.google.com/store/apps/details?id=burrows.apps.busybox) se il tuo dispositivo non è rootato. 

Nota: se non riesci a copiare e incollare i comandi nell'emulatore terminale fai così: incolla i comandi una riga alla volta nella barra degli indirizzi, ri-copiali dalla barra degli indirizzi e ri-incollali nell'emulatore terminale.
Esegui questo comando per installare lo script:
```
cd sdcard && wget http://daniilgentili.magix.net/android/rai.sh 
```

Eseguilo con:
```
bash /sdcard/rai.sh "URL"
```


Ricorda che è necessario racchiudere l'URL tra virgolette.



Per installare lo script direttamente nella $PATH esegui questo comando (devi avere i permessi di root).


```
su
mount -o rw,remount /system && wget http://daniilgentili.magix.net/android/rai.sh -O /system/bin/rai.sh && chmod 755 /system/bin/rai.sh
```

Ora dovresti essere in grado di eseguire lo script con:
```
rai.sh "URL"
```


Ricorda che è necessario racchiudere l'URL tra virgolette.



Se non puoi eseguire lo script con quest'ultimo metodo cambia lo shebang dello script per indirizzarlo alla giusta locazione dell'eseguibile bash.

### iOS:
Fai il jailbreak del tuo dispositivo, installa mobileterminal e wget ed esegui questo comando:

```
wget http://daniilgentili.magix.net/rai.sh -O rai.sh || curl -L http://daniilgentili.magix.net/rai.sh -o rai.sh; chmod +x rai.sh
```

Esegui lo script con:
```
./rai.sh "URL"
```


Ricorda che è necessario racchiudere l'URL tra virgolette.



Nella cartella dove lo hai scaricato.

Per visualizzare i video scaricati usa iFile.

Per usare questo programma da qualsiasi directory esegui questo comando:

```
su -c "wget http://daniilgentili.magix.net/rai.sh -O /usr/bin/rai.sh || curl -L http://daniilgentili.magix.net/rai.sh -o rai.sh; chmod +x /usr/bin/rai.sh"
```

Ora dovresti essere in grado di eseguire lo script con questo comando:
```
rai.sh "URL"
```


Ricorda che è necessario racchiudere l'URL tra virgolette.




### Windows:
Installa [Cygwin](https://www.cygwin.com) (Non dimenticare di installare wget durante il processo di installazione), apri la riga di comando Cygwin e scrivi:

```
wget http://daniilgentili.magix.net/win/rai.sh -O rai.sh
```

Esegui lo script con:
```
./rai.sh "URL"
```


Ricorda che è necessario racchiudere l'URL tra virgolette.



Nella directory dove lo hai scaricato.

Per usare lo script da qualsiasi directory usa questo comando.

```
cd /bin && wget http://daniilgentili.magix.net/win/rai.sh -O rai.sh && cd $OLDPWD
```


Ora dovresti essere in grado di eseguirlo con un:
```
rai.sh "URL"
```


Ricorda che è necessario racchiudere l'URL tra virgolette.




Ecco qua!

Buona visione!

[Daniil Gentili](http://daniil.eu.org/lol)
