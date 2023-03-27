use mavenfuzzyfactory;

-- CREATE TEMPORARY TABLE Q5

SELECT
	YEAR(website_sessions.created_at),
	MONTH(website_sessions.created_at),
    COUNT(DISTINCT website_sessions.website_session_id),
    COUNT(DISTINCT orders.order_id),
	COUNT(DISTINCT orders.order_id) /COUNT(DISTINCT website_sessions.website_session_id)
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id

WHERE website_sessions.created_at < '2012-11-27'
GROUP BY 1, 2;

-- SELECT * FROM Q5;

-- =================================
-- Practice Q6

SELECT 
	MIN(website_pageviews.website_pageview_id),
	website_pageviews.pageview_url
-- *
FROM website_pageviews
WHERE website_pageviews.pageview_url = '/lander-1';

CREATE TEMPORARY TABLE min_page
SELECT
	website_pageviews.website_pageview_id,
    website_pageviews.pageview_url,
	website_sessions.website_session_id
FROM website_pageviews
	LEFT JOIN website_sessions
		ON website_sessions.website_session_id = website_pageviews.website_session_id

WHERE website_sessions.created_at < '2012-07-28'
	AND website_pageviews.website_pageview_id >= 23504
    AND website_pageviews.pageview_url IN ('/home', '/lander-1')
    AND website_sessions.utm_source = 'gsearch'
    AND website_sessions.utm_campaign = 'nonbrand';
    
SELECT * FROM min_page;

-- wrong
-- CREATE TEMPORARY TABLE count_session
-- SELECT
-- 	website_pageviews.pageview_url,
--     COUNT(DISTINCT website_sessions.website_session_id)
-- FROM website_pageviews
-- 	LEFT JOIN website_sessions
-- 		ON website_sessions.website_session_id = website_pageviews.website_session_id

-- WHERE website_sessions.created_at < '2012-07-28'
-- 	AND website_pageviews.website_pageview_id > 23504
--     AND website_pageviews.pageview_url IN ('/home', '/lander-1')
-- GROUP BY 1;

-- SELECT * FROM count_session;


SELECT
	min_page.pageview_url,
    COUNT(DISTINCT min_page.website_session_id),
    COUNT(DISTINCT orders.order_id),
	COUNT(DISTINCT orders.order_id) /COUNT(DISTINCT min_page.website_session_id)
FROM min_page
	LEFT JOIN orders
		ON min_page.website_session_id = orders.website_session_id

GROUP BY 1;

SELECT
	MAX(website_sessions.website_session_id)
FROM website_pageviews
	LEFT JOIN website_sessions
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.pageview_url = '/home'
	AND website_pageviews.created_at < '2012-11-27'
	AND website_pageviews.website_pageview_id >= 23504
    AND website_sessions.utm_source = 'gsearch'
    AND website_sessions.utm_campaign = 'nonbrand';
    
SELECT
	COUNT(DISTINCT website_sessions.website_session_id)
FROM website_sessions
WHERE website_sessions.created_at < '2012-11-27'
	AND website_sessions.website_session_id > 17145
    AND website_sessions.utm_source = 'gsearch'
    AND website_sessions.utm_campaign = 'nonbrand';
-- =================================

CREATE TEMPORARY TABLE conversion_funnel_step1

SELECT
	website_sessions.website_session_id,
    website_pageviews.pageview_url,
    website_pageviews.created_at AS pageview_created_at
    , CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page
    , CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page
    , CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page
    , CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page
    , CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_page
    , CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_sessions.website_session_id =  website_pageviews.website_session_id
WHERE website_sessions.created_at BETWEEN '2012-06-19' AND '2012-07-28' -- random timeframe for demo
	AND website_pageviews.pageview_url IN ('/home', '/lander-1')
	AND utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'
ORDER BY
	website_sessions.website_session_id,
    website_pageviews.created_at;

SELECT * FROM conversion_funnel_step1;


CREATE TEMPORARY TABLE conversion_funnel_step2
SELECT
	website_session_id,
    pageview_url,
    MAX(products_page) AS product_made_it,
    MAX(mrfuzzy_page) AS mrfuzzy_made_it,
    MAX(cart_page) AS cart_made_it
    ,MAX(shipping_page) AS shipping_made_it,
    MAX(billing_page) AS billing_made_it,
    MAX(thankyou_page) AS thankyou_made_it
FROM conversion_funnel_step1
GROUP BY 1
;

SELECT * FROM conversion_funnel_step2;

SELECT
-- 	(pageview_url),
	COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) AS to_products,
    COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS to_mrfuzzy,
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS to_cart,
    COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS to_shipping,
    COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS to_billing,
    COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END) AS to_thankyou
FROM conversion_funnel_step2
-- GROUP BY 1;


