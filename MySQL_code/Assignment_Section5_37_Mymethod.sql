USE mavenfuzzyfactory;

CREATE TEMPORARY TABLE first_pageview_n
SELECT
	DISTINCT website_session_id	-- This step I think it should just show the distinct website_session_id
								-- But this distinct means when the website_session_id combine with pageview_url should be unic.
    -- pageview_url
FROM website_pageviews
WHERE created_at <'2012-6-12';

SELECT
	*
FROM first_pageview_n

-- SELECT
-- 	DISTINCT pageview_url,
--     COUNT(website_session_id)
-- FROM first_pageview
-- GROUP BY pageview_url






