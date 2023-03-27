-- is_repeat_session sessions conv_rate rev_per_session
-- 0
-- 1

use mavenfuzzyfactory;

SELECT
	website_sessions.is_repeat_session,
    COUNT(DISTINCT website_sessions.website_session_id),
    COUNT(DISTINCT orders.order_id) /COUNT(DISTINCT website_sessions.website_session_id) AS conv_rate,
    SUM(orders.price_usd) /COUNT(DISTINCT website_sessions.website_session_id) AS rev_per_session
FROM website_sessions
	LEFT JOIN orders
		ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at BETWEEN '2014-01-01' AND '2014-11-08'
GROUP BY 1;