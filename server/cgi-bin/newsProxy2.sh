#!/bin/sh
echo "Content-type: application/rss+xml"
echo
wget -O - -e robots=off --header="User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_0) AppleWebKit/600.1.17 (KHTML, like Gecko) Version/8.0 Safari/600.1.17" "https://www.theguardian.com/uk-news/rss" 2>/dev/null
exit 0