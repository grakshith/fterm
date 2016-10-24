#!/bin/bash
source config.cfg

echo -e "Your Photos"

curl -s -X GET \
 "https://graph.facebook.com/v2.2/me/photos?fields=link%2Cname%2Calbum%2Csource%2Clikes&limit=1000&access_token=$access_token" >djson.data
length=$(jq -r ".data | length" djson.data)

#jq -r ".data[]" djson.data

length=$(jq -r ".data | length" djson.data)

for((i=0;i<$length;i++))
do
#jq -r ".data[$i]" json.data
name="$(jq -r ".data[$i].name" djson.data)"
album="$(jq -r ".data[$i].album" djson.data)"
link="$(jq -r ".data[$i].link" djson.data)"
likes="$(jq -r ".data[$i].likes" djson.data)"
source="$(jq -r ".data[$i].source" djson.data)"

if [ "$name" != "null" ]
then
  echo "Photo Name : " $(jq -r ".data[$i].name" djson.data)
  #if the json data does not bear a file name then print the photolink
else
  echo "Photo Link : " $(jq -r ".data[$i].link" djson.data)
fi

if [ "$album" != "null" ]
then
  echo "Album Name : " $(jq -r ".data[$i].album.name" djson.data)
  jq -r ".data[$i].album" djson.data
fi

if [ "$(jq -r ".data[$i].likes" djson.data)" != "null" ]
then
  echo "Liked by :"
  for (( k = 0; k < 5 ; k++ ))
  do
    if [[ $(jq -r ".data[$i].likes.data[$k].name" djson.data) != "null" ]]; then
      echo $(jq -r ".data[$i].likes.data[$k].name" djson.data)
    fi
  done
fi

#TODO-1)work needed on automatic display of images
if [ "$link" != "null" ]
then
  wget -q -O fbimages/"$i.jpg" "$(jq -r ".data[$i].source" djson.data)"
  sudo fbi fbimages/"$i.jpg"
  #use`sudo xdg-open fbimages/"$i.jpg"` on virtual consoles
fi

#clear
printf "\n\n"
done
#rm djson.data
