## adduser
adduser math --gecos 'First Last,RoomNumber,WorkPhone,HomePhone' --disabled-password 
sh -c 'echo js:js | sudo chpasswd' 
usermod -aG sudo math

## R 
sudo apt-get install r-base

## Rstudio
RSTUDIO_LATEST=$(wget --no-check-certificate -qO- https://s3.amazonaws.com/rstudio-server/current.ver) 
[ -z "$RSTUDIO_VERSION" ] && RSTUDIO_VERSION=$RSTUDIO_LATEST || true 
wget -q http://download2.rstudio.org/rstudio-server-${RSTUDIO_VERSION}-amd64.deb 
dpkg -i rstudio-server-${RSTUDIO_VERSION}-amd64.deb 
rm rstudio-server-*-amd64.deb 


## jupyterhub
# anaconda
#wget https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh
#sudo bash Anaconda3-5.2.0-Linux-x86_64.sh

sudo apt-get -y install python3-pip npm nodejs
sudo npm install -g configurable-http-proxy
sudo pip3 install jupyterhub
sudo pip3 install --upgrade notebook
#jupyterhub --no-ssl

## setup 


# jupyterhyb
sudo wget https://gist.githubusercontent.com/lambdalisue/f01c5a65e81100356379/raw/ecf427429f07a6c2d6c5c42198cc58d4e332b425/jupyterhub -O /etc/init.d/jupyterhub
sudo chmod 777 /etc/init.d/jupyterhub
sudo mkdir /etc/jupyterhub
sudo jupyterhub --generate-config -f /etc/jupyterhub/jupyterhub_config.py
sudo wget https://raw.githubusercontent.com/jinseob2kim/docker-datascience/master/jupyterhub_config.py -O /etc/jupyterhub/jupyterhub_config.py
sudo chmod 777  /etc/jupyterhub/jupyterhub_config.py

#c.JupyterHub.confirm_no_ssl = True
#c.JupyterHub.base_url = '/julia'
#c.JupyterHub.ip = '127.0.0.1'


# Start jupyterhub on boot
sudo /etc/init.d/jupyterhub start
sudo service jupyterhub start
#sudo service jupyterhub stop
#sudo update-rc.d jupyterhub defaults


## Shiny server
wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-14.04/x86_64/VERSION -O "version.txt"
VERSION=$(cat version.txt)
wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-14.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb
sudo dpkg -i ss-latest.deb
rm -f version.txt ss-latest.deb
R -e "install.packages(c('shiny', 'rmarkdown'), repos='https://cran.rstudio.com/')" 
sudo wget https://raw.githubusercontent.com/jinseob2kim/docker-datascience/master/shiny-server.conf -O /etc/shiny-server/shiny-server.conf
sudo chmod 777 /etc/shiny-server/shiny-server.conf


#sudo vim /etc/shiny-server/shiny-server.conf

#run_as shiny;
#server {
#  listen 3838;
#  run_as :HOME_USER:;
#  location / {
#    user_dirs;
#  }
#}
sudo systemctl restart shiny-server


# nginx
sudo apt-get -y install nginx
sudo wget https://raw.githubusercontent.com/jinseob2kim/docker-datascience/master/default -O /etc/nginx/sites-enabled/default
sudo chmod 777 /etc/nginx/sites-enabled/default
sudo service nginx restart


## github
git config --global user.email "jinseob2kim@gmail.com"
git config --global user.name "Jinseob Kim"


## Julia
wget https://julialang-s3.julialang.org/bin/linux/x64/0.6/julia-0.6.3-linux-x86_64.tar.gz
tar -zxvf julia-0.6.3-linux-x86_64.tar.gz 
rm julia-0.6.3-linux-x86_64.tar.gz 
mv julia-d55cadc350 julia_sources
sudo ln -s ~/julia_sources/bin/julia /usr/local/bin/julia
julia -E 'Pkg.add("IJulia")'
julia -E 'Pkg.update()'


## Docker 
sudo apt-get install docker.io
sudo usermod -aG docker $USER 
# Docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose


