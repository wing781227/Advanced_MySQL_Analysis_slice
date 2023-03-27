use mavenfuzzyfactory;

-- yr mo nonbrand brand brand_pct_of_nonbrand direct direct_pct_of_nonbrand organic organic_pct_of_nonbrand 

SELECT
	*
FROM website_sessions;

CREATE TEMPORARY TABLE label
SELECT
	YEAR(website_sessions.created_at) AS yr,
    MONTH(website_sessions.created_at) AS mo,
    COUNT(DISTINCT CASE WHEN website_sessions.utm_campaign = 'nonbrand' THEN website_sessions.website_session_id ELSE NULL END) AS nonbrand,
    COUNT(DISTINCT CASE WHEN website_sessions.utm_campaign = 'brand' THEN website_sessions.website_session_id ELSE NULL END) AS brand,
    COUNT(DISTINCT CASE WHEN website_sessions.utm_source IS NULL AND website_sessions.http_referer IS NULL THEN website_sessions.website_session_id ELSE NULL END) AS direct,
    COUNT(DISTINCT CASE WHEN website_sessions.utm_source IS NULL AND website_sessions.http_referer IN ('https://www.gsearch.com', 'https://www.bsearch.com') THEN website_sessions.website_session_id ELSE NULL END) AS organic
FROM website_sessions
WHERE website_sessions.created_at < '2012-12-23'
GROUP BY 1, 2;

SELECT
	*
FROM label;

SELECT
	yr,
    mo, 
    nonbrand, 
    brand, 
    brand/nonbrand AS brand_pct_of_nonbrand, 
    direct, 
    direct/nonbrand AS direct_pct_of_nonbrand, 
    organic, 
    organic/nonbrand AS organic_pct_of_nonbrand 
FROM label;