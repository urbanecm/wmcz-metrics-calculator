#!/bin/bash

set -e

scriptdir="`dirname \"$0\"`"
cd $scriptdir/..
rm -f data.tar.gz
rm -rf data
mkdir data
cd data
rm -rf schema
rm -f *.txt

# Dump data from hive
mkdir schema
# Copy DDL files for easy access
cp ../00_Schema/wmcz_outreach_dashboard_edits.hql schema
cp ../00_Schema/wmcz_outreach_dashboard_courses_users_csv.hql schema
cp ../00_Schema/wmcz_outreach_dashboard_courses_csv.hql schema

# Copy txt version of schema (disabled, not necessary for now)
#hive -e "DESCRIBE urbanecm.wmcz_outreach_dashboard_edits" > schema/wmcz_outreach_dashboard_edits.txt
#hive -e "DESCRIBE urbanecm.wmcz_outreach_dashboard_courses_users_csv" > schema/wmcz_outreach_dashboard_courses_users_csv.txt
#hive -e "DESCRIBE urbanecm.wmcz_outreach_dashboard_courses_csv" > schema/wmcz_outreach_dashboard_courses_csv.txt

# Dump data
hive -e "SELECT * FROM urbanecm.wmcz_outreach_dashboard_edits" > wmcz_outreach_dashboard_edits.txt
hive -e "SELECT * FROM urbanecm.wmcz_outreach_dashboard_courses_users_csv" > wmcz_outreach_dashboard_courses_users_csv.txt
hive -e "SELECT * FROM urbanecm.wmcz_outreach_dashboard_courses_csv" > wmcz_outreach_dashboard_courses_csv.txt

# Create an archive
cd ..
tar czf data.tar.gz data
