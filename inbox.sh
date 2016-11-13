#! /bin/bash
source config.cfg

figlet -f script "Your Inbox"

curl -s -X GET \
 "https://graph.facebook.com/v2.3/me?fields=inbox%7Bcomments%2Cfrom%2Csubject%2Cto%7D&access_token=$access_token" > inbox.txt
clear
countgroups=$(jq -r ".inbox.data | length" inbox.txt)
status=""
while [ "$status" != "e" ]
do
  #displays the names of all your friends
  for((i=0;i<countgroups;i++))
  do
    countmembers=$(jq -r ".inbox.data[$i].to.data | length" inbox.txt)
    if [ $countmembers -eq 2 ]
      then
      jq -r ".inbox.data[$i].to.data[0].name" inbox.txt
  fi
  done
  echo
  #enter the name of any person in the list
  read $name
  clear
  for((i=0;i<countgroups;i++))
  do
    #list contains the list of names
    list=$(jq -r ".inbox.data[$i].to.data[0].name" inbox.txt)
    #checks whether the name exists in the list and displays that persons conversation
    #with you
    if [ "$name" == "$list" ]
    then
      countcomments=$(jq -r ".inbox.data[$i].comments.data | length" inbox.txt)
      for((j=0;j<countcomments;j++))
      do
      comment=$(jq -r ".inbox.data[$i].comments.data[$j].message" inbox.txt)
      if [ "$comment" != "null" ]
      then
      user=$(jq -r ".inbox.data[$i].comments.data[$j].from.name" inbox.txt)
      echo "$user: $comment"
      fi
      done
      read prompt
      break
    fi
  done
  #press e to exit and any other key to continue
  read -n1 status
done
#when e is presse, go here
