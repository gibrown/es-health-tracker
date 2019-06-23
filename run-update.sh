#!/bin/bash

source timed-functions.sh

timed_confirm "Update config file" "Config Updated?" 60

./get-tracking-csvs.sh

./convert-to-json.sh

timed_confirm "Start up ES. Start indexing?" "Start indexing?" 60

./make-index.sh

i_do_say "Index ready."

open "http://localhost:5601/app/kibana#/dashboard/99d7ce10-856c-11e9-b2e7-f770ec47c867"
open "http://localhost:5601/app/kibana#/dashboard/a221dea0-8574-11e9-b2e7-f770ec47c867"
open "http://localhost:5601/app/kibana#/dashboard/ff7d8360-857e-11e9-b2e7-f770ec47c867"
