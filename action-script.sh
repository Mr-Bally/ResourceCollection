#!/bin/bash
echo Starting script, current dict:
echo $(ls)

knownUrlFailures=("https://haveibeenpwned.com/" "https://news.ycombinator.com/")

fileContents=`cat README.md`
echo Finished reading README

matches="$(echo $fileContents | grep -Po "\(http[s]+:\/\/\S+\)")"

for word in $matches; do
    echo Processing: $word
    knownFail=0
    url="$(echo $word | grep -Po "http[s]?:\/\/\S+[^)]")"

    echo Calling $url
    result=$(curl -I -s "$url" -o /dev/null -w "%{http_code}\n")
    echo Result: $result 

    if [ "$result" -ne 200 ] ; then
        echo Error calling $url

        for item in "${knownUrlFailures[@]}"; do
            if [ "$url" == "$item" ]; then
                knownFail=1
            fi
        done

        if [ "$knownFail" -ne 0 ]; then
            echo Known failure $url
        else
            echo Unknown failure $url. Exiting
            exit 1;
        fi
    fi
done

echo Script finished
