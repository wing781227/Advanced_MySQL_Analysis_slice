use mavenfuzzyfactory;

SELECT
	*
FROM orders
WHERE order_id BETWEEN 10000 AND 11000 -- arbitraty
;

SELECT
	*
FROM order_items
WHERE order_id BETWEEN 10000 AND 11000 -- arbitraty
;

SELECT
	orders.order_id,
    orders.primary_product_id,
    order_items.product_id
FROM orders
	LEFT JOIN order_items
		ON order_items.order_id = orders.order_id
			AND order_items.is_primary_item = 0 -- cross sell only
WHERE orders.order_id BETWEEN 10000 AND 11000 -- arbitraty
;

SELECT
    orders.primary_product_id,
    order_items.product_id AS cross_sell_product,
    COUNT(DISTINCT orders.order_id) AS orders
FROM orders
	LEFT JOIN order_items
		ON order_items.order_id = orders.order_id
			AND order_items.is_primary_item = 0 -- cross sell only
WHERE orders.order_id BETWEEN 10000 AND 11000 -- arbitraty
GROUP BY 1,2
;





SELECT
	orders.primary_product_id,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT CASE WHEN order_items.product_id = 1 THEN orders.order_id ELSE NULL END) AS x_sell_prod1,
    COUNT(DISTINCT CASE WHEN order_items.product_id = 2 THEN orders.order_id ELSE NULL END) AS x_sell_prod2,
    COUNT(DISTINCT CASE WHEN order_items.product_id = 3 THEN orders.order_id ELSE NULL END) AS x_sell_prod3,
    
	COUNT(DISTINCT CASE WHEN order_items.product_id = 1 THEN orders.order_id ELSE NULL END)/COUNT(DISTINCT orders.order_id)  AS x_sell_prod1_rt,
    COUNT(DISTINCT CASE WHEN order_items.product_id = 2 THEN orders.order_id ELSE NULL END)/COUNT(DISTINCT orders.order_id)  AS x_sell_prod2_rt,
    COUNT(DISTINCT CASE WHEN order_items.product_id = 3 THEN orders.order_id ELSE NULL END)/COUNT(DISTINCT orders.order_id)  AS x_sell_prod3_rt
    
FROM orders
	LEFT JOIN order_items
		ON order_items.order_id = orders.order_id
        AND order_items.is_primary_item = 0 -- cross sell only
WHERE orders.order_id BETWEEN 10000 ANd 11000 -- arbitrary

GROUP BY 1; 