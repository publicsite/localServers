#!/bin/sh
IFS='
'

URL="${HTTP_HOST}${REQUEST_URI}"

extension="$(printf "%s" "$URL" | rev | cut -d '.' -f 1 | rev)"

if [ "$extension" = "js" ]; then
	echo "Content-type: text/javascript"
	echo
elif [ "$extension" = "css" ]; then
	echo "Content-type: text/css"
	echo
elif [ "$extension" = "jpg" ]; then
	sleep 1
else
	echo "Content-type: text/html"
	echo
fi

if [ "$URL" = "" ]; then
	URL="https://thepiratebay.org"
elif [ "$URL" = "http://127.0.0.1:8083/cgi-bin/pirateProxy.sh" ]; then
	URL="https://thepiratebay.org"
elif [ "$URL" = "127.0.0.1:8083/cgi-bin/pirateProxy.sh" ]; then
	URL="https://thepiratebay.org"
else
	#hack
	URL="$(printf "%s" "$URL" | sed "s#pirateProxy.sh/https:/#pirateProxy.sh/https://#g")"
	URL="$(printf "%s" "$URL" | sed "s#pirateProxy.sh/http:/#pirateProxy.sh/http://#g")"

	URL="$(printf "%s" "$URL" | sed "s#http://127.0.0.1:8083/cgi-bin/pirateProxy.sh/##g" | sed "s#127.0.0.1:8083/cgi-bin/pirateProxy.sh/##g")"
fi

if [ "$(echo "$URL" | grep "^https://thepiratebay.org.*")" = "" ] && \
[ "$(echo "$URL" | grep "^https://torrindex.net.*")" = "" ] && \
[ "$(echo "$URL" | grep "^unhappyweakness.com*")" = "" ] && \
[ "$(echo "$URL" | grep "^http://ikeanangelsaidthe.com*")" = "" ] && \
[ "$(echo "$URL" | grep "^https://apibay.org.*")" = "" ]; then
echo "<h1>$URL</h1>"
	exit
fi

rand_num="$(expr $(od -A n -t d -N 1 /dev/urandom | tr -d ' ') % 4)"
case $rand_num in
0)
output="$(curl -s -L -x http://190.242.157.215:8080 "$URL")"
;;
1)
output="$(curl -s -L -x socks4://37.18.73.60:5566 "$URL")"
;;
2)
output="$(curl -s -L -x http://23.237.210.82:80 "$URL")"
;;
3)
output="$(curl -s -L -x http://159.69.57.20:8880 "$URL")"
;;
esac

printf "%s\n" "$output" | sed "s#src=\"/#src=\"https://thepiratebay.org/#g" \
| sed "s#action=\"/#action=\"https://thepiratebay.org/#g" \
| sed "s#href=\"//#href=\"http://127.0.0.1:8083/cgi-bin/pirateProxy.sh/#g" \
| sed "s#href='//#href='http://127.0.0.1:8083/cgi-bin/pirateProxy.sh/#g" \
| sed "s#href=\"/#href=\"http://127.0.0.1:8083/cgi-bin/pirateProxy.sh/https://thepiratebay.org/#g" \
| sed "s#script src=\"//#script src=\"http://127.0.0.1:8083/cgi-bin/pirateProxy.sh/#g" \
| sed "s#src='//#src='http://127.0.0.1:8083/cgi-bin/pirateProxy.sh/#g" \
| sed "s#href=\"https://thepiratebay.org#href=\"http://127.0.0.1:8083/cgi-bin/pirateProxy.sh/https://thepiratebay.org#g" \
| sed "s#action=\"https://thepiratebay.org#action=\"http://127.0.0.1:8083/cgi-bin/pirateProxy.sh/https://thepiratebay.org#g" \
| sed "s#src=\"https://thepiratebay.org#src=\"http://127.0.0.1:8083/cgi-bin/pirateProxy.sh/https://thepiratebay.org#g" \
| sed "s#href=\"https://torrindex.net#href=\"http://127.0.0.1:8083/cgi-bin/pirateProxy.sh/https://torrindex.net/#g" \
| sed "s#script src=\"https://torrindex.net#script src=\"http://127.0.0.1:8083/cgi-bin/pirateProxy.sh/https://torrindex.net/#g" \
| sed "s#href=\"http://ikeanangelsaidthe.com#href=\"http://127.0.0.1:8083/cgi-bin/pirateProxy.sh/http://ikeanangelsaidthe.com#g" \
| sed "s#https://apibay.org#http://127.0.0.1:8083/cgi-bin/pirateProxy.sh/https://apibay.org#g" \
| sed "s#static_server='https://torrindex.net'#static_server='http://127.0.0.1:8083/cgi-bin/pirateProxy.sh/https://torrindex.net'#g"

exit 0