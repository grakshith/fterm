#! /bin/bash

source config.cfg

echo "Home"

curl -s -X GET \
 "https://graph.facebook.com/v2.1/me?fields=home&access_token=$access_token" > json.data

 length=$(jq -r ".home.data | length" json.data)

for((i=0;i<$length;i++))
do
#jq -r ".data[$i]" json.data
message="$(jq -r ".home.data[$i].message" json.data)"
story="$(jq -r ".home.data[$i].story" json.data)"
link="$(jq -r ".home.data[$i].link" json.data)"
places="$(jq -r ".home.data[$i].place" json.data)"
description="$(jq -r ".home.data[$i].description" json.data)"
if [ "$message" != "null" ]
then
echo -n "Message : "
jq -r ".home.data[$i].message" json.data
fi

if [ "$story" != "null" ]
then
jq -r ".home.data[$i].story" json.data
fi

if [ "$description" != "null" ]
then
echo -n "Description : "
jq -r ".home.data[$i].description" json.data
fi

if [ "$link" != "null" ]
then
jq -r ".home.data[$i].link" json.data
fi

if [ "$places" != "null" ]
then
places_len=$(jq -r ".home.data[$i].place | length" json.data)
for((k=0;k<places_len;k++))
do
	jq -r ".home.data[$i].place.city" json.data
	jq -r ".home.data[$i].place.country" json.data
done
#jq -r ".home.data[$i].place[]" json.data
fi

echo -n "Created time : "
jq -r ".home.data[$i].created_time" json.data
echo ""
echo ""

done

#rm json.data
