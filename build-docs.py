#/bin/python

import sys
import csv
import json

if ( len(sys.argv) < 2 ):
    sys.exit( 'need to specify csv' )

csv_fname=sys.argv[1]

comma_flds = {
    "Options",
    "Problems",
    "Status"
}

with open(csv_fname, 'rb' ) as csvfile:
    rdr = csv.DictReader(csvfile, delimiter=",", quotechar='"', escapechar='\\', doublequote=False)
    for row in rdr:
        doc = {}
        for key, value in row.items():
            v = value
            if ( key in comma_flds ):
            	if not value:
                    v = []
                else:
	            v = value.split( ', ' )
            doc[key] = v

        print json.dumps(doc, separators=(',',':'))

