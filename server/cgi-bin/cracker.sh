#!/bin/sh

imgin_serverip="http://127.0.0.1:8081"
yt_serverip="http://127.0.0.1:8082"
thisip="http://127.0.0.1:8083"

echo -e 'HTTP/1.1 200\r\nContent-Type: text/html\r\n\r\n'

echo "<HTML><TITLE>Local services</TITLE><body bgcolor=\"black\"><center><br><br><br>"
echo "<form method=GET action=\"${SCRIPT}\">"
echo '<p style="color:green">youtube and imgur:</p>'
echo "<input type=\"text\" name="thetextbox">"
echo "<input type=\"submit\" value="CRACKIT"></button>"

echo '<br><br><br>'
echo "<a href=\"${yt_serverip}\" style="color:green">Youtube</a>"
echo '<br><br>'
echo "<a href=\"${thisip}/cgi-bin/bbchomepage.sh\" style="color:green">BBC</a>"
echo '<br><br>'
echo "<a href=\"${thisip}/newsMain.html\" style="color:green">News Main</a>"
echo '<br><br>'
echo '<a href="http://192.168.1.196:8080/viewer#wikipedia_en_all_maxi_2023-11/A/User%3AThe_other_Kiwix_guy/Landing" style="color:green">Wikipedia</a>'
echo '<br><br>'
echo '<a href="http://192.168.1.196:8080/viewer#wiktionary_en_all_maxi_2023-10" style="color:green">Wiktionary</a>'
echo '<br><br>'
echo '<a href="http://192.168.1.196:8080/viewer#superuser.com_en_all_2023-11" style="color:green">Superuser QnA</a>'
echo '<br><br>'
echo '<a href="http://192.168.1.196:8080/viewer#stackoverflow.com_en_all_2023-11" style="color:green">StackOverflow QnA</a>'
echo '<br><br>'
echo '<a href="https://publicsite.org/J05HYYY/Dashboard.html" style="color:green">publicsite.org Dashboard</a>'

#redirect to translated URL

if [ "$REQUEST_METHOD" != "GET" ]; then
        echo "<hr>Script Error:"\
             "<br>Usage error, cannot complete request, REQUEST_METHOD!=GET."\
             "<br>Check your FORM declaration and be sure to use METHOD=\"GET\".<hr>"
      exit 1
fi


if [ -z "${QUERY_STRING}" ]; then
        exit 0
fi

QUERY_STRING="$(printf "%s" "${QUERY_STRING}" | sed "s/%3A/:/g" | sed "s#%2F#/#g" | sed "s#%3F#?#g" | sed "s#%2F#/#g" | sed "s#%3D#=#g" | cut -c 12-)"


if [ "$(echo "${QUERY_STRING}" | cut -c 1-23)" = "http://www.youtube.com/" ]; then
	echo "<meta http-equiv=\"Refresh\" content=\"1; url=${yt_serverip}/${QUERY_STRING}\">"
elif [ "$(echo "${QUERY_STRING}" | cut -c 1-24)" = "https://www.youtube.com/" ]; then
	echo "<meta http-equiv=\"Refresh\" content=\"1; url=${yt_serverip}/${QUERY_STRING}\">"
elif [ "$(echo "${QUERY_STRING}" | cut -c 1-19)" = "http://youtube.com/" ]; then
	echo "<meta http-equiv=\"Refresh\" content=\"1; url=${yt_serverip}/${QUERY_STRING}\">"
elif [ "$(echo "${QUERY_STRING}" | cut -c 1-20)" = "https://youtube.com/" ]; then
	echo "<meta http-equiv=\"Refresh\" content=\"1; url=${yt_serverip}/${QUERY_STRING}\">"
elif [ "$(echo "${QUERY_STRING}" | cut -c 1-16)" = "https://youtu.be/" ]; then
	echo "<meta http-equiv=\"Refresh\" content=\"1; url=${yt_serverip}/${QUERY_STRING}\">"
elif [ "$(echo "${QUERY_STRING}" | cut -c 1-17)" = "https://youtu.be/" ]; then
	echo "<meta http-equiv=\"Refresh\" content=\"1; url=${yt_serverip}/${QUERY_STRING}\">"
elif [ "$(echo "${QUERY_STRING}" | cut -c 1-18 )" = "i.stack.imgur.com/" ]; then
	echo "<meta http-equiv=\"Refresh\" content=\"1; url=${imgin_serverip}/$(echo "${QUERY_STRING}" | cut -c 19-)\">"
elif [ "$(echo "${QUERY_STRING}" | cut -c 1-10 )" = "imgur.com/" ]; then
	echo "<meta http-equiv=\"Refresh\" content=\"1; url=${imgin_serverip}/$(echo "${QUERY_STRING}" | cut -c 11-)\">"
elif [ "$(echo "${QUERY_STRING}" | cut -c 1-25 )" = "http://i.stack.imgur.com/" ]; then
	echo "<meta http-equiv=\"Refresh\" content=\"1; url=${imgin_serverip}/$(echo "${QUERY_STRING}" | cut -c 26-)\">"
elif [ "$(echo "${QUERY_STRING}" | cut -c 1-26 )" = "https://i.stack.imgur.com/" ]; then
	echo "<meta http-equiv=\"Refresh\" content=\"1; url=${imgin_serverip}/$(echo "${QUERY_STRING}" | cut -c 27-)\">"
elif [ "$(echo "${QUERY_STRING}" | cut -c 1-23 )" = "http://stack.imgur.com/" ]; then
	echo "<meta http-equiv=\"Refresh\" content=\"1; url=${imgin_serverip}/$(echo "${QUERY_STRING}" | cut -c 24-)\">"
elif [ "$(echo "${QUERY_STRING}" | cut -c 1-24 )" = "https://stack.imgur.com/" ]; then
	echo "<meta http-equiv=\"Refresh\" content=\"1; url=${imgin_serverip}/$(echo "${QUERY_STRING}" | cut -c 25-)\">"
elif [ "$(echo "${QUERY_STRING}" | cut -c 1-17 )" = "http://imgur.com/" ]; then
	echo "<meta http-equiv=\"Refresh\" content=\"1; url=${imgin_serverip}/$(echo "${QUERY_STRING}" | cut -c 18-)\">"
elif [ "$(echo "${QUERY_STRING}" | cut -c 1-18 )" = "https://imgur.com/" ]; then
	echo "<meta http-equiv=\"Refresh\" content=\"1; url=${imgin_serverip}/$(echo "${QUERY_STRING}" | cut -c 19-)\">"
elif [ "$(echo "${QUERY_STRING}" | cut -c 1-19 )" = "http://i.imgur.com/" ]; then
	echo "<meta http-equiv=\"Refresh\" content=\"1; url=${imgin_serverip}/$(echo "${QUERY_STRING}" | cut -c 20-)\">"
elif [ "$(echo "${QUERY_STRING}" | cut -c 1-20 )" = "https://i.imgur.com/" ]; then
	echo "<meta http-equiv=\"Refresh\" content=\"1; url=${imgin_serverip}/$(echo "${QUERY_STRING}" | cut -c 21-)\">"
fi

echo "</center></body></HTML>"

exit 0