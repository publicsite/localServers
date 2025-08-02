#!/bin/sh

####DEBIAN SCRIPT TO INSTALL ALTERNATE FRONTENDS####

mkdir ~/webFrontends

cp -a ./* ~/webFrontends/

cd ~/webFrontends

mkdir sources

cd sources

sudo apt-get update && sudo apt-get install -y git busybox

#from https://github.com/mendel5/alternative-front-ends
###git clone https://github.com/zedeus/nitter
git clone https://git.voidnet.tech/kev/imgin
git clone https://git.sr.ht/~heckyel/yt-local
###git clone https://github.com/pablouser1/ProxiTok
###git clone https://github.com/zyachel/quetre
###git clone https://github.com/HookedBehemoth/neuters
###git clone https://codeberg.org/SimpleWeb/SimplyTranslate-Web
git clone https://github.com/redlib-org/redlib
###git clone https://github.com/benbusby/whoogle-search.git


#MAKE VENV for python

thepwd="${PWD}"
sudo apt-get install -y python3-pip python3-full
mkdir "${thepwd}/venv"
python3 -m venv "${thepwd}/venv"
. "${thepwd}/venv/bin/activate"

###### NITTER ######

##nitter no longer works without an account

#sudo apt-get install -y libpcre3-dev libsass-dev redis-server nim

#cd nitter
#nimble build -d:release
#nimble scss
#nimble md
#cp nitter.example.conf nitter.conf
#sed -i 's/port = 8080/port = 8082/g' nitter.conf
#sed -i 's/replaceTwitter = "nitter.net"/replaceTwitter = "twitter.com"/g' nitter.conf
#cd ..

###### IMGIN ########

sudo apt-get install -y python3-gevent python3-bottle

cd imgin

#change bind port as to not conflict
sed -i "s/bind_port = '8080'/bind_port = '8081'/g" imgin/config.py

pip install -r requirements.txt

cd ..

###### YT-LOCAL ######

sudo apt-get install -y python3-pip python3-full python3-flask python3-socks python3-stem python3-defusedxml python3-cachetools

cd yt-local
rm settings.py
rm server.py
cp ../../settings.py .
cp ../../server.py .
pip install -r requirements.txt
pip install cachetools

cd ..

####### PROXITOK #####

#I couldn't get this one to run (I don't know how to run it).

##translated from the Dockerfile...
#cd ProxiTok
#sudo apt-get install -y composer php8.2-redis php8.2-zip php8.2-common php8.2-curl php-curl php8.2-xml php-xml
#sudo cp -a ./misc/setup/docker/php.ini /etc/php/8.2/cli/conf.d/20-settings.ini
#sudo mkdir /cache
#sudo chown -R pi:pi /cache
#composer update
#composer install --no-interaction --optimize-autoloader --no-dev --no-cache
#cd ..

####### QUETRE ######

#I couldn't get this one to build (see buildlog)

#sudo apt-get install -y npm
#cd quetre
#cp .env.example .env # you can make any changes here
#npm install
#cd ..

###### NEUTERS ######

##the cargo command freezes my system

#sudo apt-get install -y build-essential cargo

#cp -a neuters neuters-build
#cd neuters-build
#cargo build

###### SIMPLYTRANSLATE-WEB######

##when running: No module named 'simplytranslate_engines'

#cd SimplyTranslate-Web
#pip install -r requirements.txt
#cd ..

###### REDLIB #####

sudo apt-get install -y curl cargo

cp -a redlib redlib-build
cd redlib-build #i got up to here
cargo build

####### WHOOGLE SEARCH #####

#cd whoogle-search

#pip install -r requirements.txt

#cd ..