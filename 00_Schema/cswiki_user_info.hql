CREATE TABLE cswiki_user_info(
	user_name string,
	user_tenure bigint,
	user_editcount bigint,
	user_gender string
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY "\t"
STORED AS TEXTFILE
LOCATION '/user/urbanecm/data/cswiki_user_info';
