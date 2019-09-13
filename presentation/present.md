---
title: "Introduction to Linux Security"
author: "@UMCST"
patat:
  images:
    backend: w3m
---

# Welcome

To view on your own screen, open a terminal and type:

```sh
ssh cybersec@linuxlab.ndieff.dev -p 222
# password is cybersec$1
```

# Why do we care about Linux?

- Free (as in freedom)

- It runs the cloud

- It runs your microwave

- Red team runs Linux

- Your entire department won't be obsoleted by an intern

# A history of Linux in 30 seconds

```sh
$ termdown 30
```

# What's a terminal
It's a _Teletypewriter_

```sh
> tty 
/dev/pts/0 # my terminal device
```

- Every terminal creates a device file

- A terminal is the best way to interact with a computer

- The parent of many processes

# What's a shell
- Reads and interperates your commands

- Some commands are build into your shell
    * `$ message="HELLO WORLD"`
    * `$ echo $message`

- Other commands are actually programs on your disk
    * `$ which which`
    * `$ cat /dev/urandom`

- The shell has built-in keyboard shortcuts
    * ^C
    * ^R
    * ^L

```sh
> echo $SHELL # that's my shell
```

# A shell works with files

- Read the manual `$ man man`

- You are always working in a folder

- All folders start with `/`, no drives

- Check out your files
```
$ ls
$ ls -lah
$ less /etc/passwd
$ less /dev/urandom
$ touch myfile.txt
$ rm myfile.txt
```

# Linux Security - Users

- Unix was the first mutli-user OS

- Now many user accounts are programs/services instead

- The root user is God

- Keep track of who's online

# Linux Security - Services

- Your system is pretty useless without daemons

- Process 1 is the init system

- Some services listen on ports

```sh
$ ss -tulpn # who's listening?
```

# Good Luck!

