#!/bin/bash

source config.sh

FILES=(
	Notes
	MorningCheckin
	NightCheckin
	Bowels
)


for F in ${FILES[*]}
do
	python build-docs.py "$CSVPATH/$F.csv" > "$JSONPATH/$F.json"
done
