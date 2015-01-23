#!/bin/sh

name=$(basename $1)
u=$(grep USAGE $1 |  sed 's/USAGE="//' | sed 's/"$//') 
echo "'$name' $u"  > usage-$name.txt
