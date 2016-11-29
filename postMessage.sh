#message should be entered along with command
source config.cfg

echo "Enter the message you want to post"
read message
curl -sX POST \
 -d "message=$message" \
 -d "url=https%3A%2F%2Fwww.facebook.com%2Fimages%2Ffb_icon_325x325.png" \
 -d "access_token=$access_token" \
 "https://graph.facebook.com/v2.2/me/feed" >/dev/null &
 pid=$!

 ./wait.sh $pid
 
 echo "Message posted successfully"
