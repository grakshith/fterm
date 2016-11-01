#! /bin/bash
 curl -s -X GET "https://graph.facebook.com/v2.3/me?fields=about%2Ccover%2Chometown%2Cgender%2Cname%2Cinterested_in%2Cfavorite_athletes%2Cfavorite_teams%2Cinspirational_people%2Ceducation%2Cemail%2Crelationship_status%2Clocation%2Cbirthday%2Cpicture%7Burl%7D&access_token=$access_token" > about.txt
 name=$(jq -r '.name' about.txt)
 gender=$(jq -r '.gender' about.txt)
 hometown=$(jq -r '.hometown.name' about.txt)
 email=$(jq -r '.email' about.txt)
 favorite_teams=$(jq -r '.favorite_teams[].name' about.txt | tr "\n" '~')
 favorite_atheletes=$(jq -r '.favorite_athletes[].name' about.txt | tr "\n" '~')
 birthday=$(jq -r '.birthday' about.txt)
 picture=$(jq -r '.picture.data.url' about.txt) 
 echo "name: $name"
 echo "birthday: $birthday"
 echo "email: $email"
 echo "hometown: hometown"
 echo "gender: $gender"
 count=$(jq -r '.education[] | length' about.txt)
 i=0
 for((i=0;i<count;i++))
 do
 	echo -e "$(jq -r ".education[$i].type" about.txt):"
 	jq -r ".education[$i].school.name" about.txt
 done
 echo "favorite_teams:"
 echo $favorite_teams | tr '~' "\n"
 echo "favorite_athletes:"
 echo $favorite_atheletes | tr '~' "\n"
