FROM ubuntu:22.04

MAINTAINER Brayan Perera
ARG ARACHNI_MAJOR_VERSION=1.6.1.3
ARG ARACHNI_VERSION=1.6.1.3-0.6.1.1
ENV SERVER_ROOT_PASSWORD arachni
ENV ARACHNI_USERNAME arachni
ENV ARACHNI_PASSWORD password
ENV DB_ADAPTER sqlite

RUN apt-get update && apt-get upgrade -y

RUN apt-get -y install \
    wget \
    curl \
    unzip

#COPY "$PWD"/${ARACHNI_VERSION}-linux-x86_64.tar.gz ${ARACHNI_VERSION}-linux-x86_64.tar.gz
RUN wget https://github.com/Arachni/arachni/releases/download/v${ARACHNI_MAJOR_VERSION}/arachni-${ARACHNI_VERSION}-linux-x86_64.tar.gz && \
    tar xzvf arachni-${ARACHNI_VERSION}-linux-x86_64.tar.gz && \
    mv arachni-${ARACHNI_VERSION}/ /usr/local/arachni && \
    rm -rf *.tar.gz
RUN mkdir -p /usr/local/arachni/.system/logs/webui /usr/local/arachni/.system/tmp
COPY "$PWD"/files /
EXPOSE 9292

ENTRYPOINT ['/usr/local/bin/entrypoint.sh']