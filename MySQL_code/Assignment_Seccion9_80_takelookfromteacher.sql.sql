-- product_seen sessions to_cart to_shipping to_billing to_thankyou		product_page_click_rt cart_click_rt shipping_click_rt billing_click_rt
-- lovebear
-- mrfuzzy
use mavenfuzzyfactory;

CREATE TEMPORARY TABLE sessions_seeing_product_pages
SELECT
	website_session_id,
    website_pageview_id,
    pageview_url AS product_page_seen
FROM website_pageviews

WHERE created_at < '2013-04-10' -- date of assignment
	AND created_at > '2013-01-06' -- product 2 launch
    AND pageview_url IN ('/the-original-mr-fuzzy', '/the-forever-love-bear');
    
SELECT * FROM sessions_seeing_product_pages;

SELECT DISTINCT
	website_pageviews.pageview_url
FROM sessions_seeing_product_pages
	LEFT JOIN website_pageviews
		ON website_pageviews.website_session_id = sessions_seeing_product_pages.website_session_id
        AND website_pageviews.website_pageview_id > sessions_seeing_product_pages.website_pageview_id;
	

CREATE TEMPORARY TABLE products_pageviews
SELECT
	sessions_seeing_product_pages.website_session_id,
    sessions_seeing_product_pages.website_pageview_id,
    sessions_seeing_product_pages.product_page_seen AS product_page_seen,		-- I miss this part too. 
    website_pageviews.created_at,
    website_pageviews.pageview_url
-- 	, CASE WHEN website_pageviews.pageview_url = '/the-forever-love-bear' THEN 1 ELSE 0 END AS love_page
--     , CASE WHEN website_pageviews.pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page
	, CASE WHEN website_pageviews.pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page
    , CASE WHEN website_pageviews.pageview_url = '/shipping' THEN 1 ELSE 0 END AS ship_page
    , CASE WHEN website_pageviews.pageview_url = '/billing-2' THEN 1 ELSE 0 END AS bill_page  -- Should be /billing-2 instead of /billing, we can see it from a table above. Ideal from teacher.
    , CASE WHEN website_pageviews.pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
FROM sessions_seeing_product_pages
	LEFT JOIN website_pageviews
		ON website_pageviews.website_session_id = sessions_seeing_product_pages.website_session_id
		AND website_pageviews.website_pageview_id > sessions_seeing_product_pages.website_pageview_id
-- WHERE website_pageviews.pageview_url IN ('/the-forever-love-bear', '/the-original-mr-fuzzy', '/cart', '/shipping', '/billing-2', '/thank-you-for-your-order')
-- 	AND website_pageviews.created_at < '2014-04-10'
--     AND website_pageviews.created_at > '2014-01-06'
;

SELECT * FROM products_pageviews;

CREATE TEMPORARY TABLE session_level_made_it_flags_demo
SELECT
	website_session_id,
	CASE WHEN product_page_seen = '/the-forever-love-bear' THEN 'lovebear'
		WHEN product_page_seen = '/the-original-mr-fuzzy' THEN 'mrfuzzy' ELSE NULL END AS product_seen,
-- 	MAX(love_page) AS love_made_it,
--     MAX(mrfuzzy_page) AS mrfuzzy_made_it,
	MAX(cart_page) AS cart_made_it,
    MAX(ship_page) AS ship_made_it,
    MAX(bill_page) AS bill_made_it,
    MAX(thankyou_page) AS thankyou_made_it
FROM products_pageviews

GROUP BY website_session_id;

SELECT * FROM session_level_made_it_flags_demo;

SELECT
	product_seen,
	COUNT(DISTINCT website_session_id) AS sessions,
    -- COUNT(DISTINCT CASE WHEN love_made_it = 1 THEN website_session_id ELSE NULL END) AS to_love,
    -- COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS to_mrfuzzy,
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS to_cart,
    COUNT(DISTINCT CASE WHEN ship_made_it = 1 THEN website_session_id ELSE NULL END) AS to_ship,
    COUNT(DISTINCT CASE WHEN bill_made_it = 1 THEN website_session_id ELSE NULL END) AS to_bill,
    COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END) AS to_thankyou
FROM session_level_made_it_flags_demo
GROUP BY product_seen;