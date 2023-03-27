USE mavenfuzzyfactory;

SELECT
	MIN(DATE(created_at)) AS week_start,
    COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN website_session_id ELSE NULL END) AS dtop_sessions,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END) AS mob_sessions
FROM website_sessions

WHERE
	website_sessions.created_at > '2012-04-15' AND 
    website_sessions.created_at < '2012-06-09' AND
	website_sessions.utm_source = 'gsearch' AND
    website_sessions.utm_campaign = 'nonbrand'
GROUP BY
	YEAR(created_at),
	WEEK(created_at)
-- ORDER BY
