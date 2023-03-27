USE mavenfuzzyfactory;

CREATE TEMPORARY TABLE first_pageview_id
SELECT
	website_session_id AS sessions,
    MIN(website_pageview_id) AS first_pv
FROM website_pageviews
WHERE created_at < '2012-06-14'
GROUP BY website_session_id;

SELECT
	*
FROM first_pageview_id;

CREATE TEMPORARY TABLE Get_landing_page
SELECT
	first_pageview_id.sessions,
    website_pageviews.pageview_url AS landing_page

FROM first_pageview_id
	LEFT JOIN website_pageviews
		ON website_pageviews.website_pageview_id = first_pageview_id.first_pv;
        
SELECT
	*
FROM Get_landing_page;

CREATE TEMPORARY TABLE bounced_page_only

SELECT 
	Get_landing_page.sessions,
    Get_landing_page.landing_page,
    COUNT(website_pageviews.website_pageview_id) AS count_of_pages_viewed
FROM Get_landing_page
LEFT JOIN website_pageviews
	ON website_pageviews.website_session_id = Get_landing_page.sessions
    
GROUP BY 
	Get_landing_page.sessions,
	Get_landing_page.landing_page
HAVING
	COUNT(website_pageviews.website_pageview_id) = 1
    AND Get_landing_page.landing_page = '/home'
    ;
    

SELECT 
    *
FROM
    bounced_page_only;


SELECT
	Get_landing_page.landing_page,
    COUNT(DISTINCT Get_landing_page.sessions) AS sessions,
    COUNT(DISTINCT bounced_page_only.sessions) AS bounced_sessions,
    COUNT(DISTINCT bounced_page_only.sessions)/COUNT(DISTINCT Get_landing_page.sessions) AS bounce_rate
FROM Get_landing_page
	LEFT JOIN bounced_page_only
    ON Get_landing_page.sessions = bounced_page_only.sessions
GROUP BY Get_landing_page.landing_page



