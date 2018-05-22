## jupyterhub
sudo apt-get install npm nodejs
sudo npm install -g configurable-http-proxy
sudo apt-get install python3-pip
sudo pip3 install jupyterhub  
sudo jupyterhub


## Start
sudo chmod +x /etc/init.d/jupyterhub
# Start jupyterhub on boot
sudo update-rc.d jupyterhub defaults
# Create a default config to /etc/jupyterhub/jupyterhub_config.py
sudo mkdir /etc/jupyterhub
sudo jupyterhub --generate-config -f /etc/jupyterhub/jupyterhub_config.py
# Start jupyterhub
sudo service jupyterhub start
# Stop jupyterhub
sudo service jupyterhub stop