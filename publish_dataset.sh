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

mkdir -p /srv/published/datasets/one-off/wmcz/
rm -rf /srv/published/datasets/one-off/wmcz/dashboard-data
cp -r data /srv/published/datasets/one-off/wmcz/dashboard-data
cat > /srv/published/datasets/one-off/wmcz/dashboard-data/README << EOF
This folder has data about Wikimedia Czech Republic's outreach activities. All data files are in TSV format, dumped from Hive tables (schema available in schemas folder).

Courses administered outside of the Outreach Dashboard are not included here. WMCZ uses Outreach Dashboard starting August 2017.

== Dataset description
 - wmcz_outreach_dashboard_courses_csv – all courses organized by WMCZ, with basic aggregated data about participants
 - wmcz_outreach_dashboard_courses_users – course/participant/facilitator map, with basic data about participants
 - wmcz_outreach_dashboard_edits – data about all edits made by course participants during the course; does not include edits made after/before course

The whole directory is available in tar.gz format as data.tar.gz
EOF
cp data.tar.gz /srv/published/datasets/one-off/wmcz/dashboard-data/data.tar.gz
