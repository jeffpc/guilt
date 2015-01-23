#!/bin/sh

name=$(basename $1)
u=$(grep USAGE $1 |  sed 's/USAGE="//' | sed 's/"$//') 
echo "'`echo $name | sed -e 's/^guilt-/guilt /'`' $u"  > usage-$name.txt
