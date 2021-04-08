USE urbanecm;

TRUNCATE TABLE wmcz_outreach_dashboard_courses_users;

INSERT INTO TABLE wmcz_outreach_dashboard_courses_users

SELECT
	cu_campaign,
	cu_course_slug,
	cu_user_role,
	cu_user_name,
	CASE
            WHEN user_tenure < 86400 THEN 'Under 1 day'
            WHEN user_tenure >= 86400 AND user_tenure < 7*86400 THEN '1 to 7 days'
            WHEN user_tenure >= 7*86400 AND user_tenure < 30*86400 THEN '7 to 30 days'
            WHEN user_tenure >= 30*86400 AND user_tenure < 90*86400 THEN '30 to 90 days'
            WHEN user_tenure >= 90*86400 AND user_tenure < 365*86400 THEN '90 days to 1 year'
            WHEN user_tenure >= 365*86400 AND user_tenure < 1095*86400 THEN '1 to 3 years'
            WHEN user_tenure >= 1095*86400 AND user_tenure < 3650*86400 THEN '3 to 10 years'
            WHEN user_tenure >= 3650*86400 THEN 'Over 10 years'
            ELSE 'Undefined'
        END AS user_tenure_bucket,
	CASE
		WHEN user_editcount < 5 THEN '1-4'
		WHEN user_editcount >= 5 AND user_editcount < 100 THEN '5-99'
		WHEN user_editcount >= 100 AND user_editcount < 1000 THEN '100-999'
		WHEN user_editcount >= 1000 AND user_editcount < 10000 THEN '1000-9999'
		WHEN user_editcount >= 10000 THEN '10000+'
		ELSE 'Undefined'
	END AS user_edit_count_bucket
FROM wmcz_outreach_dashboard_courses_users_raw
LEFT JOIN cswiki_user_info ON cu_user_name=user_name;
