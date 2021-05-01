#!/bin/bash

set -e

mkdir /tmp/$$
echo /tmp/$$

# copy education program data to tmp dir
tar -xzf /mnt/data/xmldatadumps/public/other/educationprogram/cswiki.educationprogram.20180919.tar.gz -C /tmp/$$

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
"

# load data
analytics-mysql staging < /tmp/$$/cswiki.ep_articles.20180919
analytics-mysql staging -- -e 'SELECT * FROM ep_articles' > /tmp/$$/ep_articles.tsv
hive --database=urbanecm -e "
LOAD DATA LOCAL INPATH '/tmp/$$/ep_articles.tsv' OVERWRITE INTO TABLE urbanecm_cswiki_ep_articles;
"
