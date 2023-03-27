use mavenfuzzyfactory;

SELECT
	website_sessions.device_type,
	website_sessions.utm_source,
	COUNT(DISTINCT website_sessions.website_session_id),
    COUNT(DISTINCT orders.order_id),
    COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id)
    
FROM website_sessions
	LEFT JOIN orders
		ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.utm_source IN ('gsearch', 'bsearch')
	AND website_sessions.created_at > '2012-08-22'
    AND website_sessions.created_at < '2012-09-19'
    AND website_sessions.utm_campaign = 'nonbrand'

GROUP BY 1,2;