## Source Image
# Start from Alpine Edge
FROM alpine:edge

## Environment Variables
ENV PERMANENT_PKG openssl zlib bind bash python3 libpcap krb5 curl libmaxminddb
ENV TEMPORARY_PKG cmake make gcc g++ swig bison flex-dev curl-dev krb5-dev zlib-dev libmaxminddb-dev openssl-dev python3-dev libpcap-dev bind-dev

## Dependencies
# Make Sure We're up-to-date
RUN apk update
RUN apk upgrade

# Install Permanent Packages
RUN apk add $PERMANENT_PKG

# Install Temporary (build-time) Packages
RUN apk add $TEMPORARY_PKG

# Add the contents of this directory to /opt/zeekgit
ADD . /opt/zeekgit/

## Compile
RUN cd /opt/zeekgit ; ./configure
RUN cd /opt/zeekgit ; make -j $(nproc)
RUN cd /opt/zeekgit ; make -j $(nproc) install

## Clean Up
# Remove Temporary Packages
RUN apk del --purge $TEMPORARY_PKG
# Remove cache
RUN rm -rf /var/cache/*
RUN rm -rf /tmp/*
RUN rm -rf /root/*
RUN rm -rf /opt/zeekgit
