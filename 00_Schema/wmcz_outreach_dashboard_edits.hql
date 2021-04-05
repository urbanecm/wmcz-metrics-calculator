CREATE TABLE wmcz_outreach_dashboard_edits(
	wiki_db string,
	ce_campaign string,
	ce_course_slug string,
	ce_course_start date,
	ce_course_end date,
	ce_user_name string,
	ce_user_role string,
	ce_page_id bigint,
	ce_creates_new_page boolean,
	ce_page_namespace string,
	ce_page_namespace_is_content boolean,
	ce_revision_id bigint,
	ce_revision_parent_id bigint,
	ce_event_timestamp string,
	ce_revision_text_bytes_diff bigint,
	ce_user_edit_count_bucket string,
	ce_user_tenure_bucket string,
	ce_event_user_groups array<string>
)
STORED AS PARQUET
LOCATION '/user/urbanecm/data/wmcz_outreach_dashboard_edits';
