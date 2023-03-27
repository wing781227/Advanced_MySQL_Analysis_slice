use mavenfuzzyfactory;

SELECT
	MIN(DATE(website_sessions.created_at)),
    COUNT(DISTINCT CASE WHEN website_sessions.device_type = 'desktop' AND website_sessions.utm_source = 'gsearch' THEN website_sessions.website_session_id ELSE NULL END) AS g_dtop_session,
    COUNT(DISTINCT CASE WHEN website_sessions.device_type = 'desktop' AND website_sessions.utm_source = 'bsearch' THEN website_sessions.website_session_id ELSE NULL END) AS b_dtop_session,
	COUNT(DISTINCT CASE WHEN website_sessions.device_type = 'desktop' AND website_sessions.utm_source = 'bsearch' THEN website_sessions.website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN website_sessions.device_type = 'desktop' AND website_sessions.utm_source = 'gsearch' THEN website_sessions.website_session_id ELSE NULL END) AS b_pct_of_g_dtop,
    COUNT(DISTINCT CASE WHEN website_sessions.device_type = 'mobile' AND website_sessions.utm_source = 'gsearch' THEN website_sessions.website_session_id ELSE NULL END) AS g_mob_sessions,
    COUNT(DISTINCT CASE WHEN website_sessions.device_type = 'mobile' AND website_sessions.utm_source = 'bsearch' THEN website_sessions.website_session_id ELSE NULL END) AS b_mob_sessions,
    COUNT(DISTINCT CASE WHEN website_sessions.device_type = 'mobile' AND website_sessions.utm_source = 'bsearch' THEN website_sessions.website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN website_sessions.device_type = 'mobile' AND website_sessions.utm_source = 'gsearch' THEN website_sessions.website_session_id ELSE NULL END) AS b_pct_of_g_mob

FROM website_sessions

WHERE website_sessions.utm_campaign = 'nonbrand'
	AND website_sessions.created_at BETWEEN '2012-11-04' AND '2012-12-22'
GROUP BY YEARWEEK(website_sessions.created_at)