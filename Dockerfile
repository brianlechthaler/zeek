## Source Image
# Start from Alpine Edge
FROM debian:latest

## Environment Variables
ENV PKG cmake make gcc g++ flex bison libpcap-dev libssl-dev python-dev swig zlib1g-dev

## Dependencies
# Make Sure We're up-to-date
RUN apt-get update -qq
RUN apt-get upgrade -y -qq

# Install Permanent Packages
RUN apt-get install -y -qq $PKG
RUN apt-get autoremove -y -qq
RUN apt-get autoclean -y -qq

# Add the contents of this directory to /opt/zeekgit
ADD . /opt/zeekgit/

## Compile
RUN cd /opt/zeekgit ; ./configure
RUN cd /opt/zeekgit ; make -j $(nproc)
RUN cd /opt/zeekgit ; make -j $(nproc) install

## Clean Up
# Remove caches and build dirs
RUN rm -rf /var/cache/*
RUN rm -rf /tmp/*
RUN rm -rf /root/*
RUN rm -rf /opt/zeekgit
