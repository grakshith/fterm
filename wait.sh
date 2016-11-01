#! /bin/bash

spin='-\|/'

i=0
while kill -0 $1 2>/dev/null
do
  i=$(( (i+1) %4 ))
  printf "\r${spin:$i:1}"
  sleep .1
done
printf "\r"
echo ""