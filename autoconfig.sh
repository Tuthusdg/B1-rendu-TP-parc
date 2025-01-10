#!/bin/bash
if [[ "$(id -u)" != 0 ]];
then 
    echo "Le script doit être lancer en tant que root"
    exit 
fi
DATE=$(date +%H:%M:%S)
SELINUX_STATUS=$(sestatus | grep "Current mode"| cut -d' ' -f21)
SELINUX_FILE=$(sestatus |grep "Mode from config file"| cut -d' ' -f14)
FIREWALL=$(firewall-cmd --state)
SSH_PORT=$(cat /etc/ssh/sshd_config | grep "Port" | tr -s ' ' | cut -d' ' -f2| head -n 1)
NEW_PORT_SSH=$RANDOM
IS_WHEEL=groups unuser | grep -o wheel
echo "$DATE  [INFO]  Le script d'autoconfiguration a démarré "
echo "$DATE  [INFO]  Le script à bien été lancé en root "

if [[ "$SELINUX_STATUS" != "permissive" && "$SELINUX_FILE" != "permissive" ]]; 
then 
    echo "$DATE  [WARN]  SELinux est toujours activé ! "
    if [[ "$SELINUX_STATUS" != "permissive" ]]; 
    then
        setenforce 0
        echo "$DATE  [INFO]  Désactivation temporaire de selinux"
    fi
    if [[ "$SELINUX_FILE" != "permissive" ]];
    then
        sed -i 's/enforcing/permissive/g' /etc/selinux/config
        echo "$DATE  [INFO]  Désactivation définitive de selinux "
    fi
fi

if [[ "$FIREWALL" != "running" ]];
then
    echo "$DATE  [WARN]  le firewalld est désactivé"
    systemctl start firewalld
    echo "$DATE  [INFO]  activation du firewalld"
fi 
echo "$DATE  [INFO]  Le firewalld est actif"



if [[ "$SSH_PORT" == "22" ]];
then 
    echo "$DATE  [WARN]  SSH tourne sur le port 22"
    sed -i "s/#Port 22 /Port $NEW_PORT_SSH/" /etc/ssh/sshd_config
    echo "$DATE  [INFO]  SSH tourne maintenant sur le port $NEW_PORT_SSH"
    systemctl restart sshd
    echo "$DATE  [INFO]  Redemmarage du service SSH"
    sudo firewall-cmd --permanent --add-port="$NEW_PORT_SSH"/tcp
    sudo firewall-cmd --permanent --remove-port=22/tcp
    sudo firewall-cmd --reload
fi


if [[ hostname == "localhost" ]];
then 
    echo "$DATE [WARN] La machine s'appelle toujours localhost !"
    echo "Veuillez entrez le nom pour la machine: "
    read nom_machine
    hostnamectl set-hostname $nom_machine
    echo " $DATE [INFO] Changement de nom pour $nom_machine"
fi
 
if [[ "$IS_WHEEL" != "wheel" ]];
then 
    echo "$DATE [WARN] unuser n'est pas dans wheel!"
    usermod -aG wheel unuser
    echo "$DATE [INFO] unuser est maintenant dans wheel"
fi

echo " Fin du script d'autoconfiguration"