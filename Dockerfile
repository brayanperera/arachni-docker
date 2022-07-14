FROM ubuntu:22.04

MAINTAINER Brayan Perera
ARG ARACHNI_MAJOR_VERSION=1.6.1.3
ARG ARACHNI_VERSION=1.6.1.3-0.6.1.1
ENV SERVER_ROOT_PASSWORD arachni
ENV ARACHNI_USERNAME arachni
ENV ARACHNI_PASSWORD password
ENV DB_ADAPTER sqlite

RUN apt-get update && apt-get upgrade -y

RUN apt-get -y install wget curl unzip gnupg2

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
RUN apt-get update && apt-get install google-chrome-stable -y

#COPY "$PWD"/${ARACHNI_VERSION}-linux-x86_64.tar.gz ${ARACHNI_VERSION}-linux-x86_64.tar.gz
RUN wget https://github.com/Arachni/arachni/releases/download/v${ARACHNI_MAJOR_VERSION}/arachni-${ARACHNI_VERSION}-linux-x86_64.tar.gz && \
    tar xzvf arachni-${ARACHNI_VERSION}-linux-x86_64.tar.gz && \
    mv arachni-${ARACHNI_VERSION}/ /usr/local/arachni && \
    rm -rf *.tar.gz
RUN mkdir -p /usr/local/arachni/.system/logs/webui /usr/local/arachni/.system/tmp
RUN wget https://chromedriver.storage.googleapis.com/103.0.5060.53/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip && mv chromedriver /usr/local/arachni/.system/usr/bin/chromedriver
RUN rm -rf /usr/local/arachni/.system/opt/google/chrome && ln -s /opt/google/chrome /usr/local/arachni/.system/opt/google/chrome

RUN useradd -u 1000 arachni
RUN chown -R arachni:arachni /usr/local/arachni
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh


USER arachni

EXPOSE 9292

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]