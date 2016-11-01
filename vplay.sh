#!/bin/bash
source config.cfg

figlet -f script "Your Videos"

curl -s -X GET \
 "https://graph.facebook.com/v2.8/me/videos/uploaded/?fields=source%2Clength%2Ctitle%2Ccreated_time%2Cpermalink_url&access_token=$access_token">vjson.data

length=$(jq -r ".data | length" vjson.data)

for((i=0;i<$length;i++))
do
#jq -r ".data[$i]" vjson.data
title="$(jq -r ".data[$i].title" vjson.data)"
vlength="$(jq -r ".data[$i].length" vjson.data)"
link="$(jq -r ".data[$i].permalink_url" vjson.data)"
cr_time="$(jq -r ".data[$i].created_time" vjson.data)"
source="$(jq -r ".data[$i].source" vjson.data)"

if [ "$title" != "null" ]
then
  echo "Video Title : " $(jq -r ".data[$i].title" vjson.data)
  #if the json data does not bear a file name then print the Videolink
else
  echo "Video Link : " $(jq -r ".data[$i].permalink_url" vjson.data)
fi

if [ "$vlength" != "null" ]
then
  echo "Video Length : " $(jq -r ".data[$i].length" vjson.data)"seconds"
fi

if [ "$cr_time" != "null" ]
then
  echo "Video created on : " $(jq -r ".data[$i].created_time" vjson.data)"seconds"
fi

if [ "$source" != "null" ]
then
  wget -q -O fbvideos/"$i.mp4" "$(jq -r ".data[$i].source" vjson.data)"
  sudo timeout $(echo "$vlength+$delay_time"|bc)s xdg-open fbvideos/"$i.mp4" #$delay_time input from config.cfg
fi

#clear
printf "\n\n"
done
#rm vjson.data
