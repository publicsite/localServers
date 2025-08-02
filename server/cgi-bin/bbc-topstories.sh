#!/bin/busybox sh

findTag(){
#1 texttosearch
#2 before
#3 after

thetag="$(printf "%s" "${1}" | grep -Poba "<\s*?${2}.*?${3}.*?>" | head -n 1)"

if [ "$thetag" = "" ]; then
return
fi

notrighttaglen="$(printf "%s" "${thetag}" | cut -d ':' -f 2- | wc -c)"

startindex="$(printf "%s" "$thetag" | cut -d ':' -f 1)"

thetag="$(printf "%s" "$thetag" | grep -Po "<[^<]*$" )"
thetaglen="$(printf "%s" "$thetag" | wc -c)"

endindex="$(expr $startindex + $notrighttaglen)"
startindex="$(expr $endindex - $thetaglen)"

endindex="$(expr $endindex - 1)"
printf "%s" "$thetag"

thetag="-1"
i=1
aorb=""
thetagA=""
thetagB=""
thetagAidx=""
thetagBidx=""
while true; do
#printf "%s<<\n" "$endindex"
	tosearch="$(printf "%s" "${1}" | cut -z -c ${endindex}- | sed "s/\x0$//g")"
#printf "%d\n" "$i"

	thetagA="$(printf "%s" "${tosearch}" | grep -Poba "<\s*?/${2}.*?\>" | head -n 1)"
	thetagB="$(printf "%s" "${tosearch}" | grep -Poba "<\s*?${2}.*?\>" | head -n 1)"
#printf ">>>>%s\n" "$thetagB"
	if [ "$thetagA" != "" ]; then
		thetagAidx="$(printf "%s" "${thetagA}" | cut -d ':' -f 1)"
		notrighttaglen="$(printf "%s" "${thetagA}" | cut -d ':' -f 2- | wc -c)"
		thetagAstartidx="$(printf "%s" "$thetagA" | cut -d ':' -f 1)"
		thetagA="$(printf "%s" "$thetagA" | grep -Po "<[^<]*$" )"
		thetagAlen="$(printf "%s" "$thetagA" | wc -c)"
		thetagAendidx="$(expr $thetagAstartidx + $notrighttaglen)"
		thetagAidx="$(expr $thetagAendidx - $thetagAlen)"
	else
		thetagAidx=""
	fi

	if [ "$thetagB" != "" ]; then
		thetagBidx="$(printf "%s" "${thetagB}" | cut -d ':' -f 1)"
		notrighttaglen="$(printf "%s" "${thetagB}" | cut -d ':' -f 2- | wc -c)"
		thetagBstartidx="$(printf "%s" "$thetagB" | cut -d ':' -f 1)"
		thetagB="$(printf "%s" "$thetagB" | grep -Po "<[^<]*$" )"
		thetagBlen="$(printf "%s" "$thetagB" | wc -c)"
		thetagBendidx="$(expr $thetagBstartidx + $notrighttaglen)"
		thetagBidx="$(expr $thetagBendidx - $thetagBlen)"
	else
		thetagBidx=""
	fi
	if [ "$thetagAidx" = "" ] && [ "$thetagBidx" = "" ]; then
		aorb=""
		break
	elif [ "$thetagAidx" = "" ]; then
		thetagidx=$thetagBidx
		aorb="B"
		i="$(expr $i + 1)"
	elif [ "$thetagBidx" = "" ]; then
		thetagidx=$thetagAidx
		aorb="A"
		i="$(expr $i - 1)"
	elif [ $thetagAidx -lt $thetagBidx ]; then
		thetag=$thetagAidx
		aorb="A"
		i="$(expr $i - 1)"
	else
		thetag=$thetagBidx
		aorb="B"
		i="$(expr $i + 1)"
	fi


	if [ "${aorb}" = "A" ]; then
		endindex="$(expr $endindex + $thetagAidx)"
		endindex="$(expr $endindex + $(printf "%s" "$thetagA" | cut -d ":" -f 2- | wc -c))"
		endindex="$(expr $endindex - 2)"
#printf "%s\n" "$endindex"
	else
		endindex="$(expr $endindex + $thetagBidx)"
		endindex="$(expr $endindex + $(printf "%s" "$thetagB" | cut -d ":" -f 2- | wc -c))"
		endindex="$(expr $endindex - 2)"
	fi

#printf "%s %d" "$aorb" "$i"

	if [ $i -eq 0 ]; then
		break
	fi

	if [ "$thetag" = "" ]; then
		break
	fi
done

printf "%d:%d" "${startindex}" "${endindex}"

}


printTag()
{
	positions="$(findTag "${1}" "${2}" "${3}")"
	posa="$(printf "%s" "${positions}" | sed "s/\x0$//g" | rev | cut -d ':' -f 2 | cut -d '>' -f 1 | rev)"
	posb="$(printf "%s" "${positions}" | rev | cut -d ':' -f 1 | rev)"
	printf "%s" "${1}" | cut -z -c ${posa}-${posb}
}

replaceTagWith()
{
	positions="$(findTag "${1}" "${2}" "${3}")"

	if [ "$positions" != "" ]; then
		start="$(expr $(printf "%s" "${positions}" | cut -d ':' -f 1) - 1)"
		end="$(expr $(printf "%s" "${positions}" | cut -d ':' -f 2))"
		printf "%s" "${1}" | cut -z -b -${start} | sed "s/\x0$//g"
		printf "%s" "${4}"
		printf "%s" "${1}" | cut -z -b ${end}- | sed "s/\x0$//g"
	else
		printf "%s" "${1}"
	fi	
}

