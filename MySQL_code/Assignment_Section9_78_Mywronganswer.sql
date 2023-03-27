-- time_period sessions w_next_pg pct_w_next_pg to_mrfuzzy pct_to_mrfuzzy to_lovebear pct_to_lovebear
-- A. Pre_Product_2
-- B. Post_Product_2
use mavenfuzzyfactory;

CREATE TEMPORARY TABLE next_page
SELECT
	website_session_id,
    COUNT(website_session_id) AS not_1
FROM website_pageviews
WHERE created_at BETWEEN '2012-09-06' AND '2013-04-06'
GROUP BY 1;

SELECT * FROM next_page;

SELECT
	(CASE WHEN website_pageviews.created_at BETWEEN '2012-09-06' AND '2013-01-06' THEN 'A. Pre_Product_2' 
				WHEN website_pageviews.created_at BETWEEN '2013-01-06' AND '2013-04-06' THEN 'B. Post_Product_2'
                ELSE NULL END) AS time_period,
	COUNT(DISTINCT website_pageviews.website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN not_1 != 1 THEN next_page.website_session_id ELSE NULL END) AS w_next_pg,
    COUNT(DISTINCT CASE WHEN website_pageviews.pageview_url = '/the-forever-love-bear' THEN website_pageviews.website_session_id ELSE NuLL END) AS to_mrfuzzy,
    COUNT(DISTINCT CASE WHEN website_pageviews.pageview_url = '/the-original-mr-fuzzy' THEN website_pageviews.website_session_id ELSE NuLL END) AS to_lovebear
FROM website_pageviews
	LEFT JOIN next_page
		ON website_pageviews.website_session_id = next_page.website_session_id
    
WHERE website_pageviews.created_at BETWEEN '2012-09-06' AND '2013-04-06'
GROUP BY 1;

