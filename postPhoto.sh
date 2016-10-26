source config.cfg
echo -e "choose how you would like to upload the file\n 1.url\n 2.file\n"
read choice
if [ $choice -eq 1 ]
then
  echo "enter the image url"
else
  echo "enter the location of the file"
fi
read $image_location
echo "enter caption"
read $caption
echo "your image has been posted successfully..."
if [ $choice -eq 1 ]
then
  curl -F "access_token=$access_token" \
     -F "url=$image_location" \
     -F "caption=$caption"
      "https://graph.facebook.com/me/photos"
fi
else
  curl -F "access_token=$access_token" \
     -F "source=@$image_location" \
     -F "caption=$caption"
      "https://graph.facebook.com/me/photos"
