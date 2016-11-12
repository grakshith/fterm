#! /bin/bash
curl -s -X GET \
 "https://graph.facebook.com/v2.8/me?fields=friends&access_token=EAACEdEose0cBABxsKFVmKvVEKVSTe0Mrj9wfBMsP7ZCnccoq7UF1tQoO9ZCZCQeGl0KtbRMA7mnAd1CSQ4XAHPumbOk84i5JrFfEkb00roQuZCFbQ68ZB4uSfhgGaibPH5SgAqOhEAeo794qbG83XAwCT2mlNHJunqqAjA9SnxwZDZD" > test.txt
 echo Friends
 echo -n "Count:"
echo " $(jq '.friends.summary[]' test.txt)" 
echo "Names:"
for data in $(jq '.friends.data[].name' test.txt)
do
echo " $data"
done
 
