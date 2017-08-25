#! /bin/bash
# Bro ELK (Ubuntu 17.04)
# 

# Check for prerequisites
if [ "$(id -u)" -ne 0 ]; then
        echo "This script must be run using sudo!"
        exit 1
fi

# Initial Setup
sudo apt-get update -q -y
sudo apt-get upgrade -q -y
sudo apt-get install openssh-server vim -q -y

# Bro Setup
echo -n "Enter your monitoring interface and press [ENTER]: "
read intMON
sudo apt-get install cmake make gcc g++ flex bison libpcap-dev libssl-dev python-dev swig zlib1g-dev libgeoip-dev -q -y
sudo apt-get install bro broctl -q -y
wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz
gzip -d GeoLiteCity.dat.gz
gzip -d GeoLiteCityv6.dat.gz
mv GeoLiteCity.dat /usr/share/GeoIP/GeoIPCity.dat
mv GeoLiteCityv6.dat /usr/share/GeoIP/GeoIPCityv6.dat
sed -i -e "s/eth0/${intMON}/" /etc/bro/node.cfg
broctl install
broctl start

# ELK setup
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add - 
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update -y
sudo apt-get install oracle-java8-installer -q -y

# Elasticsearch
sudo apt-get update
sudo apt-get install elasticsearch -q -y
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch

# Logstash
sudo apt-get install logstash -q -y
sudo systemctl enable logstash.service
sudo systemctl start logstash.service

# Kibana
sudo apt-get install kibana -q -y
sudo systemctl enable kibana
sudo systemctl start kibana

