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


## Ideas for the future
- web shell at /not-a-malicious-url/index.php
- Evil binaries
- Evil processes only in net and mnt namespaces, not all
