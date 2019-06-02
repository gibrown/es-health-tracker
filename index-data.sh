#!/bin/bash

# To prep a file for this script:
# - take a list of docs orig.json with one json doc per line

source config.sh
JSONFILE="$1" #JSON file path name. One doc per line.

DOCS=`wc -l $JSONFILE | awk {'print $1'}`
echo "Indexing $DOCS documents from $JSONFILE to $INDEX on $SERVER in 5 sec"
sleep 5

echo "Prepping bulk data"
rm tmp-bulk/bulk* #cleanup

awk ' {print "{\"index\":{}}"; print;}' $JSONFILE | split -a 4 -l 3000 - tmp-bulk/bulk-

echo "Indexing..."

for F in `ls tmp-bulk`
do
	curl -s -H "Content-Type: application/x-ndjson"  -XPOST "$INDEXURL/_bulk" --data-binary @"tmp-bulk/$F" -o /dev/null
done
