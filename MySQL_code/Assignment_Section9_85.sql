-- time_period conv_rate aov products_per_order revenue_per_session
-- A. Pre_Birthday_Bear
-- B. Post_Birthday_Bear
-- 2013-11-12  2013-12-13  2014-01-13

-- aov = SUM(price_usd)/SUM(order_id)
-- products_per_order = SUM(items_purchased)/SUM(order_id)
-- revenue_per_session = SUM(price_usd)/COUNT(DISTINCT website_session_id)

use mavenfuzzyfactory;
	
SELECT
	CASE 
		WHEN website_sessions.created_at < '2013-12-13' THEN 'A. Pre_Cross_Sell'
        WHEN website_sessions.created_at >= '2013-12-13' THEN 'B. Post_Cross_Sell'
        ELSE 'uh oh...check logic'
	END AS time_period,
-- 	COUNT( DISTINCT website_sessions.website_session_id),
--     COUNT( DISTINCT orders.order_id),
    COUNT( DISTINCT orders.order_id)/COUNT( DISTINCT website_sessions.website_session_id) AS conv_rate,
    SUM(orders.price_usd)/COUNT( DISTINCT orders.order_id) AS aov,
    SUM(orders.items_purchased)/COUNT( DISTINCT orders.order_id) AS products_per_order,
    SUM(orders.price_usd)/COUNT( DISTINCT website_sessions.website_session_id)  AS revenue_per_session
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at BETWEEN '2013-11-13' AND '2014-01-13'
        
GROUP BY time_period;
