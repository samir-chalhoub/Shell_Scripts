#!/bin/bash
until who | grep "$1" > /dev/null
do 
sleep 5
done

echo "$1 has just logged in "
exit 0
