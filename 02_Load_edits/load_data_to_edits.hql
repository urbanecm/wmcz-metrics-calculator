TRUNCATE TABLE urbanecm.wmcz_outreach_dashboard_edits;

WITH
course_editors AS (
	SELECT
		cu_campaign,
		cu_course_slug,
		c_course_start,
		c_course_end,
		cu_user_role,
		cu_user_name
	FROM urbanecm.wmcz_outreach_dashboard_courses_users_csv
	JOIN urbanecm.wmcz_outreach_dashboard_courses_csv ON c_course_slug=cu_course_slug
	WHERE
		cu_user_role="editor"
)

INSERT INTO TABLE urbanecm.wmcz_outreach_dashboard_edits

SELECT DISTINCT
	wiki_db,
	cu_campaign,
	cu_course_slug,
	c_course_start,
	c_course_end,
	cu_user_name,
	cu_user_role,
	page_id,
	revision_parent_id == 0 AS creates_new_page,
	CASE page_namespace
		WHEN 0 THEN 'Main'
		WHEN 1 THEN 'Talk'
		WHEN 2 THEN 'User'
		WHEN 3 THEN 'User talk'
		WHEN 4 THEN 'Project'
		WHEN 5 THEN 'Project talk'
		WHEN 6 THEN 'File'
		WHEN 7 THEN 'File talk'
		WHEN 8 THEN 'MediaWiki'
		WHEN 9 THEN 'MediaWiki talk'
		WHEN 10 THEN 'Template'
		WHEN 11 THEN 'Template talk'
		WHEN 12 THEN 'Help'
		WHEN 13 THEN 'Help talk'
		WHEN 14 THEN 'Category'
		WHEN 15 THEN 'Category talk'
		WHEN 122 THEN 'Property'
		WHEN 123 THEN 'Property talk'
		ELSE 'Other'
	END AS namespace_name,
	page_namespace_is_content,
	revision_id,
	revision_parent_id,
	event_timestamp,
	revision_text_bytes_diff,
	CASE
		WHEN event_user_revision_count < 5 THEN '1-4'
		WHEN event_user_revision_count >= 5 AND event_user_revision_count < 100 THEN '5-99'
		WHEN event_user_revision_count >= 100 AND event_user_revision_count < 1000 THEN '100-999'
		WHEN event_user_revision_count >= 1000 AND event_user_revision_count < 10000 THEN '1000-9999'
		WHEN event_user_revision_count >= 10000 THEN '10000+'
		ELSE 'Undefined'
	END AS user_edit_count_bucket,
	event_user_groups
FROM wmf.mediawiki_history
JOIN course_editors ON cu_user_name=event_user_text
WHERE
	snapshot="2021-03" AND
	wiki_db="cswiki" AND
	event_entity="revision" AND
	revision_is_deleted_by_page_deletion=false AND
	event_timestamp BETWEEN c_course_start AND c_course_end
;
