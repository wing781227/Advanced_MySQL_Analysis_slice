use mavenfuzzyfactory;

CREATE TEMPORARY TABLE bill_page_view
SELECT
	website_pageviews.website_session_id,
    website_pageviews.pageview_url,
    orders.order_id,
    orders.price_usd
FROM website_pageviews
	LEFT JOIN orders
		ON orders.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.pageview_url IN ('/billing','/billing-2')
	AND website_pageviews.created_at < '2012-11-10'
    AND website_pageviews.created_at > '2012-09-10';
    
SELECT * FROM bill_page_view;
	
SELECT
	pageview_url,
    SUM(bill_page_view.price_usd)/COUNT(DISTINCT bill_page_view.website_session_id)
FROM bill_page_view
GROUP BY 1;

SELECT
	COUNT(website_session_id)
FROM website_pageviews
WHERE pageview_url IN ('/billing','/billing-2')
	AND created_at BETWEEN '2012-10-27' AND '2012-11-27'

    
