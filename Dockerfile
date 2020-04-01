FROM debian:stretch
MAINTAINER Ibere Luiz Di Tizio Jr <ibere.tizio@gmail.com>

ARG NETXMS_VERSION_AGENT=3.2.451-1

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update && \
    apt-get -y install --no-install-recommends curl apt-transport-https libssh-4 gnupg2 && \
    curl -sL http://packages.netxms.org/netxms.gpg | apt-key add - && \
    echo "deb http://packages.netxms.org/debian/ stretch main" > /etc/apt/sources.list.d/netxms.list && \
    apt-get update && \
    apt-get -y install netxms-agent=$NETXMS_VERSION_AGENT && \
    \
    apt-get -y install locales && \
    sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen && \
    dpkg-reconfigure --frontend noninteractive locales && \
    \
    apt-get -qq clean

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US \
    LC_ALL=en_US.UTF-8

VOLUME /data

EXPOSE 4700

COPY  ./ssh.nsm /usr/lib/x86_64-linux-gnu/netxms/
COPY ./docker-entrypoint.sh /

RUN  chmod 755 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
