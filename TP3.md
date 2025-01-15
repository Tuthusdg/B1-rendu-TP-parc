# TP3 
## Partie II : Serveur de streaming
### 1.Preparation de la machine

🌞 Création d'un dossier où on hébergera les fichiers de musique

```bash
[unuser@music srv]$ ls
music
```

🌞 Installer le paquet jellyfin

```bash
sudo dnf install jellyfin
```

🌞 Lancer le service jellyfin

```bash
sudo systemctl star jellyfin
```

🌞 Afficher la liste des ports TCP en écoute

```bash
[unuser@music ~]$ sudo ss -lnpt | grep jellyfin
LISTEN 0      512          0.0.0.0:8096      0.0.0.0:*    users:(("jellyfin",pid=3997,fd=310))
```

🌞 Ouvrir le port derrière lequel Jellyfin écoute

```bash
sudo firewal-cmd --permanent --add-port=8096/tcp
```

🌞 Visitez l'interface Web !

```bash
PS C:\Users\maybelater\Documents\ecole\EfrEI\B1\B1-rendu-TP-parc> curl http://10.3.1.11:8096
                                                             arc>

StatusCode        : 200
StatusDescription : OK
Content           : <!doctype html><html
                    class="preload"><head><meta
                    charset="utf-8"><meta name="viewport" co 
                    ntent="width=device-width,initial-scale= 
                    1,minimum-scale=1,maximum-scale=1,user-s 
                    calable=no,viewport-fit=cover">...       
RawContent        : HTTP/1.1 200 OK
                    X-Response-Time-ms: 0
                    Accept-Ranges: bytes
                    Content-Length: 7442
                    Content-Type: text/html
                    Date: Fri, 10 Jan 2025 21:03:21 GMT      
                    ETag: "1da23514f439592"
                    Last-Modified: Thu, 30 Nov 20...
Forms             : {}
Headers           : {[X-Response-Time-ms, 0],
                    [Accept-Ranges, bytes],
                    [Content-Length, 7442], [Content-Type,   
                    text/html]...}
Images            : {}
InputFields       : {}
Links             : {}
ParsedHtml        : mshtml.HTMLDocumentClass
RawContentLength  : 7442

```

## Partie III:Serveru de monitoring

```bash
curl https://get.netdata.cloud/kickstart.sh > /tmp/netdata-kickstart.sh && sh /tmp/netdata-kickstart.sh --no-updates --stable-channel --disable-telemetry

```

🌞 Ajouter un check TCP

```bash

jobs:
  - name: WEB.monitoring.TP3.B1
    host: 10.3.1.12
    ports:
      - 19999

  - name: SSH.Jelly.fin
    host: 10.3.1.1
    ports:
      - 22
```

## Partie IV : Serveur de backup

### 1.intro

🌞 Partitionner le disque dur
```bash
[unuser@backup ~]$ sudo pvcreate /dev/sdb
[sudo] password for unuser:
Physical volume "/dev/sdb" successfully created.

[unuser@backup ~]$ sudo vgcreate data /dev/sdb
Volume group "data" successfully created

[unuser@backup ~]$ sudo lvcreate -l 100%FREE data -n backup_data
Logical volume "backup_data" created.

[unuser@backup ~]$ sudo mkfs -t ext4 /dev/data/backup_data
mke2fs 1.46.5 (30-Dec-2021)
Creating filesystem with 1309696 4k blocks and 327680 inodes
Filesystem UUID: 469a1ff2-f16e-4123-adff-58a47e2bd056
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done
```

🌞 Monter la partition
```bash
[unuser@backup mnt]$ sudo mkdir backup
[unuser@backup mnt]$ sudo mount /dev/data/backup_data /mnt/backup/
```

## El cliente

🌞 Essayer d'accéder au dossier partagé
```bash
[unuser@music mnt]$ sudo mount 10.3.1.13:/mnt/music_backup/ /mnt/music_backup/
```
🌞 Configurer un montage automatique
```bash
[unuser@music ~]$ cat /etc/fstab
#
# /etc/fstab
# Created by anaconda on Fri Jan 10 14:03:32 2025
#
# Accessible filesystems, by reference, are maintained under '/dev/disk/'.
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info.
#
# After editing this file, run 'systemctl daemon-reload' to update systemd
# units generated from this file.
#
/dev/mapper/rl_vbox-root /                       xfs     defaults        0 0
UUID=edd507b4-c0c0-4aee-b99e-a56b0d3a6c0a /boot                   xfs     defaults        0 0
/dev/mapper/rl_vbox-swap none                    swap    defaults        0 0
10.3.1.13:/mnt/music_backup/ /mnt/music_backup   nfs     defaults        0 0
```

🌞 Utiliser et tester le nouveau service

```bash
[unuser@music system]$ systemctl status backup
○ backup.service - "Sert a sauvegardé la musique sur un serveur de backup"
     Loaded: loaded (/etc/systemd/system/backup.service; disabled; preset: >
     Active: inactive (dead)

```

🌞 Faire un test et prouvez que ça a fonctionné
```
[unuser@music system]$ date
Tue Jan 14 06:48:12 PM CET 2025
[unuser@music system]$ sudo systemctl start backup
[unuser@music system]$ cd /mnt/music_backup/
[unuser@music music_backup]$ ls
music_250112_180427.tar.gz  music_250112_181159.tar.gz  music_250112_190317.tar.gz  music_250114_184823.tar.gz <----- sauvegarde 
music_250112_180914.tar.gz  music_250112_184720.tar.gz  music_250112_190540.tar.gz
music_250112_181111.tar.gz  music_250112_185252.tar.gz  music_250112_190703.tar.gz
```
