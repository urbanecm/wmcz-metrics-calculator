#!/bin/bash

set -e

scriptdir="`dirname \"$0\"`"
cd $scriptdir

echo hive -e "
USE urbanecm;

DROP TABLE IF EXISTS wmcz_outreach_dashboard_courses_csv;
$(cat 00_Schema/wmcz_outreach_dashboard_courses_csv.hql)
DROP TABLE IF EXISTS wmcz_outreach_dashboard_courses_users_csv;
$(cat 00_Schema/wmcz_outreach_dashboard_courses_users_csv.hql)
DROP TABLE IF EXISTS wmcz_outreach_dashboard_edits;
$(cat 00_Schema/wmcz_outreach_dashboard_edits.hql)
"

bash 01_Import_dashboard_users/load_dashboard_courses.sh

hive -f 02_Load_edits/load_data_to_edits.sql

bash 03_Generate_dump/generate_dump.sh