readtherss()
{

echo "<h2 style=\"color:white\">Stories</h2>"

echo "<table>"

echo "${1}" | while read atag; do
atag="$(echo "$atag" | tr -s ' ')"
if [ "$(echo "$atag" | cut -c 2-8)" = "<title>" ]; then
title="$(echo "$atag" | cut -d "[" -f 3 | cut -d ']' -f 1)"
elif [ "$(echo "$atag" | cut -c 2-14)" = "<description>" ]; then
description="$(echo "$atag" | cut -d "[" -f 3 | cut -d ']' -f 1)"
#echo $description
elif [ "$(echo "$atag" | cut -c 2-7)" = "<link>" ]; then
link="$(echo "$atag" | cut -d ">" -f 2)"
link="$(echo $link | rev | cut -d ' ' -f 2 | rev)"
#echo $link
elif [ "$(echo "$atag" | cut -c 2-17)" = "<media:thumbnail" ]; then
thumbW="$(echo "$atag" | grep -o "width=.*" | cut -d '"' -f 2)"
thumbH="$(echo "$atag" | grep -o "height=.*" | cut -d '"' -f 2)"
thumbURL="$(echo "$atag" | grep -o "url=.*" | cut -d '"' -f 2)"
elif [ "$(echo "$atag" | cut -c 2-8)" = "</item>" ]; then
	if [ "$title" != "BBC News app" ]; then
		echo "<tr>"
		if [ "${thumbURL}" != "" ] && [ "${thumbW}" != "" ] && [ "${thumbH}" != "" ]; then
			echo "<td>"
			echo "<a href=\"${link}\">"
			echo '<img src="'${thumbURL}'" width="'${thumbW}'" height="'${thumbH}'">'
			echo "</a>"
			echo "</td>"
		fi
		echo '<td>'
		echo "<a href=\"${link}\" style=\"text-decoration:none;color:green;\">"
		echo '<h3 style="text-decoration:none;color:green;">'
		echo "$title"
		echo '</h3>'
		echo "</a>"
		if [ "${description}" != "" ]; then
			echo "<a href=\"${link}\" style=\"text-decoration:none;color:green;\">"
			echo "<i>$description</i>"
			echo "</a>"
		fi

		echo "</td>"
		echo "</tr>"
	fi
fi
done

echo "</table>"
}

thehtml="$(curl -s -A "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0" -e robots=off https://www.bbc.co.uk/news)"
therss="$(curl -s -A "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0" -e robots=off https://feeds.bbci.co.uk/news/rss.xml)"
#thehtml="$(cat bbc-homepage2.html)"
#therss="$(cat rss.xml)"

#thehtml="$(replaceTagWith "$thehtml" "section" "\-SignInBannerWrapper" "" )"
#thehtml="$(replaceTagWith "$thehtml" "div" "ona\-Container" "" )"
#thehtml="$(replaceTagWith "$thehtml" "div" "ona\-Container" "" )"
#thehtml="$(replaceTagWith "$thehtml" "div" "mht\-StaticLinks" "" )"
#thehtml="$(replaceTagWith "$thehtml" "div" "5wn\-Container" "" )"
#thehtml="$(replaceTagWith "$thehtml" "div" "Container eqfxz1" "" )"
#thehtml="$(replaceTagWith "$thehtml" "div" "StyledContainer e1f" "" )"
#findTag "$thehtml" "div" "0xd-GridWrapper" "" 

outhtml="<HTML><TITLE>BBC TOP STORIES</TITLE><body><div style=\"background-color:black;\"><center>"

outhtml="${outhtml}$(printTag "$thehtml" "div" "mostRead" "" | sed 's#a href="#a style="text-decoration:none;color:green;" href="https://www.bbc.co.uk#g')"

outhtml="${outhtml}</center></div></body></HTML>"

#thehtml="$(replaceTagWith "$thehtml" "section" "\-SignInBannerWrapper" "" )"
#findTag "$thehtml" "section" "\-SignInBannerWrapper"

#findTag "$thehtml" "div" "\-Container e1mfo"
#thehtml="$(replaceTagWith "$thehtml" "div" "\-Container e1mfo" "" )"


#findTag "$thehtml" "div" "\-LinkAndImageWrapper e1ksmn"

#thehtml="$(echo "$thehtml" | sed "s#<a class=\".*-NavigationLink-AccountLink.*</a>##g" | sed "s#<span[^/]*-AccountIconWrapper[^/]*</span>##g" | sed "s#<span.[^/]*-AccountText[^/]*</span>##g" | sed "s#<section.*aria-label=\"Sign In.*</section>##g")"
#toreplace="$(echo "${thehtml}" | grep -Po "<a.*?-NavigationLink-AccountLink.*?</a>")"
#thehtml="$(echo "${thehtml}" | sed "s%${toreplace}%%g")"
#toreplace="$(echo "${thehtml}" | grep -Po "<li .*?-GlobalNavigationProduct-GlobalNavigationNonProductItem.*?</li>")"
#thehtml="$(echo "${thehtml}" | sed "s%${toreplace}%%g")"

#thestart="$(echo "${thehtml}" | grep -Po ".*?\-Container e1m.*?>" | rev | cut -d '<' -f 2- | rev)"

#theend="$(echo "${thehtml}" | grep -Po "Container e1m.*?>.*?$" | cut -c 10-)"
#theendcut="$(echo "$theend" | grep -Po ".*?\-Container" | rev | cut -d ">" -f 1 | rev | head -n 1)"
#theendcut="$(printf "%s" "$theendcut")"
#theend="$(echo "${theend}" | grep -o "${theendcut}.*")"
#thehtml="$thestart$theend"


echo -e 'HTTP/1.1 200\r\nContent-Type: text/html\r\n\r\n'
echo "$outhtml"
