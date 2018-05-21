FROM rocker/shiny:latest

MAINTAINER Jinseob Kim "jinseob2kim@gmail.com"

# Install dependencies and Download and install shiny server
RUN apt-get update && apt-get install -y -t unstable \
    texlive-full && \
    nginx && \
    wget https://github.com/jinseob2kim/docker-datascience/archive/master.zip && \
    unzip docker-datascience-master.zip && \
    cp -R ~/docker-datascience-master/etc/nginx/RStudioAMI /etc/nginx && \
    cp -R ~/docker-datascience-master/etc/rstudio/rserver.conf /etc/rstudio && \
    cp -R ~/docker-datascience-master/etc/nginx/sites-available/RStudioAMI.conf /etc/nginx/sites-available && \
    cp -R ~/docker-datascience-master/etc/nginx/sites-enable/RStudioAMI.conf /etc/nginx/sites-enable && \
    rm -Rf ~/docker-datascience-master && \
    