use mavenfuzzyfactory;

CREATE TEMPORARY TABLE Q1
SELECT
	YEAR(website_sessions.created_at),
	MONTH(website_sessions.created_at),
    COUNT(website_sessions.utm_source),
    COUNT(orders.website_session_id)
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id

WHERE website_sessions.utm_source = 'gsearch'
GROUP BY 1, 2;

SELECT * FROM Q1;

CREATE TEMPORARY TABLE Q2
SELECT
	YEAR(website_sessions.created_at),
	MONTH(website_sessions.created_at),
    COUNT(website_sessions.utm_source),
    COUNT(orders.website_session_id),
    website_sessions.utm_source,
    website_sessions.utm_campaign
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id

WHERE website_sessions.utm_source = 'gsearch'
GROUP BY 1,
	2,
	website_sessions.utm_campaign;

SELECT * FROM Q2;

CREATE TEMPORARY TABLE Q3
SELECT
	YEAR(website_sessions.created_at),
	MONTH(website_sessions.created_at),
    COUNT(website_sessions.utm_source),
    COUNT(orders.website_session_id),
    website_sessions.utm_source,
    website_sessions.utm_campaign,
    website_sessions.device_type
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id

WHERE website_sessions.utm_source = 'gsearch'
	AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY 1,
	2,
	website_sessions.device_type;
    
SELECT * FROM Q3;

CREATE TEMPORARY TABLE Q4
SELECT
	YEAR(website_sessions.created_at),
	MONTH(website_sessions.created_at),
    COUNT(website_sessions.utm_source),
    COUNT(orders.website_session_id),
    COUNT(CASE WHEN website_sessions.utm_source = 'gsearch' THEN 'gsearch' ELSE NULL END),
    COUNT(CASE WHEN website_sessions.utm_source != 'gsearch' THEN 'other' ELSE NULL END),
    website_sessions.utm_campaign,
    website_sessions.device_type
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
        
GROUP BY 1, 2;

SELECT * FROM Q4;