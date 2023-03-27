-- yr mo p1_orders p1_refund_rt p2_orders p2_refund_rt p3_orders p3_refund_rt p4_orders p4_refund_rt

use mavenfuzzyfactory;

CREATE TEMPORARY TABLE Get_product_id
SELECT
	order_item_refunds.created_at,
	order_item_refunds.order_id,
    order_item_refunds.order_item_id,
    order_items.product_id

FROM order_item_refunds
	LEFT JOIN order_items
		ON order_item_refunds.order_id = order_items.order_id
;

SELECT * FROM Get_product_id;

CREATE TEMPORARY TABLE Get_order_refund
SELECT
	YEAR(order_items.created_at) yr,
    MONTH(order_items.created_at) mo,
    COUNT(DISTINCT CASE WHEN order_items.product_id = 1 THEN order_items.order_id ELSE NULL END) AS p1_orders,
    COUNT(DISTINCT CASE WHEN Get_product_id.product_id = 1 THEN Get_product_id.order_item_id ELSE NULL END) AS p1_refund,
    COUNT(DISTINCT CASE WHEN order_items.product_id = 2 THEN order_items.order_id ELSE NULL END) AS p2_orders,
    COUNT(DISTINCT CASE WHEN Get_product_id.product_id = 2 THEN Get_product_id.order_item_id ELSE NULL END) AS p2_refund,
    COUNT(DISTINCT CASE WHEN order_items.product_id = 3 THEN order_items.order_id ELSE NULL END) AS p3_orders,
    COUNT(DISTINCT CASE WHEN Get_product_id.product_id = 3 THEN Get_product_id.order_item_id ELSE NULL END) AS p3_refund,
    COUNT(DISTINCT CASE WHEN order_items.product_id = 4 THEN order_items.order_id ELSE NULL END) AS p4_orders,
    COUNT(DISTINCT CASE WHEN Get_product_id.product_id = 4 THEN Get_product_id.order_item_id ELSE NULL END) AS p4_refund
FROM order_items
	LEFT JOIN Get_product_id
		ON Get_product_id.order_id = order_items.order_id  -- Needs to be order_item_id instead of order_id. 
GROUP BY 1, 2;

SELECT * FROM Get_order_refund;

SELECT
	yr,
    mo,
    p1_refund/p1_orders,
    p2_refund/p2_orders,
    p3_refund/p3_orders,
    p4_refund/p4_orders
FROM Get_order_refund;
	

-- # product_id	created_at	product_name
-- 1	2012-03-19 09:00:00	The Original Mr. Fuzzy
-- 2	2013-01-06 13:00:00	The Forever Love Bear
-- 3	2013-12-12 09:00:00	The Birthday Sugar Panda
-- 4	2014-02-05 10:00:00	The Hudson River Mini bear

