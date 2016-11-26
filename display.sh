#!/bin/bash
source config.cfg

figlet -f script "Your Photos"

curl -s -X GET \
 "https://graph.facebook.com/v2.2/me/photos?fields=link,name,album,source,likes&limit=1000&access_token=$access_token" >djson.data &

pid=$!

 ./wait.sh $pid
unset pid

usage() {
  cat<<EOF
List of commands available
  view      Display the photo
  like      Like the current photo
  comment   Comment on this photo
  previous  Go to the previous photo
  back      Go back to the shell
  notifications Display the notifications

  Navigation:
  back      To go back to the previous level
  exit      Quit the application

EOF
}

length=$(jq -r ".data | length" djson.data)

#jq -r ".data[]" djson.data

length=$(jq -r ".data | length" djson.data)
if [ -d "fbimages"]; then
  echo
else
  mkdir fbimages
fi

for((i=0;i<$length;i++))
do
#jq -r ".data[$i]" json.data
id="$(jq -r ".data[$i].id" json.data)"
name="$(jq -r ".data[$i].name" djson.data)"
album="$(jq -r ".data[$i].album" djson.data)"
link="$(jq -r ".data[$i].link" djson.data)"
likes="$(jq -r ".data[$i].likes" djson.data)"
src="$(jq -r ".data[$i].source" djson.data)"

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
echo ""
echo -n "facebook/photos $ "

read input

if [ "$link" != "null" -a "$input" = "view" ]
then
  wget -q -O fbimages/"$i.jpg" "$(jq -r ".data[$i].source" djson.data)"
  xdg-open fbimages/"$i.jpg" #$delay_time input from config.cfg
fi
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
if [ "$input" = "back" -o "$input" = "exit" ]; then
  exit 0
fi
if [ "$input" = "previous" ]; then
  i=$((i-2))
  echo ""
  continue
fi
if [ "$input" = "help" ]; then
  usage
fi
echo "Press any key to continue"
read ip
#clear

done

rm -r -f wget*
#rm djson.data
