#!/bin/bash
for file in `find . -type f -name '*.gpg'`;
do
FILENOGPG=`echo $file | sed 's/.gpg//g'`
echo gpg --decrypt "$file" --output="$FILENOGPG"
gpg  --output="$FF"  --decrypt "$file"
done
