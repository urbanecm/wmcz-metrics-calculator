#!/bin/bash

set -e

mkdir /tmp/$$
echo /tmp/$$

# copy education program data to tmp dir
tar -xzf /mnt/data/xmldatadumps/public/other/educationprogram/cswiki.educationprogram.20180919.tar.gz -C /tmp/$$

# disable locking
for f in /tmp/$$/*; do
	grep -v 'LOCK TABLE' $f > /tmp/$$/t && mv /tmp/$$/t $f
	sed -i 1d $f
done

# prepare schema
hive --database=urbanecm -e "
DROP TABLE IF EXISTS urbanecm_cswiki_ep_articles;
CREATE TABLE urbanecm_cswiki_ep_articles (
	article_id bigint,
	article_user_id bigint,
	article_course_id bigint,
	article_page_id bigint,
	article_page_title string,
	article_reviewers string
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY \"\t\"
STORED AS TEXTFILE
LOCATION '/user/urbanecm/data/urbanecm_cswiki_ep_articles';

DROP TABLE IF EXISTS urbanecm_cswiki_ep_courses;
CREATE TABLE urbanecm_cswiki_ep_courses (
	course_id bigint,
	course_org_id bigint,
	course_title string,
	course_name string,
	course_start string,
	course_end string,
	course_description string,
	course_students string,
	course_online_ambs string,
	course_campus_ambs string,
	course_field string,
	course_level string,
	course_term string,
	course_lang string,
	course_instructor_count bigint,
	course_oa_count bigint,
	course_ca_count bigint,
	course_student_count bigint
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY \"\t\"
STORED AS TEXTFILE
LOCATION '/user/urbanecm/data/urbanecm_cswiki_ep_courses';

DROP TABLE urbanecm_cswiki_ep_users_per_course;
CREATE TABLE urbanecm_cswiki_ep_users_per_course (
	upc_user_id bigint,
	upc_course_id bigint,
	upc_role bigint,
	upc_time string
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY \"\t\"
STORED AS TEXTFILE
LOCATION '/user/urbanecm/data/urbanecm_cswiki_ep_users_per_course';
"

# convert data into TSV files
analytics-mysql staging < /tmp/$$/cswiki.ep_articles.20180919
analytics-mysql staging -- -e 'SELECT * FROM ep_articles;' > /tmp/$$/ep_articles.tsv
analytics-mysql staging -- -e 'DROP TABLE ep_articles;'

analytics-mysql staging < /tmp/$$/cswiki.ep_courses.20180919
analytics-mysql staging -- -e '	ALTER TABLE ep_courses DROP COLUMN course_token;'
analytics-mysql staging -- -e 'SELECT * FROM ep_courses;' > /tmp/$$/ep_courses.tsv
analytics-mysql staging -- -e 'DROP TABLE ep_courses;'

analytics-mysql staging < /tmp/$$/cswiki.ep_users_per_course.20180919
analytics-mysql staging -- -e 'SELECT * FROM ep_users_per_course' > /tmp/$$/ep_users_per_course.tsv
analytics-mysql staging -- -e 'DROP TABLE ep_users_per_course;'

# load data to hive
hive --database=urbanecm -e "
LOAD DATA LOCAL INPATH '/tmp/$$/ep_articles.tsv' OVERWRITE INTO TABLE urbanecm_cswiki_ep_articles;
LOAD DATA LOCAL INPATH '/tmp/$$/ep_courses.tsv' OVERWRITE INTO TABLE urbanecm_cswiki_ep_courses;
LOAD DATA LOCAL INPATH '/tmp/$$/ep_users_per_course.tsv' OVERWRITE INTO TABLE urbanecm_cswiki_ep_users_per_course;
"

rm -rf /tmp/$$
