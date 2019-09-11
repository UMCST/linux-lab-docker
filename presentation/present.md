---
title: "Introduction to Linux Security"
author: "@UMCST"
patat:
  images:
    backend: w3m
---

# Welcome

```sh
ssh cybersec@linuxlab.ndieff.dev -p 222
# password is cybersec$1
```

# Why do we care about Linux?


# A history of Linux in 30 seconds

- K&R invented Unix

- Richard Stallman wanted Unix free for everyone

- Linus Torvalds creates the Linux kernel as a hobby project

- Google adopts Linux as its server OS

- Linux takes over the world

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


# Linux Security - Services


# Good Luck!

