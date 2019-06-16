# es-health-tracker
Elasticsearch Health Tracker

Simple personal health tracker for importing data into ES and being able to easily analyze it.

Inspired from: https://www.elastic.co/blog/managing-my-type-1-diabetes-with-elastic-machine-learning


## Using

Open two terminals and start ES and Kibana with:
```
> cd es/elasticsearch-7.1.0
> bin/elasticsearch
```

and

```
> es/kibana-7.1.0
> bin/kibana
```

Update and import all data into a new index (may need to change index name in config.sh):

```
> ./get-tracking-csvs.sh
> ./convert-to-json.sh
> ./make-index.sh
```

Open http://localhost:5601/app/kibana#/home?_g=()

## Gathering Data


### All Apple Health Data

- Export from the Health App on the "Health Data" tab, click in upper right corner
- create csvs

```
python applehealth2json.py data/csvs/apple_health_export/export.xml
```

-Then process the csvs into json docs

```
python
``


### Symple

Download all data form within the app

### HRV Elite

Requires a Pro account. Download from https://dashboard.elitehrv.com/personal/data/individual


Below is a table of 9 items.

Bowels - time



Swimming Distance
Energy Burned
Sleep
Weight
Pain
HRV Power
HRV
Walking/Running Distance
