CREATE TABLE wmcz_outreach_dashboard_courses_users_raw(
	cu_campaign string,
	cu_course_slug string,
	cu_user_role string,
	cu_user_name string
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY "\t"
STORED AS TEXTFILE
LOCATION '/user/urbanecm/data/wmcz_outreach_dashboard_courses_users_raw';
