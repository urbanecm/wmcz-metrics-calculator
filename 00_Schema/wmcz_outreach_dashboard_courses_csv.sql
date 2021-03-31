create table wmcz_outreach_dashboard_courses_csv(
	c_campaign string,
	c_course_slug string,
	c_course_start date,
	c_course_end date,
	wikis string
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY "\t"
STORED AS TEXTFILE
LOCATION '/user/urbanecm/data/wmcz_outreach_dashboard_courses_csv';
