FROM ubuntu:18.04

MAINTAINER Jinseob Kim "jinseob2kim@gmail.com"

# Change the docker default timezone from UTC to Seoul
echo "Asia/Seoul" > /etc/timezone

# Install dependencies and Download 
RUN apt-get update && apt-get install -y \
    file \
    curl \
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
    pip3 install jupyter && \
    rm -rf /var/lib/apt/lists/*


# Install Rstudio-server
ARG RSTUDIO_VERSION

RUN RSTUDIO_LATEST=$(wget --no-check-certificate -qO- https://s3.amazonaws.com/rstudio-server/current.ver) && \ 
    [ -z "$RSTUDIO_VERSION" ] && RSTUDIO_VERSION=$RSTUDIO_LATEST || true && \
    wget -q http://download2.rstudio.org/rstudio-server-${RSTUDIO_VERSION}-amd64.deb && \
    dpkg -i rstudio-server-${RSTUDIO_VERSION}-amd64.deb && \
    rm rstudio-server-*-amd64.deb 


# Install Shiny server
RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-14.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-14.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb && \
    R -e "install.packages(c('shiny', 'rmarkdown','ggplot','data.table','DT'), repos='https://cran.rstudio.com/')" 


# Add user 
RUN adduser math --gecos 'First Last,RoomNumber,WorkPhone,HomePhone' --disabled-password && \
    sh -c 'echo math:math | sudo chpasswd' && \
    usermod -aG sudo math
    
    
EXPOSE 8787 8888 3838

    