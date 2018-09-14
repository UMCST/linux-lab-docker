#Hacker Activity
Things that lab proctors can do to the "web servers" to keep the lab interesting.

To get access to the web servers refer to the backdoors document.

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
