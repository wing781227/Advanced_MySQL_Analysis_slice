-- yr mo p1_orders p1_refund_rt p2_orders p2_refund_rt p3_orders p3_refund_rt p4_orders p4_refund_rt

use mavenfuzzyfactory;

-- CREATE TEMPORARY TABLE Get_product_id
-- SELECT
-- 	order_item_refunds.created_at,
-- 	order_item_refunds.order_id,
--     order_item_refunds.order_item_id,
--     order_items.product_id

-- FROM order_item_refunds
-- 	LEFT JOIN order_items
-- 		ON order_item_refunds.order_id = order_items.order_id
-- ;

-- SELECT * FROM Get_product_id;

CREATE TEMPORARY TABLE Get_order_refund
SELECT
	YEAR(order_items.created_at) yr,
    MONTH(order_items.created_at) mo,
    COUNT(DISTINCT CASE WHEN product_id = 1 THEN order_items.order_item_id ELSE NULL END) AS p1_orders,
    COUNT(DISTINCT CASE WHEN product_id = 1 THEN order_item_refunds.order_item_id ELSE NULL END) AS p1_refund,
    COUNT(DISTINCT CASE WHEN product_id = 2 THEN order_items.order_item_id ELSE NULL END) AS p2_orders,
    COUNT(DISTINCT CASE WHEN product_id = 2 THEN order_item_refunds.order_item_id ELSE NULL END) AS p2_refund,
    COUNT(DISTINCT CASE WHEN product_id = 3 THEN order_items.order_item_id ELSE NULL END) AS p3_orders,
    COUNT(DISTINCT CASE WHEN product_id = 3 THEN order_item_refunds.order_item_id ELSE NULL END) AS p3_refund,
    COUNT(DISTINCT CASE WHEN product_id = 4 THEN order_items.order_item_id ELSE NULL END) AS p4_orders,
    COUNT(DISTINCT CASE WHEN product_id = 4 THEN order_item_refunds.order_item_id ELSE NULL END) AS p4_refund
FROM order_items
	LEFT JOIN order_item_refunds
		ON order_item_refunds.order_item_id = order_items.order_item_id
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