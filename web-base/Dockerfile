FROM centos:centos7
ENV container docker

#SystemD needs a special signal to stop correctly
STOPSIGNAL SIGRTMIN+3

#By default the yum.conf in docker has some stuff disabled
#We'll use our own
COPY conf/yum.conf /etc/yum.conf

# Install Wazuh agent
RUN rpm --import https://packages.wazuh.com/key/GPG-KEY-WAZUH
COPY ./conf/wazuh.repo /etc/yum.repos.d/wazuh.repo

RUN yum update -y && yum install -y epel-release
RUN WAZUH_MANAGER="wazuh" WAZUH_AGENT_GROUP="default" yum install -y iproute \
  sudo \
  man-pages \
  man \
  ftp \
  vsftpd \
  vim \
  nano \
  ntp \
  htop \
  gcc \
  make \
  nmap-ncat \
  nmap \
  wget \
  openssh \
  openssh-server \
  rpcbind \
  epel-release \
  git \
  tmux \
  zsh \
  sysvinit-tools \
  screen \
  cronie \
  psmisc \
  bind-utils \
  fish \
  file \
  tcpdump \
  rsyslog \
  nginx \
  wazuh-agent-4.1.4

#For some newer software
RUN mkdir -p /var/www/html \
  && systemctl enable nginx \
  && systemctl enable sshd \
  && systemctl enable ntpd \
  && systemctl enable rpcbind \
  && systemctl enable vsftpd \
  && systemctl enable wazuh-agent

# add the admin user and set it up
RUN adduser admin && echo 'admin:cybersec$1' | chpasswd && usermod -a -G wheel admin
# set root's password to something random (I'm proud of this one)
RUN echo "root:$(cat /dev/random | head --bytes 6)" | chpasswd

# Ports we might want to have fun with
EXPOSE 21
EXPOSE 22
EXPOSE 25
EXPOSE 53/udp
EXPOSE 80
EXPOSE 111
EXPOSE 123
EXPOSE 443
EXPOSE 666
EXPOSE 5601
EXPOSE 8080
EXPOSE 9000
EXPOSE 9200
EXPOSE 9300
EXPOSE 5000/tcp
EXPOSE 5000/udp
EXPOSE 10000

ADD ./conf/nginx.conf /etc/nginx/nginx.conf
# Time to break stuff!
# add key to root's account (backdoor 1)
RUN mkdir /root/.ssh && chmod 700 /root/.ssh
ADD very_important_account.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

# to enable systemd in this container we're doing some creative stuff
# based on this article: https://developers.redhat.com/blog/2016/09/13/running-systemd-in-a-non-privileged-container/
CMD ["/sbin/init"]
