FROM ubuntu

RUN apt-get update &&\
  apt-get install -y tmux patat openssh-server sudo vim python3 python3-pip &&\
  mkdir /var/run/sshd &&\
  sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd &&\
  pip3 install termdown &&\
  adduser --shell /bin/bash cybersec && echo 'cybersec:cybersec$1' | chpasswd

COPY ./ /home/cybersec/lab
COPY sshd_config /etc/ssh/sshd_config
COPY init.sh /home/cybersec/.bashrc
COPY start.sh /root/start.sh
RUN chown cybersec /home/cybersec/.bashrc && chmod 644 /home/cybersec/.bashrc

EXPOSE 222

CMD ["/bin/bash", "/root/start.sh"]

