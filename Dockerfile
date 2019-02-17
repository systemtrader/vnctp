FROM ubuntu:16.04

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENV DEBIAN_FRONTEND=noninteractive \
    USER=root

RUN apt-get clean \
    && apt-get update \
    && apt-get install -y wget gcc build-essential cmake \
    && apt-get install -y python3 python3-dev python3-pip \
    && apt-get install -y mpi-default-dev libicu-dev libbz2-dev

WORKDIR /root/vnctp

COPY user-config.jam /root/

# Install boost manually
RUN wget http://sourceforge.net/projects/boost/files/boost/1.66.0/boost_1_66_0.tar.gz/download \
    && mv download boost_1_66_0.tar.gz \
    && tar -xvzf boost_1_66_0.tar.gz && cd ./boost_1_66_0 \
    && ./bootstrap.sh --with-python=/usr/bin/python3 --with-python-version=3.5 --with-libraries=python,locale,thread,date_time,system,chrono \
    && ./b2 install \
    && /bin/sh

# ./build.sh

EXPOSE 22