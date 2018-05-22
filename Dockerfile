FROM ubuntu:18.04

MAINTAINER Jinseob Kim "jinseob2kim@gmail.com"

# Install dependencies and Download 
RUN apt-get update && apt-get install -y \
    file \
    git \
    sudo \
    wget \
    gdebi-core \
    vim \
    r-base \
    texlive-full \
    python3 \
    python3-pip \
    nginx && \
    pip3 install jupyter

# Install Rstudio-server
ARG RSTUDIO_VERSION

RUN RSTUDIO_LATEST=$(wget --no-check-certificate -qO- https://s3.amazonaws.com/rstudio-server/current.ver) && \ 
    [ -z "$RSTUDIO_VERSION" ] && RSTUDIO_VERSION=$RSTUDIO_LATEST || true && \
    wget -q http://download2.rstudio.org/rstudio-server-${RSTUDIO_VERSION}-amd64.deb && \
    dpkg -i rstudio-server-${RSTUDIO_VERSION}-amd64.deb && \
    rm rstudio-server-*-amd64.deb && \

    
EXPOSE 8787 8888 3838

    