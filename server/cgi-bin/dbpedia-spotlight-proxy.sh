#!/bin/sh
echo "Content-type: text/xml"
echo -e 'HTTP/1.1 200\r\nContent-Type: text/xml\r\n'
wget -O - -e robots=off --header="Accept: text/xml" --header="User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_0) AppleWebKit/600.1.17 (KHTML, like Gecko) Version/8.0 Safari/600.1.17" "https://api.dbpedia-spotlight.org/en/annotate?${QUERY_STRING}" 2>/dev/null
exit 0