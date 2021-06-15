CREATE TABLE wmcz_outreach_dashboard_edits(
	wiki_db string,
	campaign string,
	course_slug string,
	course_start date,
	course_end date,
	user_name string,
	user_role string,
	page_id bigint,
	creates_new_page boolean,
	page_namespace string,
	page_namespais_content boolean,
	revision_id bigint,
	revision_parent_id bigint,
	event_timestamp string,
	revision_text_bytes_diff bigint,
	user_edit_count_bucket string,
	user_tenure_bucket string,
	event_user_groups array<string>
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY "\t"
STORED AS TEXTFILE
LOCATION '/user/urbanecm/data/wmcz_outreach_dashboard_edits';
