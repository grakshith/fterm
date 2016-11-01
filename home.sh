#! /bin/bash

source config.cfg

echo "Your feed"

curl -s -X GET \
 "https://graph.facebook.com/v2.1/me/feed?fields=link,message,place,story,source,created_time,description&limit=1000&access_token=$access_token" > json.data &

pid=$!

./wait.sh $pid
unset pid

#jq -r ".data[]" json.data

length=$(jq -r ".data | length" json.data)

for((i=0;i<$length;i++))
do
#jq -r ".data[$i]" json.data
id="$(jq -r ".data[$i].id" json.data)"
from="$(jq -r ".home.data[$i].from.name" json.data)"
message="$(jq -r ".data[$i].message" json.data)"
story="$(jq -r ".data[$i].story" json.data)"
souce="$(jq -r ".data[$i].source" json.data)"
link="$(jq -r ".data[$i].link" json.data)"
places="$(jq -r ".data[$i].place" json.data)"
description="$(jq -r ".data[$i].description" json.data)"
if [ "$from" != "null" ]; then
	echo "From : $from"
fi
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
if [ "$souce" != "null" ];
	then
	echo "Video from this post available"
fi
echo -n "Created time : "
jq -r ".data[$i].created_time" json.data
echo ""
echo -n "facebook/timeline $ "

read input
if [ "$input" = "like" ]
then
curl -s -X POST \
 -d "access_token=$access_token" \
 "https://graph.facebook.com/v2.1/$id/likes" | jq -r ".success" &
pid=$!

./wait.sh $pid
unset pid
 echo ""

fi
if [ "$input" = "show video" ];
	then
		vlc $souce
fi

if [ "$input" = "comment" ]
	then
	read comment
	curl -s -X POST \
 -d "access_token=$access_token&message=$comment" \
 "https://graph.facebook.com/v2.1/$id/comments" | jq -r ".id"
pid=$!

./wait.sh $pid
unset pid
 echo "Successfully posted comment"
 echo ""
fi

if [ "$input" = "show comments" ]
	then
	curl -s -X GET \
 "https://graph.facebook.com/v2.2/$id/comments?limit=10&access_token=$access_token" > comments.data &
 
 pid=$!

 ./wait.sh $pid

 for((i=0;i<10;i++))
 do
 	name="$(jq -r ".data[$i].from.name" comments.data)"
	message="$(jq -r ".data[$i].message" comments.data)"
	like_count="$(jq -r ".data[$i].like_count" comments.data)"
	created_time="$(jq -r ".data[$i].created_time" comments.data)"
	echo "On $created_time, $name commented "
	echo $message
	echo ""
done
echo "End of comments for this post"
echo ""
fi



done

#rm json.data
