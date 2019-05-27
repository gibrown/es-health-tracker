#!/bin/bash


source config.sh

curl -X PUT "$INDEXURL" -H 'Content-Type: application/json' -d @index-settings.json

curl -X PUT "$INDEXURL/_mapping" -H 'Content-Type: application/json' -d @mappings.json

#exit

wc -l data/json/*

for F in `ls $JSONPATH`
do
	./index-data.sh "$JSONPATH/$F"
done
