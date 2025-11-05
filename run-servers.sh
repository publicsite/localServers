#!/bin/sh

OLD_UMASK="$(umask)"
umask 0022

cd "$(dirname $0)"

####RUN interface###

cd server
busybox httpd -p 127.0.0.1:8083
sleep 5
cd ..

###RUN services###

cd sources

thepwd="$PWD"

#use our python virtual environment
. "${PWD}/venv/bin/activate"

####RUN NITTER####
#cd nitter
#redis-server --daemonize yes
#./nitter
#cd ..

####RUN IMGIN####

cd "${thepwd}/imgin"
#runs on 127.0.0.1:8081
./run.py &
sleep 5
cd ..

####RUN YT-LOCAL####

cd "${thepwd}/yt-local"
#runs on 127.0.0.1:9010
python3 server.py &
sleep 5
cd ..

####RUN QUETRE####

cd "${thepwd}/quetre"
PORT=8086 npm start &

####RUN NEUTERS#####

cd "${thepwd}/neuters-build/target/debug"
./neuters --address "127.0.0.1:8085" &
cd ../../../

####RUN SIMPLYTRANSLATE-WEB ####

## When running: No module named 'simplytranslate_engines'
#sudo apt-get install python3-quart

#cd SimplyTranslate-Web
#python3 main.py
#cd ..

####RUN REDLIB ####

cd "${thepwd}/redlib-build/target/debug"

#use a proxy to connect to redlib
rand_num="$(expr $(od -A n -t d -N 1 /dev/urandom | tr -d ' ') % 3)"
case $rand_num in
0)
HTTP_PROXY="http://190.242.157.215:8080" HTTPS_PROXY="http://190.242.157.215:8080" REDLIB_ENABLE_RSS=on ./redlib --address 127.0.0.1 --port 8084 &
;;
1)
HTTP_PROXY="http://23.237.210.82:80" HTTPS_PROXY="http://23.237.210.82:80" REDLIB_ENABLE_RSS=on ./redlib --address 127.0.0.1 --port 8084 &
;;
2)
HTTP_PROXY="http://159.69.57.20:8880" HTTPS_PROXY="http://159.69.57.20:8880" REDLIB_ENABLE_RSS=on ./redlib --address 127.0.0.1 --port 8084 &
;;
esac

sleep 5
cd ../../../

####RUN WHOOGLE####

#cd whoogle-search

#ADDRESS="127.0.0.1" EXPOSE_PORT="8084" ./run &
#sleep 5
#cd ..

####RUN searxng####

#sudo -H -u searxng -i ${HOME}/webFrontends/startSearx.sh &
#sleep 5

umask "${OLD_UMASK}"
