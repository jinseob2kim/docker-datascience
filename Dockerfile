FROM rocker/shiny:latest

MAINTAINER Jinseob Kim "jinseob2kim@gmail.com"

# Install dependencies and Download and install shiny server
RUN apt-get update && apt-get install -y -t unstable \
    texlive-full && \
    nginx 

    
EXPOSE 8787

    