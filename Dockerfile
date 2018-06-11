FROM ubuntu:18.04

MAINTAINER Jinseob Kim "jinseob2kim@gmail.com"

# Setup apt to be happy with no console input
ENV DEBIAN_FRONTEND noninteractive

# Install dependencies and Download 

RUN apt-get update && apt-get install -y \
    udev \
    locales \
    software-properties-common \
    file \
    curl \
    git \
    sudo \
    wget \
    gdebi-core \
    vim \
    r-base \
    psmisc \
    python3 \
    python3-pip \
    npm \
    nodejs \
    supervisor \
    nginx && \
    npm install -g configurable-http-proxy && \
    pip3 install jupyterhub && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Prevent bugging us later about timezones
RUN ln -fs /usr/share/zoneinfo/Asia/Seoul /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata

# Use UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8


# Update R -latest version
#RUN echo "deb http://cran.rstudio.com/bin/linux/ubuntu bionic/" | sudo tee -a /etc/apt/sources.list && \
#    gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9 && \
#    gpg -a --export E084DAB9 | sudo apt-key add - && \
#    apt-get update && \
#    apt-get install r-base r-base-dev

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
    R -e "install.packages(c('shiny', 'rmarkdown'), repos='https://cran.rstudio.com/')" 



# Add user 
RUN adduser math --gecos 'First Last,RoomNumber,WorkPhone,HomePhone' --disabled-password && \
    sh -c 'echo math:math | sudo chpasswd' && \
    usermod -aG sudo math

    
# Run rstudio-server & shiny-server
RUN mkdir -p /var/log/shiny-server \
	&& chown shiny:shiny /var/log/shiny-server \
	&& chown shiny:shiny -R /srv/shiny-server \
	&& chmod 777 -R /srv/shiny-server \
	&& chown shiny:shiny -R /opt/shiny-server/samples/sample-apps \
	&& chmod 777 -R /opt/shiny-server/samples/sample-apps 

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN mkdir -p /var/log/supervisor \
	&& chmod 777 -R /var/log/supervisor
    
    
## Port name : /rstudio, /shiny
RUN mkdir -p /etc/nginx/RStudioAMI 
COPY /etc/nginx/RStudioAMI/* /etc/nginx/RStudioAMI/ 
COPY /etc/nginx/sites-available/* /etc/nginx/sites-available/
COPY /etc/nginx/sites-enabled/* /etc/nginx/sites-enabled/
COPY /etc/init.d/jupyterhub /etc/init.d/jupyterhub
RUN mkdir /etc/jupyterhub
COPY /etc/jupyterhub/jupyterhub_config.py /etc/jupyterhub/jupyterhub_config.py



EXPOSE 8787 8000 3838

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"] 







