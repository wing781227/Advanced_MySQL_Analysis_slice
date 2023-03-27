use mavenfuzzyfactory;

SELECT
-- 	YEARWEEK(website_sessions.created_at)
    MIN(DATE(website_sessions.created_at)),
    COUNT(DISTINCT website_sessions.website_session_id),
    COUNT( DISTINCT CASE WHEN website_sessions.utm_source = 'gsearch' THEN website_sessions.website_session_id ELSE NULL END) AS gsearch,
    COUNT( DISTINCT CASE WHEN website_sessions.utm_source = 'bsearch' THEN website_sessions.website_session_id ELSE NULL END) AS bsearch
    
FROM website_sessions
WHERE website_sessions.utm_source IN ('gsearch', 'bsearch')
	AND website_sessions.created_at > '2012-08-22'
    AND website_sessions.created_at < '2012-11-29'
    AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY YEARWEEK(website_sessions.created_at);