use mavenfuzzyfactory;

SELECT
	COUNT(order_id) AS orders,
    SUM(price_usd) AS revenue,
    SUM(price_usd - cogs_usd) AS margin,
    AVG(price_usd) AS average_order_value
FROM orders
WHERE order_id BETWEEN 100 AND 200
