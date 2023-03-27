use mavenfuzzyfactory;

SELECT
	YEAR(orders.created_at),
    MONTH(orders.created_at),
    (order_items.product_id),
    COUNT(DISTINCT orders.order_id) AS number_of_sales,
    SUM(orders.price_usd) AS total_revenue,
    SUM(orders.price_usd - orders.cogs_usd) AS total_margin
FROM orders
	LEFT JOIN order_items
		ON order_items.order_id = orders.order_id
GROUP BY
	YEAR(created_at),
    MONTH(created_at),
    order_items.product_id;
    
-- =======================================================

CREATE TEMPORARY TABLE products_pageviews_Q6
SELECT
	website_pageviews.created_at,
	website_session_id,
    website_pageview_id
FROM website_pageviews
WHERE pageview_url = '/products'
;

SELECT * FROM products_pageviews_Q6;

CREATE TEMPORARY TABLE sessions_w_next_pageview_id_Q6
SELECT
	products_pageviews_Q6.created_at,
	products_pageviews_Q6.website_session_id,
    MIN(website_pageviews.website_pageview_id) AS min_next_pageview_id
FROM products_pageviews_Q6
	LEFT JOIN website_pageviews
		ON website_pageviews.website_session_id = products_pageviews_Q6.website_session_id
        AND website_pageviews.website_pageview_id > products_pageviews_Q6.website_pageview_id -- Important part that I don't get
GROUP BY 2;

SELECT * FROM sessions_w_next_pageview_id_Q6;

SELECT
    YEAR(sessions_w_next_pageview_id_Q6.created_at),
    MONTH(sessions_w_next_pageview_id_Q6.created_at),
    COUNT(DISTINCT sessions_w_next_pageview_id_Q6.website_session_id),
	COUNT(DISTINCT CASE WHEN min_next_pageview_id IS NOT NULL THEN sessions_w_next_pageview_id_Q6.website_session_id ELSE NULL END)/COUNT(DISTINCT sessions_w_next_pageview_id_Q6.website_session_id) AS click_through_rt,
    COUNT(DISTINCT orders.website_session_id)/COUNT(DISTINCT sessions_w_next_pageview_id_Q6.website_session_id)
FROM sessions_w_next_pageview_id_Q6
	LEFT JOIN orders
		ON orders.website_session_id = sessions_w_next_pageview_id_Q6.website_session_id
GROUP BY 1, 2;