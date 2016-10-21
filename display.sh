#! /bin/bash/
source config.cfg

echo "Your feed"

time=100
curl -s -X GET \
 "https://graph.facebook.com/v2.1/me/photos?fields=link,name,album,likes&limit=5&limit=1000&access_token=$access_token" > djson.data

length=$(jq -r ".data | length" djson.data)

#jq -r ".data[]" json.data

length=$(jq -r ".data | length" djson.data)

for((i=0;i<$length;i++))
do
#jq -r ".data[$i]" json.data
name="$(jq -r ".data[$i].name" djson.data)"
album="$(jq -r ".data[$i].album" djson.data)"
link="$(jq -r ".data[$i].link" djson.data)"
likes="$(jq -r ".data[$i].likes" json.data)"

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
  for (( k = 0; k < 5 ; k++ ));
  do
    if [[ $(jq -r ".data[$i].likes.data[$k].name" djson.data) != "null" ]]; then
      echo $(jq -r ".data[$i].likes.data[$k].name" djson.data)
    fi
  done
fi

#################part to correct
#the image file will be displayed till its closed or killed by the user
#fbi is not yet implemented to fecilitate easy testing of the script
#--TODO:1.handle the filetype
#-------2.improvise dlearing of the datadump created by the image downloads
if [ "$link" != "null" ]
then
wget -q $(jq -r ".data[$i].link" djson.data) -o fbimages/"$i"
  sudo timeout "$time"s display fbimages/"$i"
fi
#################part to correct

#clear
printf "\n\n"
done
#primitive approach to clear the unwanted files creatd in the folder while downloading files
rm -r -f photo*
rm -r -f index*
#rm json.data
