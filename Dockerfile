# Use a minimal Debian base with archive sources
FROM debian:buster-slim

ARG ILO_IP
ENV OPENSSL_VERSION=1.0.2u
ENV PATH=/usr/local/openssl-1.0.2/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/local/openssl-1.0.2/lib:$LD_LIBRARY_PATH
ENV STUNNEL_VERSION=5.50

COPY stunnel.conf /etc/stunnel/stunnel.conf

RUN sed -i 's|deb.debian.org|archive.debian.org|g' /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99disable-valid-until && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential wget tar perl make gcc libz-dev ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    wget https://www.openssl.org/source/old/1.0.2/openssl-$OPENSSL_VERSION.tar.gz && \
    tar xvf openssl-$OPENSSL_VERSION.tar.gz && \
    cd openssl-$OPENSSL_VERSION && \
    ./config --prefix=/usr/local/openssl-1.0.2 no-shared && \
    make && make install && \
    cd / && rm -rf openssl-$OPENSSL_VERSION* && \
    wget https://www.stunnel.org/archive/5.x/stunnel-$STUNNEL_VERSION.tar.gz && \
    tar xvf stunnel-$STUNNEL_VERSION.tar.gz && \
    cd stunnel-$STUNNEL_VERSION && \
    ./configure --with-ssl=/usr/local/openssl-1.0.2 && \
    make && make install && \
    cd / && rm -rf stunnel-$STUNNEL_VERSION* && \
    sed -i "s|ILO_IP|${ILO_IP}|g" /etc/stunnel/stunnel.conf

EXPOSE 8080

CMD ["stunnel", "/etc/stunnel/stunnel.conf"]
