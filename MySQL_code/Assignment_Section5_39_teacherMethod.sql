-- ASSIGNMENT_CALCULATING_BOUNCE_RATES

-- STEP 1: finding the first website_pageview_id for relevant sessions
-- STEP 2: identifying the landing page of each session
-- STEP 3: counting pageviews for each session, to identify "bounces"
-- STEP 4: summarizing by counting total sessiions and bounced sessions

USE mavenfuzzyfactory;

CREATE TEMPORARY TABLE first_pageviews
SELECT
	website_session_id,
    MIN(website_pageview_id) AS min_pageview_id
FROM website_pageviews
WHERE created_at < '2012-06-14'
GROUP BY website_session_id;

SELECT
	*
FROM first_pageviews;

-- next, we'll bring in the landing page, like last time, but restrict to ome only
-- this is redundant in this case, since all is to the homepage

CREATE TEMPORARY TABLE sessions_w_home_landing_page
SELECT
	first_pageviews.website_session_id,
    website_pageviews.pageview_url AS landing_page

FROM first_pageviews
	LEFT JOIN website_pageviews
		ON website_pageviews.website_pageview_id = first_pageviews.min_pageview_id
WHERE website_pageviews.pageview_url = '/home';

SELECT
	*
FROM sessions_w_home_landing_page;

-- then a table to have count of pageviews per session
-- then limit it to just bounced_sessions

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

-- Compare  
CREATE TEMPORARY TABLE bounced_sessions_compare
SELECT 
	sessions_w_home_landing_page.website_session_id,
    sessions_w_home_landing_page.landing_page,
    COUNT(website_pageviews.website_pageview_id) AS count_of_pages_viewed
FROM sessions_w_home_landing_page
LEFT JOIN website_pageviews
	ON website_pageviews.website_session_id = sessions_w_home_landing_page.website_session_id
    
GROUP BY 
	sessions_w_home_landing_page.website_session_id
	-- sessions_w_home_landing_page.landing_page
HAVING
	COUNT(website_pageviews.website_pageview_id) = 1
    ;
    
SELECT 
    *
FROM
    bounced_sessions_compare;

-- final output for Assignment_Calculating_Bounce_Rates

SELECT
	sessions_w_home_landing_page.landing_page,
    COUNT(DISTINCT sessions_w_home_landing_page.website_session_id) AS sessions,
    COUNT(DISTINCT bounced_sessions.website_session_id) AS bounced_sessions,
    COUNT(DISTINCT bounced_sessions.website_session_id)/COUNT(DISTINCT sessions_w_home_landing_page.website_session_id) AS bounce_rate
FROM sessions_w_home_landing_page
	LEFT JOIN bounced_sessions
    ON sessions_w_home_landing_page.website_session_id = bounced_sessions.website_session_id
GROUP BY sessions_w_home_landing_page.landing_page



