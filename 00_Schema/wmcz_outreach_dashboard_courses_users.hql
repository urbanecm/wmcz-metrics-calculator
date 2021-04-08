CREATE TABLE wmcz_outreach_dashboard_courses_users(
	campaign string,
	course_slug string,
	course_start date,
	user_role string,
	user_name string,
	user_tenure_bucket string,
	user_editcount_bucket string
)
STORED AS PARQUET
LOCATION '/user/urbanecm/data/wmcz_outreach_dashboard_courses_users';
