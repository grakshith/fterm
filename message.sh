source config.cfg
#message should be entered along with command
curl -i -X POST \
 -d "message=$1" \
 -d "url=https%3A%2F%2Fwww.facebook.com%2Fimages%2Ffb_icon_325x325.png" \
 -d "access_token=$access_token" \
 "https://graph.facebook.com/v2.2/me/feed"
