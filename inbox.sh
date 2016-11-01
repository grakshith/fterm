#! /bin/bash
curl -s -X GET \
 "https://graph.facebook.com/v2.3/me?fields=inbox%7Bcomments%2Cfrom%2Csubject%2Cto%7D&access_token=EAACEdEose0cBAJLACncC7WJgvG99ijpelO9pZCAZBZBAvsMjUxSK8WQIoJmDBg561sRRywyNfcM9GTwQZBwcxZChvrQe6OFsx7SPrgVDFd9lcLa60lVwDQP4aZBBmkD5trA7HQYTfltvlwvQp9zAWRr10ouWEDlxtVw2mxUJThNQZDZD" > inbox.txt
clear
countgroups=$(jq -r ".inbox.data | length" inbox.txt)
for((i=0;i<countgroups;i++))
do
  countmembers=$(jq -r ".inbox.data[$i].to.data | length" inbox.txt)
  if [ $countmembers -eq 2 ]
    then
    jq -r ".inbox.data[$i].to.data[0].name" inbox.txt
fi
done
echo
read name
clear
for((i=0;i<countgroups;i++))
do
list=$(jq -r ".inbox.data[$i].to.data[0].name" inbox.txt)
if [ "$name" == "$list" ]
then
 ~/conv.sh $i
fi
done
