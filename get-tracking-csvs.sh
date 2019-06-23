#!/bin/bash

source config.sh

TSHEETS=(Notes MorningCheckin NightCheckin Bowels)

BACKFILLSHEETS=(
	BFMornCheckin
	BFNightCheckin
	BFBowels1
	BFBowels2
	BFNotes
)

WEEKLY=""
WSHEETS=

MONTHLY=""
MSHEETS=

source timed-functions.sh

for S in ${TSHEETS[*]}
do
	rm data.csv
	curl --remote-name --location --remote-header-name "https://docs.google.com/spreadsheets/d/$TRACKINGKEY/gviz/tq?tqx=out:csv&sheet=$S"
	mv data.csv "$CSVPATH/$S.csv"
done

#for S in ${BACKFILLSHEETS[*]}
#do
#	rm data.csv
#	curl --remote-name --location --remote-header-name "https://docs.google.com/spreadsheets/d/$TRACKINGKEY/gviz/tq?tqx=out:csv&sheet=$S"
#	mv data.csv "$CSVPATH/$S.csv"
#done

open https://dashboard.elitehrv.com/personal/data/individual
timed_confirm "Download HRV from 2017 and move to hrv.csv" "Done with HRV Download?" 300

timed_confirm "Download Symple Data from App, then will move" "Done with Symple?" 300
mv ~/Downloads/export.csv data/raw/symple.csv

timed_confirm "Download Apple Data from App, then will move" "Done with Apple Data?" 300
rm -r data/raw/apple_health_export
mv ~/Downloads/export.zip data/raw/apple.zip
unzip data/raw/apple.zip -d data/raw/
