#!/bin/sh

cd "$(dirname $0)"

####RUN interface###

cd server
busybox httpd -p 127.0.0.1:8083
sleep 5
cd ..

###RUN services###

cd sources

#use our python virtual environment
. "${PWD}/venv/bin/activate"

####RUN NITTER####
#cd nitter
#redis-server --daemonize yes
#./nitter
#cd ..

####RUN IMGIN####

cd imgin
#runs on 127.0.0.1:8081
./run.py &
sleep 5
cd ..

####RUN YT-LOCAL####

cd yt-local
#runs on 127.0.0.1:9010
python3 server.py &
sleep 5
cd ..

####RUN QUETRE####

#I couldn't get this one to build (see buildlog)

#cd quetre
#npm start
## optional
#redis-server # useful for caching api responses

####RUN NEUTERS#####

#cd neuters-build
#./neuters --address "0.0.0.0:13369"
#cd ..

####RUN SIMPLYTRANSLATE-WEB ####

## When running: No module named 'simplytranslate_engines'
#sudo apt-get install python3-quart

#cd SimplyTranslate-Web
#python3 main.py
#cd ..

####RUN REDLIB ####

cd redlib-build/target/debug
./redlib --address 127.0.0.1 --port 8084 &
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
