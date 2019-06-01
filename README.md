# es-health-tracker
Elasticsearch Health Tracker

Simple personal health tracker for importing data into ES and being able to easily analyze it.

Inspired from: https://www.elastic.co/blog/managing-my-type-1-diabetes-with-elastic-machine-learning


## Using

make index


Open your browser
http://localhost:5601



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
