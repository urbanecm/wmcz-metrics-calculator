#!/bin/bash

set -e

scriptdir="`dirname \"$0\"`"
cd $scriptdir

if [ ! -e data.tar.gz ]; then
	echo "data.tar.gz does not exist, run run_pipeline.sh"
	exit 1
fi

if [ ! -e data ]; then
	echo "data does not exist, run run_pipeline.sh"
	exit 2
fi

mkdir -p /srv/published/datasets/one-off/urbanecm/
cp -r data /srv/published/datasets/one-off/urbanecm/wmcz-dashboard-data
cp data.tar.gz /srv/published/datasets/one-off/urbanecm/wmcz-dashboard-data/wmcz-dashboard-data.tar.gz
