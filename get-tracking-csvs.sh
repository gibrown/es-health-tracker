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

function i_do_say() {
	osascript -e "display notification \"$*\" with title \"Do It\""
	say --rate 250 $*
}

function timed_confirm() {
	i_do_say $1
	delay=$3
	cnt=0
	while true; do
		read -n 1 -t $delay -p "$delay seconds: 'd' to delay 5 min or any key to continue" varkey
		if [ $? -ne 0 ]; then
			echo
			i_do_say $2
			cnt=$((cnt+1))
			if [[ "$cnt" -gt 7 ]]; then
				cnt=0
				i_do_say 'Are you paying attention? Time to start a different script?'
			fi
		elif [ "d" == "$varkey" ]; then
			varkey=''
			delay="$(($delay + 300))"
			echo
			echo "Delaying 5 min"
		else
			echo
			break
		fi
done
}


for S in ${TSHEETS[*]}
do
	rm data.csv
	curl --remote-name --location --remote-header-name "https://docs.google.com/spreadsheets/d/$TRACKINGKEY/gviz/tq?tqx=out:csv&sheet=$S"
	mv data.csv "$CSVPATH/$S.csv"
done

for S in ${BACKFILLSHEETS[*]}
do
	rm data.csv
	curl --remote-name --location --remote-header-name "https://docs.google.com/spreadsheets/d/$TRACKINGKEY/gviz/tq?tqx=out:csv&sheet=$S"
	mv data.csv "$CSVPATH/$S.csv"
done

open https://dashboard.elitehrv.com/personal/data/individual
timed_confirm "Download HRV" "Done with HRV Download?" 300

timed_confirm "Download Symple Data from App" "Done with Symple?" 300

timed_confirm "Download Apple Data from App" "Done with Apple Data?" 300
