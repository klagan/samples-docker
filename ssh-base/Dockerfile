FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN  apt-get update && \ 
     apt-get install -y --no-install-recommends dialog && \
     apt-get update && \
     apt-get install -y --no-install-recommends openssh-server && \
     apt-get update && \
     apt-get install -y apache2 && \
     apt-get install -y apache2-utils && \
     apt-get clean && \
     echo "root:Docker!" | chpasswd 

EXPOSE 80 2222

COPY sshd_config /etc/ssh/

COPY startup.sh /opt/startup/startup.sh

RUN mkdir /run/sshd

RUN chmod +x /opt/startup/startup.sh

ENTRYPOINT ["/opt/startup/startup.sh"]
