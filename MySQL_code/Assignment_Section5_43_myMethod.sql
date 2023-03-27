use mavenfuzzyfactory;

CREATE TEMPORARY TABLE session_table

SELECT
	DATE(MIN(website_sessions.created_at)),
	COUNT(CASE WHEN website_pageviews.pageview_url = '/home' THEN website_pageviews.website_pageview_id ELSE NULL END) AS home_sessions,
    COUNT(CASE WHEN website_pageviews.pageview_url = '/lander-1' THEN website_pageviews.website_pageview_id ELSE NULL END) AS lander1_sessions
FROM website_pageviews
	LEFT JOIN website_sessions
		ON website_pageviews.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at > '2012-06-01' 
	AND website_sessions.created_at < '2012-08-31'
    AND website_sessions.utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'
GROUP BY 
	YEAR(website_sessions.created_at),
    WEEK(website_sessions.created_at);
    
SELECT
*
FROM session_table;
    
CREATE TEMPORARY TABLE first_pageviews

SELECT
	
	website_pageviews.website_session_id,
    website_pageviews.created_at,
    MIN(website_pageview_id) AS min_pageview_id
FROM website_pageviews
	INNER JOIN website_sessions
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.created_at > '2012-06-01' 
	AND website_pageviews.created_at < '2012-08-31'
	AND utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'
GROUP BY website_session_id;

SELECT
	*
FROM first_pageviews;

CREATE TEMPORARY TABLE bounced_sessions
SELECT 
	website_pageviews.website_session_id,
    COUNT(website_pageviews.website_pageview_id) AS count_of_pages_viewed
FROM website_pageviews

GROUP BY 
	website_pageviews.website_session_id
HAVING
	COUNT(website_pageviews.website_pageview_id) = 1
    ;
    
SELECT 
    *
FROM
    bounced_sessions;
    
SELECT
	DATE(MIN(website_sessions.created_at)),
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT bounced_sessions.website_session_id) AS bounced_sessions,
    COUNT(DISTINCT bounced_sessions.website_session_id)/COUNT(DISTINCT website_sessions.website_session_id) AS bounce_rate
FROM website_sessions
	LEFT JOIN bounced_sessions
    ON website_sessions.website_session_id = bounced_sessions.website_session_id
WHERE website_sessions.created_at > '2012-06-01' 
	AND website_sessions.created_at < '2012-08-31'
	AND website_sessions.utm_source = 'gsearch'
    AND website_sessions.utm_campaign = 'nonbrand'

GROUP BY 
	YEAR(website_sessions.created_at),
    WEEK(website_sessions.created_at); -- After I switch my method's website_pageviews table to website_sessions, then I got the same result.