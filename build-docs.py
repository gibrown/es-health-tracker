#/bin/python

import sys
import csv
import json
from datetime import *

if ( len(sys.argv) < 2 ):
    sys.exit( 'need to specify csv' )

csv_fname=sys.argv[1]

comma_flds = {
    "Options",
    "Problems",
    "Status"
}

appl_use_duration = {
    "AppleStandHour",      #const string
    "HighHeartRateEvent",  #no value
    "MindfulSession",      #no value
    "SleepAnalysis"        #diff strings for status, start with HKCategoryValueSleepAnalysis
}

hrv_rename = {
    "HRV": "HRV_val",
    "Morning Readiness": "HRV_readiness",
    "HRV CV": "HRV_CV",
    "HR": "HRV_HR",
    "lnRmssd": "HRV_lnRmssd",
    "Rmssd": "HRV_Rmssd",
    "Nn50": "HRV_Nn50",
    "Pnn50": "HRV_Pnn50",
    "Sdnn": "HRV_Sdnn",
    "Low Frequency Power": "HRV_low_power",
    "High Frequency Power": "HRV_hi_power",
    "LF/HF Ratio": "HRV_power_ratio",
    "Total Power": "HRV_total_power"
}

symple_rename = {
    "0 Walking problems": "Walking problems",
    "1 Legs burning": "Legs Burning",
    "2 Muscle weakness": "Muscle Weakness",
    "3 Hip sore": "Hip Sore",
    "4 Spacisity": "Spacisity",
    "5 Poor balance": "Poor Balance",
    "6 Pain level 1-5+": "Pain Level",
    "7 Depressed 1-5+": "Depressed",
    "Almost fell": "Almost fell",
    "Back (low) pain": "Back pain",
    "Bad sleep": "Bad sleep",
    "Bowel discomfort": "Bowel discomfort",
    "CNS Fatigue tired": "CNS Fatigue tired",
    "Difficulty concentrating": "Difficulty concentrating",
    "Fell": "Fell",
    "Hand tingling/pain": "Hand tingling",
    "Headache": "Headache",
    "Insomnia": "Insomnia",
    "Leg stiffness": "Leg stiffness",
    "Nausea/dizzy ": "Nausea/dizzy",
    "Shoulder Soreness": "Shoulder Soreness",
    "Socks on feet": "Socks on feet",
    "Stressed": "Stressed",
    "Weakness": "Weakness",
    '""Exercise""': "Exercise",
}

def clean_fld_name( fld ):
    f = fld.lower()
    f = f.replace( ' ', '_' )
    f = f.replace( '-', '_' )
    f = f.replace( '%', 'perc' )
    f = f.replace( '/', '_' )
    return f

appl_file = False
symple_file = False
hrv_file = False
p1 = False
with open(csv_fname, 'r' ) as csvfile:
    rdr = csv.DictReader(csvfile, delimiter=",", quotechar='"', escapechar='\\', doublequote=False)
    if ( 'sourceName' in rdr.fieldnames ):
        appl_file = True
    if ( 'Period' in rdr.fieldnames ):
        symple_file = True
    if ( 'Pnn50' in rdr.fieldnames ):
        hrv_file = True
    for row in rdr:
        doc = {}

        if ( appl_file ):
            s = datetime.strptime( row["startDate"][0:-6], "%Y-%m-%d %H:%M:%S" )
            e = datetime.strptime( row["endDate"][0:-6], "%Y-%m-%d %H:%M:%S" )
            doc['timestamp'] = s.strftime( '%Y-%m-%d %H:%M:%S' )
            doc['duration'] = int( (e - s).total_seconds() )
            if ( row['type'] in appl_use_duration ):
                fld = row['type']
                if ( row['type'] == 'SleepAnalysis' ):
                    fld = fld + '_' + row['value'].replace( 'HKCategoryValueSleepAnalysis', '' )
                doc[clean_fld_name(fld)] = doc['duration']
            else:
	        fld = row['type'] + '_' + row['unit']
	        doc[clean_fld_name(fld)] = float( row['value'] )
	        if ( doc['duration'] > 0 ):
	            doc[clean_fld_name(fld + '_rate')] = float( row['value'] ) / doc['duration']

        elif ( symple_file ):
            d = datetime.strptime( row['Date'], '%Y-%m-%d' )
            if ( 'nite' == row['Period'] ):
                d += timedelta(hours=4)
            elif ( 'am' == row['Period'] ):
                d += timedelta(hours=8)
            elif ( 'mid' == row['Period'] ):
                d += timedelta(hours=14)
            elif ( 'pm' == row['Period'] ):
                d += timedelta(hours=20)
            doc['timestamp'] = d.strftime( '%Y-%m-%d %H:%M:%S' )

            blank = True
            for key, value in row.items():
                if ( key in symple_rename ):
                    if ( not value ):
                    	v = 0
                    else:
                    	v = int( value )
                    if ( v > 0 ):
                        blank = False
                        doc[clean_fld_name(symple_rename[key])] = v
            if ( blank ):
                continue   #blank doc

        elif ( hrv_file ):
            if ( 'readiness' != row['Type'] ):
                continue
            d = datetime.strptime( row["Date Time Start"], "%Y-%m-%d %H:%M:%S" )
	    doc['duration'] = int( round( float( row["Duration"] ) ) )
            doc['timestamp'] = d.strftime( '%Y-%m-%d %H:%M:%S' )
            for key, value in row.items():
                if ( key in hrv_rename ):
                    if ( not value ):
                    	v = 0
                    else:
                    	v = float( value )
                    doc[clean_fld_name(hrv_rename[key])] = v

        else:
            for key, value in row.items():
                v = value
                if ( key in comma_flds ):
                    if not value:
                        v = []
                    else:
                        v = value.split( ',' )
                        while("" in v) :
			    v.remove("")
                doc[clean_fld_name(key)] = v

        print( json.dumps(doc, separators=(',',':')) )

