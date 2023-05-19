FROM ubuntu:22.04

RUN sed -i "s/http:\/\/archive.ubuntu.com/http:\/\/mirrors.ustc.edu.cn/g" /etc/apt/sources.list && \
    sed -i "s/http:\/\/security.ubuntu.com/http:\/\/mirrors.ustc.edu.cn/g" /etc/apt/sources.list

RUN apt-get update && \ 
    apt-get -y install sudo openssh-server fping

RUN useradd -m ctf && echo "ctf:ctf" && \
    echo "ctf:ctf" | chpasswd

RUN ssh-keygen -A && \
    /etc/init.d/ssh start && \
    chsh -s /bin/bash ctf

COPY ./src/sudoers /etc/sudoers
COPY ./service/docker-entrypoint.sh /
COPY ./src/sshd_config /etc/ssh/sshd_config

COPY ./src/getcap /usr/bin
COPY ./src/setcap /usr/bin

ENTRYPOINT ["/bin/bash","/docker-entrypoint.sh"]