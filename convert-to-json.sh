#!/bin/bash

source config.sh

FILES=(
	Notes
	MorningCheckin
	NightCheckin
	Bowels
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

for F in ${FILES[*]}
do
	python build-docs.py "$CSVPATH/$F.csv" > "$JSONPATH/$F.json"
done

python build-docs.py "$CSVPATH/symple.csv" > "$JSONPATH/symple.json"

python build-docs.py "$CSVPATH/hrv.csv" > "$JSONPATH/hrv.json"

for F in ${APPLFILES[*]}
do
	echo "$F"
	python build-docs.py "$CSVPATH/apple_health_export/$F.csv" > "$JSONPATH/$F.json"
done
