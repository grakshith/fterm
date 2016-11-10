#! /bin/bash
source config.cfg

curl -s -X GET \
 "https://graph.facebook.com/v2.1/me/?access_token=$access_token" > init.data &
  pid=$!

 ./wait.sh $pid
unset pid
  error="$(jq -r ".error.message" init.data)"
  #error="null"
usage() {
	cat<<EOF
List of commands available
	home			Display the user's home feed 
	timeline		Display the user's timeline feeds
	photos			Display the user's photos
	videos			Display the user's videos
	inbox			Display the user's inbox
	notifications	Display the notifications
	
	Navigation:
	back 			To go back to the previous level
	exit			Quit the application

EOF
}

if [ "$error" != "null" ]; then
  	echo $error
  	exit 127
  else
  	echo "Successfully authenticated"
  	echo "Start your terminal facebook journey!"
fi
while(true)
do
	echo -n "% "
	read input
	if [ "$input" == "exit" ]; then
		exit 0
	fi
	if [ "$input" == "home" ]; then
		./stream.sh
	fi
	if [ "$input" == "timeline" ]; then
		./home.sh
	fi
	if [ "$input" == "photos" ]; then
		./display.sh
	fi
	if [ "$input" == "videos" ]; then
		./vplay.sh
	fi
	if [ "$input" == "help" ]; then
		usage
	fi
done