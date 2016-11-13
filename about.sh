#!/bin/bash

source config.cfg

figlet -f script "Your Profile"
curl -sX GET "https://graph.facebook.com/v2.3/me?fields=name%2Cpicture%2Cbirthday%2Cemail%2Chometown%2Cgender%2Ceducation%2Cwork%2Cgames%2Cbooks%2Cmusic%2Cmovies%2Cfavorite_athletes%2Cfavorite_teams&access_token=$access_token" > about.txt


name=$(jq -r '.name' about.txt)
gender=$(jq -r '.gender' about.txt)
hometown=$(jq -r '.hometown.name' about.txt)
email=$(jq -r '.email' about.txt)
favorite_teams=$(jq -r '.favorite_teams[].name' about.txt | tr "\n" '~')
favorite_athletes=$(jq -r '.favorite_athletes[].name' about.txt | tr "\n" '~')
games=$(jq -r '.games.data[].name' about.txt | tr "\n" '~')
music=$(jq -r '.music.data[].name' about.txt | tr "\n" '~')
movies=$(jq -r '.movies.data[].name' about.txt | tr "\n" '~')
birthday=$(jq -r '.birthday' about.txt)
books=$(jq -r '.books.data[].name' about.txt | tr "\n" '~')
picture=$(jq -r '.picture.data.url' about.txt)

echo -e "Name: $name\n\n"

echo -e "Profile Picture:$picture\n\n"

echo -e "Birthday: $birthday\n\n"

echo -e "Email: $email\n\n"

echo -e "Hometown: $hometown\n\n"

echo -e "Gender: $gender\n\n"

echo -e "Education:"
count=$(jq -r '.education | length' about.txt)
i=0
for((i=0;i<count;i++))
do
	echo -e "$(jq -r ".education[$i].type" about.txt):\c"
	echo -e $(jq -r ".education[$i].school.name" about.txt)
done

echo

count=$(jq -r '.work | length' about.txt)
i=0
if [ $count -ge 1 ]
then
	echo -e "Work:"
	for((i=0;i<count;i++))
	do
		echo -e "Employer:$(jq -r ".work[$i].employer.name" about.txt)"
		echo -e "Location:$(jq -r ".work[$i].location.name" about.txt)"
		echo -e "Position:$(jq -r ".work[$i].position.name" about.txt)"
	done
fi

echo

if [ -n "$games" ]
then
	echo -e "Games:"
	echo -e $games | tr '~' "\n"
fi

if [ -n "$books" ]
then
	echo -e "Books:"
	echo -e $books | tr '~' "\n"
fi

if [ -n "$music" ]
then
	echo -e "Music:"
	echo -e $music | tr '~' "\n"
fi

if [ -n "$movies" ]
then
	echo -e "Movies:"
	echo -e $movies | tr '~' "\n"
fi

if [ -n "$favorite_teams" ]
then
	echo -e "Favorite teams:"
	echo -e $favorite_teams | tr '~' "\n"
fi

if [ -n "favorite_athletes" ]
then
	echo -e "Favorite athletes:"
	echo -e $favorite_athletes | tr '~' "\n"
fi
