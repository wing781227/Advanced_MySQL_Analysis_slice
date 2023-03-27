use mavenfuzzyfactory;

-- Final result is same as correct one, but if the landing page is more than home and lander1, it will be wrong. 

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
-- 	AND website_pageviews.pageview_url IN ('/home', '/lander-1')
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
	(pageview_url),
	COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) AS to_products,
    COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS to_mrfuzzy,
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS to_cart,
    COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS to_shipping,
    COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS to_billing,
    COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END) AS to_thankyou
FROM conversion_funnel_step2
GROUP BY 1;