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
	page_namespace,
	page_namespace_is_content,
	revision_id,
	revision_parent_id,
	event_timestamp,
	revision_text_bytes_diff,
	event_user_revision_count,
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
