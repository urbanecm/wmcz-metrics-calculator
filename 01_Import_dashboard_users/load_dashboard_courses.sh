#!/bin/bash

set -e

source ~/venv/bin/activate
export HTTP_PROXY=http://webproxy:8080
export HTTPS_PROXY=http://webproxy:8080
export http_proxy=http://webproxy:8080
export https_proxy=http://webproxy:8080
export NO_PROXY=127.0.0.1,::1,localhost,.wmnet
export no_proxy=127.0.0.1,::1,localhost,.wmnet

scriptdir="`dirname \"$0\"`"
cd $scriptdir

mkdir /tmp/$$
python3 generate_dashboard_users.py /tmp/$$
echo /tmp/$$
hive -e "
USE urbanecm;

-- Load wmcz_outreach_dashboard_courses_csv
TRUNCATE TABLE wmcz_outreach_dashboard_courses_csv;
LOAD DATA LOCAL INPATH '/tmp/$$/courses.tsv' INTO TABLE wmcz_outreach_dashboard_courses_csv;

-- Load wmcz_outreach_dashboard_courses_users_csv
TRUNCATE TABLE wmcz_outreach_dashboard_courses_users_csv;
LOAD DATA LOCAL INPATH '/tmp/$$/coursesUsers.tsv' INTO TABLE wmcz_outreach_dashboard_courses_users_csv;
"

rm -rf /tmp/$$
