# Linux security in the real world

The `backdoor_walkthrough.md` document describe the process for
finding, and disabling, each back door on a web server. However,
the type of forensic investigation required to do this isn't something
that would realisitically happen in a production environment.

Below are notes on the type of tools that could be used in a real environment
to stop/prevent attackers from filling a server with backdoors like the have
in this lab.

## Credential Management

A linux server has many credentials, secrets which are used to confirm identity,
and it will be easy for attackers to add their own credentials to the existing set.
In the lab, some of these credentials included passwords to user accounts and SSH keys.

In a real environment, passwords should never be used for any SSH access. Passwords
are simply too easy to guess and use. Instead, only SSH keys should be used. The keys
should be controlled from a centralized location, and should be changed regularly.
One tool that could do this is [OpenIAM](https://www.openiam.com/).

## Firewalling

Most of the backdoors could be stopped by proper firewalls. A secure server should
only send and recieve the smallest amount of traffic it needs to do its job.

UMCST has used [nftables](https://wiki.nftables.org/wiki-nftables/index.php/Main_Page)
in the past for Linux firewalls and Palo Alto for network level firewalls.

## Logging and monitoring

If there were better logging an monitoring on the lab systems then the malicious
activity would have been detected instantly. Some things that could have generated
alerts include
* The addition of accounts
* A login on the root account
* New ports listening on the network
* When Nginx stopped working

There are many complete solutions for log management among different systems.
- Splunk
- The ELK stack
- Greylog
- Syslogd

## Automated Backups

The attack in this lab is a very simplistic example of "ransomware". The idea behind 
randomware is that attackers hold you hostage by taking control of your data and
threatening to delete it. If you have good backups for your data, this attack is
pointless, as you will just let the attacker delete your data and then put it back
where it belongs.

A good backup has these characteristics
- It exists in three seperate places
- It exists on two seperate types of storage media
- One of the backups exists in a different geographical location that the others

See https://www.backblaze.com/blog/the-3-2-1-backup-strategy/

Some basic backups on Linux can be accomplished with `rsync` and contab scripts.

You can also use [borg](https://borgbackup.readthedocs.io/en/stable/) in Linux to create compressed and encrypted backups.
