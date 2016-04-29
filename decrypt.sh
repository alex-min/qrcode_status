#!/bin/bash
for file in `find . -type f -name '*.gpg'`;
do
FF=`echo $file | sed 's/.gpg//g'`
echo gpg --decrypt "$file" --output="$FF"
gpg  --output="$FF"  --decrypt "$file"
done