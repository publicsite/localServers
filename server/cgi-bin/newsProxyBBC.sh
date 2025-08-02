#!/bin/sh
echo -e 'HTTP/1.1 200\r\nContent-Type: text/html\r\n\r\n'
wget -O - -e robots=off --header="User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_0) AppleWebKit/600.1.17 (KHTML, like Gecko) Version/8.0 Safari/600.1.17" "https://www.bbc.co.uk/news" 2>/dev/null | sed 's#href="/#href="https://www.bbc.co.uk/#g'
exit 0