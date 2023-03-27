use mavenfuzzyfactory;

SELECT
	website_sessions.utm_source,
    COUNT(DISTINCT website_sessions.website_session_id),
    COUNT(DISTINCT CASE WHEN website_sessions.device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END),
    COUNT(DISTINCT CASE WHEN website_sessions.device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END)/ COUNT(website_sessions.device_type) AS pct_mobile
    

FROM website_sessions
WHERE website_sessions.created_at BETWEEN '2012-08-22' AND '2012-11-30'
	AND website_sessions.utm_source IN ('bsearch', 'gsearch')
    AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY 1;