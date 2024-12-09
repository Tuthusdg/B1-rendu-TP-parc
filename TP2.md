# Partie I : Des beaux one liner

## 1. Intro

```bash
[unuser@node1 ~]$ free -mh | grep Mem | tr -s ' ' | cut -d' ' -f7
1.4Gi
```

## 2. Let's go

🌞 Afficher la quantité d'espace disque disponible

```bash
[unuser@node1 ~]$ df -h | grep rl_vbox | tr -s ' ' | cut -d' ' -f4
16G
```

🌞 Afficher combien de fichiers il est possible de créer

```bash
[unuser@node1 ~]$ df -i | grep rl_vbox | tr -s ' ' | cut -d' ' -f4
8879629
```


🌞 Afficher l'heure et la date

```bash
[unuser@node1 ~]$ date "+%D %T"
12/09/24 16:44:58
```

🌞 Afficher la version de l'OS précise

```bash
[unuser@node1 ~]$ cat /etc/os-release | grep PRETTY | cut -d'"' -f2
Rocky Linux 9.5 (Blue Onyx
```

🌞 Afficher la version du kernel en cours d'utilisation précise

```bash
[unuser@node1 ~]$ uname -r
5.14.0-503.14.1.el9_5.x86_64
```

🌞 Afficher le chemin vers la commande python3

```bash
[unuser@node1 ~]$ which python3
/usr/bin/python3
```

🌞 Afficher l'utilisateur actuellement connecté
```bash
[unuser@node1 ~]$ echo $USER
unuser
```

🌞 Afficher le shell par défaut de votre utilisateur actuellement connecté

``` bash
[unuser@node1 ~]$ cat /etc/passwd | grep "$USER" |cut -d':' -f7
/bin/bash
```

```bash
[unuser@node1 ~]$ rpm -qa | wc -l
347
```