#!/bin/sh
echo -e 'HTTP/1.1 200\r\nContent-Type: text/html\r\n\r\n'
wget -O - -e robots=off --header="User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_0) AppleWebKit/600.1.17 (KHTML, like Gecko) Version/8.0 Safari/600.1.17" "https://www.youtube.com/feeds/videos.xml?playlist_id=PLrEnWoR732-BHrPp_Pm8_VleD68f9s14-" 2>/dev/null | sed 's#href="/#href="http://127.0.0.1:8082/#g'
exit 0
