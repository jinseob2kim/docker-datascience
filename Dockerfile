FROM ubuntu:18.04

MAINTAINER Jinseob Kim "jinseob2kim@gmail.com"

# Install dependencies and Download 
RUN apt-get update && apt-get install -y \
    vim \
    texlive-full \
    python3
    python3-pip \
    nginx && \
    pip3 install jupyter

    
EXPOSE 8787 8888 3838

    