FROM centos:centos7
RUN yum update -y && yum install -y epel-release
RUN yum install -y sudo \
  man-pages \
  man \
  gcc \
  make \
  iproute \
  tcpdump \
  epel-release \
  openssh \
  openssh-server \
  nmap \
  nmap-ncat \
  git \
  tmux \
  python-pip \
  fish \
  vim \
  pam-devel \
  sshpass \
  && pip install pssh

WORKDIR /root
RUN adduser admin && echo 'admin:welike2hack10!' | chpasswd && usermod -a -G wheel admin
COPY ./very_important_account .ssh/id_rsa
COPY ./pssh_hostfile.txt /home/admin/pssh_hostfile.txt
RUN chmod 600 .ssh/id_rsa

COPY do_evil.sh do_evil.sh
COPY pam pam
COPY post_install.sh post_install.sh
RUN chmod +x post_install.sh \
  && echo "StrictHostKeyChecking=no" >> /etc/ssh/ssh_config
EXPOSE 22
RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa && \
    ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa && \
    ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa -b 521 && \
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ''
ENTRYPOINT ["/usr/sbin/sshd", "-D"]
