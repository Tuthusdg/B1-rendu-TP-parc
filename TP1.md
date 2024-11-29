# I.service ssh

## 1. analyse du service

S'assurer que le service sshd est démarré
```bash 
[unuser@web ~]$ systemctl status sshd
● sshd.service - OpenSSH server daemon
     Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; preset: enabled)
     Active: active (running) since Fri 2024-11-29 23:40:05 CET; 35min ago
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 717 (sshd)
      Tasks: 1 (limit: 11084)
     Memory: 5.0M
        CPU: 63ms
     CGroup: /system.slice/sshd.service
```

analyser les processus liés au service ssh
```bash
root         717       1  0 Nov29 ?        00:00:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root        1271     717  0 Nov29 ?        00:00:00 sshd: unuser [priv]
unuser      1275    1271  0 Nov29 ?        00:00:00 sshd: unuser@pts/0
unuser      1334    1276  0 00:06 pts/0    00:00:00 grep --color=auto sshd
```



Déterminer le port sur lequel écoute le service ssh

```bash
[unuser@web ~]$ sudo ss -tlnp
[sudo] password for unuser:
State     Recv-Q    Send-Q         Local Address:Port         Peer Address:Port    Process
LISTEN    0         128                  0.0.0.0:22                0.0.0.0:*        users:(("sshd",pid=717,fd=3))
LISTEN    0         128                     [::]:22                   [::]:*        users:(("sshd",pid=717,fd=4))
```

il écoute donc sur le port 22


```bash
[unuser@web ~]$ journalctl -u sshd
Nov 29 23:40:05 web.tp1.b1 systemd[1]: Starting OpenSSH server daemon...
Nov 29 23:40:05 web.tp1.b1 sshd[717]: Server listening on 0.0.0.0 port 22.
Nov 29 23:40:05 web.tp1.b1 sshd[717]: Server listening on :: port 22.
Nov 29 23:40:05 web.tp1.b1 systemd[1]: Started OpenSSH server daemon.
Nov 29 23:53:53 web.tp1.b1 sshd[1271]: Accepted password for unuser from 10.1.1.3 port 65387 ssh2
Nov 29 23:53:53 web.tp1.b1 sshd[1271]: pam_unix(sshd:session): session opened for user unuser(uid=1000) by unuser(ui>
```

identifier le fichier de config de ssh
```bash
[unuser@web ~]$ sudo cat /etc/ssh/sshd_config
[sudo] password for unuser:
#       $OpenBSD: sshd_config,v 1.104 2021/07/02 05:11:21 dtucker Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

# To modify the system-wide sshd configuration, create a  *.conf  file under
#  /etc/ssh/sshd_config.d/  which will be automatically included below
Include /etc/ssh/sshd_config.d/*.conf

# If you want to change the port on a SELinux system, you have to tell
# SELinux about this change.
# semanage port -a -t ssh_port_t -p tcp #PORTNUMBER
#
#Port 22
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::

#HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_ecdsa_key
#HostKey /etc/ssh/ssh_host_ed25519_key

# Ciphers and keying
#RekeyLimit default none

# Logging
#SyslogFacility AUTH
#LogLevel INFO

# Authentication:

#LoginGraceTime 2m
#PermitRootLogin prohibit-password
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10

#PubkeyAuthentication yes

# The default is to check both .ssh/authorized_keys and .ssh/authorized_keys2
# but this is overridden so installations will only check .ssh/authorized_keys
AuthorizedKeysFile      .ssh/authorized_keys

#AuthorizedPrincipalsFile none

#AuthorizedKeysCommand none
#AuthorizedKeysCommandUser nobody

# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes

# To disable tunneled clear text passwords, change to no here!
#PasswordAuthentication yes
#PermitEmptyPasswords no

# Change to no to disable s/key passwords
#KbdInteractiveAuthentication yes

# Kerberos options
#KerberosAuthentication no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
#KerberosGetAFSToken no
#KerberosUseKuserok yes

# GSSAPI options
#GSSAPIAuthentication no
#GSSAPICleanupCredentials yes
#GSSAPIStrictAcceptorCheck yes
#GSSAPIKeyExchange no
#GSSAPIEnablek5users no

# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the KbdInteractiveAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via KbdInteractiveAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and KbdInteractiveAuthentication to 'no'.
# WARNING: 'UsePAM no' is not supported in RHEL and may cause several
# problems.
#UsePAM no

#AllowAgentForwarding yes
#AllowTcpForwarding yes
#GatewayPorts no
#X11Forwarding no
#X11DisplayOffset 10
#X11UseLocalhost yes
#PermitTTY yes
#PrintMotd yes
#PrintLastLog yes
#TCPKeepAlive yes
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
#UseDNS no
#PidFile /var/run/sshd.pid
#MaxStartups 10:30:100
#PermitTunnel no
#ChrootDirectory none
#VersionAddendum none

# no default banner path
#Banner none

# override default of no subsystems
Subsystem       sftp    /usr/libexec/openssh/sftp-server

# Example of overriding settings on a per-user basis
#Match User anoncvs
#       X11Forwarding no
#       AllowTcpForwarding no
#       PermitTTY no
#       ForceCommand cvs server
```

modifier le fichier de conf

```bash
[unuser@web ~]$ echo $RANDOM
12440


[unuser@web ~]$ sudo cat /etc/ssh/sshd_config | grep Port
Port 12440
```


```bash
[unuser@web ~]$ sudo firewall-cmd --list-all | grep 12440
  ports: 12440/tcp
```


redémarrer le service 
```bash
[unuser@web ~]$ sudo systemctl restart sshd
```

connection au port spécifique
```bash
PS C:\Users\maybelater> ssh unuser@10.1.1.1 -p 12440
unuser@10.1.1.1's password:
Last login: Fri Nov 29 23:53:53 2024 from 10.1.1.3
[unuser@web ~]$
```