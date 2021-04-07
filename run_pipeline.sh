#!/bin/bash

set -e

scriptdir="`dirname \"$0\"`"
cd $scriptdir

# STEP 1: Drop all tables and recreate them using DDL files in 00_Schema
hive -e "
USE urbanecm;

DROP TABLE IF EXISTS wmcz_outreach_dashboard_courses_csv;
$(cat 00_Schema/wmcz_outreach_dashboard_courses_csv.hql)
DROP TABLE IF EXISTS wmcz_outreach_dashboard_courses_users_raw;
$(cat 00_Schema/wmcz_outreach_dashboard_courses_users_raw.hql)
DROP TABLE IF EXISTS wmcz_outreach_dashboard_edits;
$(cat 00_Schema/wmcz_outreach_dashboard_edits.hql)
"

# STEP 2: Refresh our knowledge about Outreach Dashboard courses
bash 01_Import_dashboard_users/load_dashboard_courses.sh

# STEP 3: Build table with edits
hive -f 02_Load_edits/load_data_to_edits.hql

# STEP 4: Generate data dump
# For now, accessible from https://people.wikimedia.org/~urbanecm/wmcz/dashboard-stats-data/, but that's likely to change
# when the pipeline becomes actually used by WMCZ
bash 03_Generate_dump/generate_dump.sh
