CREATE TABLE wmcz_outreach_dashboard_courses_csv(
	campaign string,
	course_slug string,
	course_start date,
	course_end date,
	student_count bigint,
	edit_count bigint,
	upload_count bigint,
	uploads_in_use bigint,
	upload_usages_count bigint,
	wikis array<string>
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY "\t"
COLLECTION ITEMS TERMINATED BY "|"
STORED AS TEXTFILE
LOCATION '/user/urbanecm/data/wmcz_outreach_dashboard_courses_csv';
