-- channel_group new_sessions repeat_sessions
-- organic_search
-- paid_brand
-- direct_type_in
-- paid_nonbrand
-- paid_social

-- 'socialbook'


use mavenfuzzyfactory;

CREATE TEMPORARY TABLE channel_group_w_repeat
SELECT
	website_session_id,
    created_at,
    is_repeat_session,
    CASE 
		WHEN utm_source IS NULL AND http_referer IN ('https://www.gsearch.com','https://www.bsearch.com') THEN 'organic_search'
        WHEN utm_campaign = 'nonbrand' THEN 'paid_nonbrand'
        WHEN utm_campaign = 'brand' THEN 'paid_brand'
        WHEN utm_source IS NULL AND http_referer IS NULL THEN 'direct_type_in'
        WHEN utm_source = 'socialbook' THEN 'socialbook'
	END AS channel_group
FROM website_sessions
WHERE created_at BETWEEN '2014-01-01' AND '2014-11-05'
;

SELECT
	*
FROM channel_group_w_repeat;

SELECT
	channel_group,
    COUNT(DISTINCT CASE WHEN is_repeat_session = 0 THEN website_session_id ELSE NULL END) AS new_sessions,
    COUNT(DISTINCT CASE WHEN is_repeat_session = 1 THEN website_session_id ELSE NULL END) AS repeat_sessions
FROM channel_group_w_repeat
GROUP BY 1;


