# builds a linux image with sonar scanner installed
# idea is to install all build tools so we have a "builder" image we can share through a registry

FROM ubuntu:latest AS build-step

ENV SONARQUBE_PROJECT_URL= \
    SONARQUBE_PROJECT_KEY= \
    DEBIAN_FRONTEND=noninteractive
    
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update \
&& apt-get install -y --no-install-recommends \
   unzip \
   wget \
   nodejs \
   npm

RUN mkdir /downloads/sonarqube -p
RUN cd /downloads/sonarqube
RUN wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.2.0.1873-linux.zip
RUN unzip sonar-scanner-cli-4.2.0.1873-linux.zip
RUN mv sonar-scanner-4.2.0.1873-linux /opt/sonar-scanner
