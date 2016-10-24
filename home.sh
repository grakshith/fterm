#! /bin/bash

source config.cfg

echo "Your feed"

curl -s -X GET \
 "https://graph.facebook.com/v2.8/me/feed?fields=link,message,place,story,created_time,description&limit=1000&access_token=$access_token" > json.data

#jq -r ".data[]" json.data

length=$(jq -r ".data | length" json.data)

for((i=0;i<$length;i++))
do
#jq -r ".data[$i]" json.data
message="$(jq -r ".data[$i].message" json.data)"
story="$(jq -r ".data[$i].story" json.data)"
link="$(jq -r ".data[$i].link" json.data)"
places="$(jq -r ".data[$i].place" json.data)"
description="$(jq -r ".data[$i].description" json.data)"
if [ "$message" != "null" ]
then
echo -n "Message : "
jq -r ".data[$i].message" json.data
fi

if [ "$story" != "null" ]
then
jq -r ".data[$i].story" json.data
fi

if [ "$description" != "null" ]
then
echo -n "Description : "
jq -r ".data[$i].description" json.data
fi

if [ "$link" != "null" ]
then
jq -r ".data[$i].link" json.data
fi

if [ "$places" != "null" ]
then
jq -r ".data[$i].place[]" json.data
fi

echo -n "Created time : "
jq -r ".data[$i].created_time" json.data
echo ""
echo ""
done

#rm json.data
