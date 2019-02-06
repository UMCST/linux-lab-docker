# Linux lab backdoors

1. SSH key in root's account

- copied over in docker file

2. Extra account

- called "very_important_account"
- password is "IAMAHACKER"
- run in script

3. TCP netcat shell on crontab

- stored in /etc/crontab
- runs every minute
- runs from script
- Listens on port 666

4. reverse shell to web1.umcstlab.net:4000/tcp, triggered by the md5sum command

- runs from script
- the evil script is in /usr/local/sbin/md5sum

5. evil SystemD timer

- tries to download and execute a file from web1.umcstlab.net:8080/run.sh

6. repurpose an existing system account

- the ftp account has a login shell now
- the credentials to the account are ftp/cybersec

7. reverse UDP shell going to port 53

- requires manual setup

8. A backdoor in PAM

- A new PAM library called `pam_extra.so` is placed in `/usr/lib65/security`
- The PAM config file for sshd `/etc/pam.d/sshd` is edited so that it will use this
  evil library as an alternative way to authenticate
- You can login to any account over ssh with the password "I_like_hacks"

## Ideas for the future

- web shell at /not-a-malicious-url/index.php
- Evil binaries
- Evil Nginx Module
- Evil processes only in net and mnt namespaces, not all
