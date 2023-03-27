USE mavenfuzzyfactory;

SELECT
	utm_source,
    utm_campaign,
    http_referer,
    COUNT(DISTINCT website_session_id) AS sessions
FROM
	website_sessions
WHERE created_at < '2012-04-12'

GROUP BY 
	1,	-- I didn't know I can put more than one parameter in the group by before. 
    2,
    3
ORDER BY 4 DESC