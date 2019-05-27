#!/bin/bash

source config.sh

curl -X PUT "$SERVER/_cluster/settings" -H 'Content-Type: application/json' -d'
{
	"persistent": {
		"cluster.routing.allocation.disk.watermark.low": "20gb",
		"cluster.routing.allocation.disk.watermark.high": "10gb",
		"cluster.routing.allocation.disk.watermark.flood_stage": "5gb",
		"cluster.info.update.interval": "10m"
	}
}
'
