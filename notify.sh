#!/bin/bash
source config.cfg

figlet -f script "Your Notifications"

curl -s -X GET \
 "https://graph.facebook.com/v2.2/me/notifications?fields=created_time%2Ctitle%2Clink%2Capplication&limit=10&access_token=$access_token">njson.data

length=$(jq -r ".data | length" njson.data)

if [ $length -eq 0 ]; then
	echo "Sorry no notifications to display!"
	exit 0
fi

for((i=0;i<$length;i++))
do
#jq -r ".data[$i]" njson.data
title="$(jq -r ".data[$i].title" njson.data)"
category="$(jq -r ".data[$i].application.name" njson.data)"
link="$(jq -r ".data[$i].link" njson.data)"
cr_time="$(jq -r ".data[$i].created_time" njson.data)"
#source="$(jq -r ".data[$i].source" njson.data)"

if [ "$title" != "null" ]
then
  echo -e "Notification $(echo "$i+1"|bc) :\n"$(jq -r ".data[$i].title" njson.data)
  #if the json data does not bear a file name then print the Videolink
fi

if [ "$category" != "null" ]
then
  echo "Category :" $(jq -r ".data[$i].application.name" njson.data)
fi

if [ "$cr_time" != "null" ]
then
  echo "Notification raised at :" $(jq -r ".data[$i].created_time" njson.data)
fi

if [ "$cr_time" != "null" ]
then
  echo "Link pointed by the Notification  : " $(jq -r ".data[$i].link" njson.data)"seconds"
fi


#clear
printf "\n\n"
done
#rm njson.data
