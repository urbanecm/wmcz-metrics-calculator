#!/bin/bash

set -e

scriptdir="`dirname \"$0\"`"
cd $scriptdir

mkdir /tmp/$$
echo /tmp/$$

analytics-mysql cswiki < account_info.sql > /tmp/$$/account_info.tsv

hive -e "
USE urbanecm;

LOAD DATA LOCAL INPATH '/tmp/$$/account_info.tsv' INTO TABLE cswiki_user_info;
"

rm -rf /tmp/$$
