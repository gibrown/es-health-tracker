#!/bin/bash

cd es/elasticsearch-7.1.0
bin/elasticsearch >> es.log &

cd ../kibana-7.1.0
bin/kibana >> kibana.log &

cd ../..
open http://localhost:5601
