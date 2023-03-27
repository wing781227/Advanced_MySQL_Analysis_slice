use mavenfuzzyfactory;

CREATE TEMPORARY TABLE first_pageviews
SELECT
	website_pageviews.website_session_id,
    MIN(website_pageview_id) AS min_pageview_id
FROM website_pageviews
	INNER JOIN website_sessions
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.created_at > '2012-06-19 01:35:54' 
	AND website_pageviews.created_at < '2012-07-28'
	AND utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'
	GROUP BY website_session_id;

SELECT
	*
FROM first_pageviews;

CREATE TEMPORARY TABLE sessions_w_home_landing_page
SELECT
	first_pageviews.website_session_id,
    website_pageviews.pageview_url AS landing_page

FROM first_pageviews
	LEFT JOIN website_pageviews
		ON website_pageviews.website_pageview_id = first_pageviews.min_pageview_id
WHERE 
	website_pageviews.pageview_url = '/home' OR
	 website_pageviews.pageview_url = '/lander-1';

SELECT
	*
FROM sessions_w_home_landing_page;

CREATE TEMPORARY TABLE bounced_sessions
SELECT 
	sessions_w_home_landing_page.website_session_id,
    sessions_w_home_landing_page.landing_page,
    COUNT(website_pageviews.website_pageview_id) AS count_of_pages_viewed
FROM sessions_w_home_landing_page
LEFT JOIN website_pageviews
	ON website_pageviews.website_session_id = sessions_w_home_landing_page.website_session_id
    
GROUP BY 
	sessions_w_home_landing_page.website_session_id,
	sessions_w_home_landing_page.landing_page
HAVING
	COUNT(website_pageviews.website_pageview_id) = 1
    ;
    
SELECT 
    *
FROM
    bounced_sessions;
    
SELECT
	sessions_w_home_landing_page.landing_page,
    COUNT(DISTINCT sessions_w_home_landing_page.website_session_id) AS sessions,
    COUNT(DISTINCT bounced_sessions.website_session_id) AS bounced_sessions,
    COUNT(DISTINCT bounced_sessions.website_session_id)/COUNT(DISTINCT sessions_w_home_landing_page.website_session_id) AS bounce_rate
FROM sessions_w_home_landing_page
	LEFT JOIN bounced_sessions
    ON sessions_w_home_landing_page.website_session_id = bounced_sessions.website_session_id
GROUP BY sessions_w_home_landing_page.landing_page