use mavenfuzzyfactory;

SELECT
	pageview_url,
	MIN(created_at),
	website_pageview_id,
    website_session_id
FROM website_pageviews
WHERE pageview_url = '/billing-2';

SELECT
	website_pageviews.pageview_url,
	COUNT(DISTINCT website_pageviews.website_session_id) AS sessions,
	COUNT(DISTINCT orders.website_session_id) AS orders,
    COUNT(DISTINCT orders.website_session_id)/COUNT(DISTINCT website_pageviews.website_session_id) AS billing_to_order_rt
	
FROM website_pageviews
	LEFT JOIN orders
		ON website_pageviews.website_session_id = orders.website_session_id
WHERE pageview_url IN ('/billing', '/billing-2')
    AND website_pageviews.created_at BETWEEN '2012-09-10' AND '2012-11-10' 
-- WHERE pageview_url = '/billing-2'				-- This WHERE is not working.
-- 	OR pageview_url = '/billing'
--     AND website_pageviews.created_at BETWEEN '2012-09-10' AND '2012-11-10' 
    
GROUP BY pageview_url;
