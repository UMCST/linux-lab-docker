FROM centos:latest
ENV container docker

#SystemD likes a special signal to stop
STOPSIGNAL SIGRTMIN+3

#By default the yum.conf in docker has some stuff disabled
#We'll use our own
COPY conf/yum.conf /etc/yum.conf

RUN yum install -y iproute sudo man-pages man vim nano nmap-ncat wget
RUN yum install -y openssh openssh-server epel-release git tmux zsh
RUN yum update -y
#For some newer software
RUN yum install -y https://centos7.iuscommunity.org/ius-release.rpm
RUN yum install -y python36u nginx
RUN systemctl enable nginx
RUN systemctl enable sshd

RUN adduser admin
RUN echo 'admin:cybersec$1' | chpasswd
#now we sudoing
RUN usermod -a -G wheel admin
# set root's password to something random (I'm proud of this one)
RUN echo "root:$(cat /dev/random | head --bytes 6)" | chpasswd


# to enable systemd in this container we're doing some creative stuff
# based on this article: https://developers.redhat.com/blog/2016/09/13/running-systemd-in-a-non-privileged-container/
CMD ["/sbin/init"]
