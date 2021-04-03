SELECT
	ce_campaign,
	COUNT(*) AS edits,
	SUM(ce_revision_text_bytes_diff) AS net_sum,
	SUM(ABS(ce_revision_text_bytes_diff)) AS absolute_sum,
	SUM(IF(ce_revision_text_bytes_diff > 0, ce_revision_text_bytes_diff, 0)) AS positive_sum
FROM urbanecm.wmcz_outreach_dashboard_edits
GROUP BY ce_campaign;
