#!/bin/bash
echo Starting script

fileContents=$(<README.md)
echo Finished reading README

matches="$(echo $fileContents | grep -Po "\(http[s]+:\/\/\S+\)")"

echo Matches: $matches

for word in $matches; do
    echo Processing: $word
    
    url="$(echo $word | grep -Po "http[s]?:\/\/\S+[^)]")"

    echo Calling $url
    result=$(curl -I -s "$url" -o /dev/null -w "%{http_code}\n")
    echo Result: $result 

    if ((result!=200)); then
        echo Error calling $url
        exit 1;
    fi
done

echo Script finished
