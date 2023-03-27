use mavenfuzzyfactory;


SELECT
	YEAR(website_sessions.created_at),
    QUARTER(website_sessions.created_at),
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) 
FROM website_sessions
	LEFT JOIN orders
		ON orders.website_session_id = website_sessions.website_session_id
GROUP BY 1, 2
ORDER BY 1, 2;

-- session-to-order conversion rate, revenue per order, and revenue per session
SELECT
	YEAR(website_sessions.created_at),
    QUARTER(website_sessions.created_at),
    COUNT(DISTINCT orders.order_id) /COUNT(DISTINCT website_sessions.website_session_id) AS conv_rate,
	SUM(orders.price_usd) /COUNT(DISTINCT orders.order_id) AS rev_per_order,
    SUM(orders.price_usd) /COUNT(DISTINCT website_sessions.website_session_id) AS rev_per_session
FROM website_sessions
	LEFT JOIN orders
		ON orders.website_session_id = website_sessions.website_session_id

GROUP BY 1, 2
ORDER BY 1, 2;


-- orders from Gsearch nonbrand, Bsearch nonbrand, brand search overall, organic search, and direct type in
SELECT
	YEAR(website_sessions.created_at),
    QUARTER(website_sessions.created_at),
--     COUNT(
--     CASE 
--         WHEN utm_source = 'gsearch' AND utm_campaign = 'nonbrand' THEN 'gsearch_nonbrand'
--         WHEN utm_source = 'bsearch' AND utm_campaign = 'nonbrand' THEN 'bsearch_nonbrand'
--         WHEN utm_campaign = 'brand' THEN 'brand_search_overall'
--         WHEN utm_source IS NULL AND http_referer IN ('https://www.gsearch.com','https://www.bsearch.com') THEN 'organic_search'
--         WHEN utm_source IS NULL AND http_referer IS NULL THEN 'direct_type_in'
-- 	END) ,
	COUNT(CASE WHEN utm_source = 'gsearch' AND utm_campaign = 'nonbrand' THEN 'gsearch_nonbrand' END) AS gsearch_nonbrand,
	COUNT(CASE WHEN utm_source = 'bsearch' AND utm_campaign = 'nonbrand' THEN 'bsearch_nonbrand' END) AS bsearch_nonbrand,
	COUNT(CASE WHEN utm_campaign = 'brand' THEN 'brand_search_overall' END) AS brand_search_overall,
	COUNT(CASE WHEN utm_source IS NULL AND http_referer IN ('https://www.gsearch.com','https://www.bsearch.com') THEN 'organic_search' END) AS organic_search,
	COUNT(CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN 'direct_type_in' END) AS direct_type_in
FROM website_sessions
	INNER JOIN orders
		ON orders.website_session_id = website_sessions.website_session_id

GROUP BY 1, 2
ORDER BY 1, 2;


SELECT
	YEAR(website_sessions.created_at),
    QUARTER(website_sessions.created_at),
	COUNT(CASE WHEN utm_source = 'gsearch' AND utm_campaign = 'nonbrand' THEN 'gsearch_nonbrand' END)/COUNT(DISTINCT website_sessions.website_session_id) AS gsearch_nonbrand_rt,
	COUNT(CASE WHEN utm_source = 'bsearch' AND utm_campaign = 'nonbrand' THEN 'bsearch_nonbrand' END)/COUNT(DISTINCT website_sessions.website_session_id) AS bsearch_nonbrand_rt,
	COUNT(CASE WHEN utm_campaign = 'brand' THEN 'brand_search_overall' END)/COUNT(DISTINCT website_sessions.website_session_id) AS brand_search_overall_rt,
	COUNT(CASE WHEN utm_source IS NULL AND http_referer IN ('https://www.gsearch.com','https://www.bsearch.com') THEN 'organic_search' END)/COUNT(DISTINCT website_sessions.website_session_id) AS organic_search_rt,
	COUNT(CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN 'direct_type_in' END)/COUNT(DISTINCT website_sessions.website_session_id) AS direct_type_in_rt
FROM website_sessions
	LEFT JOIN orders
		ON orders.website_session_id = website_sessions.website_session_id

GROUP BY 1, 2
ORDER BY 1, 2;


