#!/bin/bash

source config.sh

TSHEETS=(Notes MorningCheckin NightCheckin Bowels)

#BACKFILLSHEETS=(BF BF)

WEEKLY=""
WSHEETS=

MONTHLY=""
MSHEETS=

for S in ${TSHEETS[*]}
do
	curl --remote-name --location --remote-header-name "https://docs.google.com/spreadsheets/d/$TRACKINGKEY/gviz/tq?tqx=out:csv&sheet=$S"
	mv data.csv "data/csvs/$S.csv"
done
