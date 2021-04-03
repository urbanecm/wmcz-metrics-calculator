#!/bin/bash

set -e

scriptdir="`dirname \"$0\"`"
cd ..
rm -f data.tar.gz
cd data
rm -rf schema
rm -f *.txt

# Dump data from hive
mkdir schema
hive -e "DESCRIBE urbanecm.wmcz_outreach_dashboard_edits" > schema/wmcz_outreach_dashboard_edits.txt
hive -e "SELECT * FROM urbanecm.wmcz_outreach_dashboard_edits" > wmcz_outreach_dashboard_edits.txt
hive -e "DESCRIBE urbanecm.wmcz_outreach_dashboard_courses_users_csv" > schema/wmcz_outreach_dashboard_courses_users_csv.txt
hive -e "SELECT * FROM urbanecm.wmcz_outreach_dashboard_courses_users_csv" > wmcz_outreach_dashboard_courses_users_csv.txt
hive -e "DESCRIBE urbanecm.wmcz_outreach_dashboard_courses_csv" > schema/wmcz_outreach_dashboard_courses_csv.txt
hive -e "SELECT * FROM urbanecm.wmcz_outreach_dashboard_courses_csv" > wmcz_outreach_dashboard_courses_csv.txt
