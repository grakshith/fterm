#!/bin/bash
curl -s -X POST \
 -d "message=$1" \
 -d "access_token=EAACEdEose0cBAKRwfDefXySZAmDH6nTMZCLIHHJhzV5I8mp8X0NCmCxEMETMuuF5w5bYmnZB7DcSKoprTzdOr4kKTsAdOHT8owMkWzFDSWXSwXrjwvn5tjgIDzw4ZBpg7nYfFLTSrWRZBQ5O6ftNzLBgyxY2rp31uZC1ZAPr9nVZCAZDZD" \
 "https://graph.facebook.com/v2.8/me/feed"
 echo message posted..
 
