FROM ubuntu:latest

RUN apt-get update && apt-get install -y python-pip \
  ssh \
  iputils-ping \
  vim \
  less \
  git \
  netcat \
  python \
  && pip install pssh

WORKDIR /root

COPY ./very_important_account .ssh/id_rsa
RUN chmod 600 .ssh/id_rsa

COPY pssh_hostfile.txt pssh_hostfile.txt
COPY do_evil.sh do_evil.sh
COPY post_install.sh post_install.sh
RUN chmod +x post_install.sh \
  && echo "StrictHostKeyChecking=no" >> /etc/ssh/ssh_config
