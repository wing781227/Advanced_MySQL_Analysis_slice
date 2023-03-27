USE mavenfuzzyfactory;

-- SELECT
-- 	website_pageviews.pageview_url,
--     COUNT(DISTINCT website_pageviews.website_session_id) AS sessions
-- FROM website_pageviews
-- 	LEFT JOIN website_sessions ON website_pageviews.website_session_id = website_sessions.website_session_id

-- WHERE	website_pageviews.created_at < '2012-06-09'
-- GROUP BY website_pageviews.pageview_url
-- ORDER BY sessions DESC;

-- Above is my version, the final result is correct but actually is not really correct.

SELECT
	pageview_url,
    COUNT(DISTINCT website_pageview_id) AS pvs
    
FROM website_pageviews    
WHERE	created_at < '2012-06-09'
GROUP BY pageview_url
ORDER BY pvs DESC;