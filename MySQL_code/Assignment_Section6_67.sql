-- yr mo sessions orders
-- week_start_date sessions orders
use mavenfuzzyfactory;

SELECT
	YEAR(website_sessions.created_at),
    MONTH(website_sessions.created_at),
	COUNT( DISTINCT website_sessions.website_session_id),
    COUNT( DISTINCT order_id)
FROM website_sessions
	LEFT JOIN orders
		ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at < '2013-01-02'
GROUP BY 1,2;

SELECT

    MIN(DATE(website_sessions.created_at)),
	COUNT( DISTINCT website_sessions.website_session_id),
    COUNT( DISTINCT order_id)
FROM website_sessions
	LEFT JOIN orders
		ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at < '2013-01-02'
GROUP BY WEEK(website_sessions.created_at)
ORDER BY 1;