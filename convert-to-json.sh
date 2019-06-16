#!/bin/bash

source config.sh

SHEETFILES=(
	Notes
	MorningCheckin
	NightCheckin
	Bowels
	BFMornCheckin
	BFNightCheckin
	BFBowels1
	BFBowels2
	BFNotes
)

APPLFILES=(
	ActiveEnergyBurned
	AppleExerciseTime
	AppleStandHour
	BasalEnergyBurned
	BodyFatPercentage
	BodyMass
	BodyMassIndex
	DistanceSwimming
	DistanceWalkingRunning
	FlightsClimbed
	HeartRate
	HeartRateVariabilitySDNN
	HighHeartRateEvent
	MindfulSession
	RespiratoryRate
	RestingHeartRate
	SleepAnalysis
	StepCount
	SwimmingStrokeCount
	WalkingHeartRateAverage

#skip - different format - maybe redundant
#	ActivitySummary
#	Workout
)

for F in ${SHEETFILES[*]}
do
	echo "$F"
	python build-docs.py "$CSVPATH/$F.csv" > "$JSONPATH/$F.json"
done

echo "symple"
python build-docs.py "$CSVPATH/symple.csv" > "$JSONPATH/symple.json"

echo "hrv"
python build-docs.py "$CSVPATH/hrv.csv" > "$JSONPATH/hrv.json"

python applehealth2json.py "$CSVPATH/apple_health_export/export.xml"

for F in ${APPLFILES[*]}
do
	echo "$F"
	python build-docs.py "$CSVPATH/apple_health_export/$F.csv" > "$JSONPATH/$F.json"
done
