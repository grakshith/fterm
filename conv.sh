#! /bin/bash
countcomments=$(jq -r ".inbox.data[$1].comments.data | length" inbox.txt)
for((i=0;i<countcomments;i++))
do
comment=$(jq -r ".inbox.data[$1].comments.data[$i].message" inbox.txt)
if [ "$comment" != "null" ]
then
user=$(jq -r ".inbox.data[$1].comments.data[$i].from.name" inbox.txt)
echo "$user: $comment"
fi
done
read prompt
./inbox.sh
