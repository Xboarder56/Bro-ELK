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
sudo addgroup --system nsm

# Bro Setup
sudo apt-get install cmake make gcc g++ flex bison libpcap-dev libssl-dev python-dev swig zlib1g-dev libgeoip-dev -q -y
sudo apt-get install bro broctl -q -y
wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz
gzip -d GeoLiteCity.dat.gz
gzip -d GeoLiteCityv6.dat.gz
mv GeoLiteCity.dat /usr/share/GeoIP/GeoIPCity.dat
mv GeoLiteCityv6.dat /usr/share/GeoIP/GeoIPCityv6.dat

