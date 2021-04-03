CREATE TABLE wmcz_outreach_dashboard_edits(
	wiki_db string,
	ce_campaign string,
	ce_course_slug string,
	ce_course_start date,
	ce_course_end date,
	ce_user_name string,
	ce_user_role string,
	ce_page_id bigint,
	ce_page_namespace int,
	ce_page_namespace_is_content boolean,
	ce_revision_id bigint,
	ce_revision_parent_id bigint,
	ce_event_timestamp string,
	ce_revision_text_bytes_diff bigint,
	ce_event_user_revision_count bigint
)
STORED AS PARQUET
LOCATION '/user/urbanecm/data/wmcz_outreach_dashboard_edits';
