-- mon tue wed thu fri sat sun
use mavenfuzzyfactory;

CREATE TEMPORARY TABLE Get_Day
SELECT
	DATE(created_at) AS created_date,
    WEEKDAY(created_at) AS wkday,
    HOUR(created_at) AS hr,
    COUNT(DISTINCT website_session_id) AS website_sessions
FROM website_sessions
WHERE created_at BETWEEN '2012-09-15' AND '2012-11-15'
GROUP BY 1, 2, 3;

SELECT * FROM Get_Day;

-- SELECT
-- 	HOUR(created_at) AS hr,
-- 	COUNT(DISTINCT website_session_id),
--     COUNT(DISTINCT CASE WHEN WEEKDAY(created_at) = 0 THEN website_session_id ELSE NULL END) AS mon,
--     COUNT(DISTINCT CASE WHEN WEEKDAY(created_at) = 1 THEN website_session_id ELSE NULL END) AS tue,
--     COUNT(DISTINCT CASE WHEN WEEKDAY(created_at) = 2 THEN website_session_id ELSE NULL END) AS wed,
--     COUNT(DISTINCT CASE WHEN WEEKDAY(created_at) = 3 THEN website_session_id ELSE NULL END) AS thu,
--     COUNT(DISTINCT CASE WHEN WEEKDAY(created_at) = 4 THEN website_session_id ELSE NULL END) AS fri,
--     COUNT(DISTINCT CASE WHEN WEEKDAY(created_at) = 5 THEN website_session_id ELSE NULL END) AS sat,
--     COUNT(DISTINCT CASE WHEN WEEKDAY(created_at) = 6 THEN website_session_id ELSE NULL END) AS sun
-- FROM website_sessions
-- WHERE created_at BETWEEN '2012-09-15' AND '2012-11-15'
-- GROUP BY hr;

SELECT
	hr,
	ROUND(AVG(DISTINCT website_sessions), 1),
    ROUND(AVG(CASE WHEN wkday = 0 THEN website_sessions ELSE NULL END), 1) AS mon,
    ROUND(AVG(CASE WHEN wkday = 1 THEN website_sessions ELSE NULL END), 1)  AS tue,
    ROUND(AVG(CASE WHEN wkday = 2 THEN website_sessions ELSE NULL END), 1)  AS wed,
    ROUND(AVG(CASE WHEN wkday = 3 THEN website_sessions ELSE NULL END), 1)  AS thu,
    ROUND(AVG(CASE WHEN wkday = 4 THEN website_sessions ELSE NULL END), 1)  AS fri,
    ROUND(AVG(CASE WHEN wkday = 5 THEN website_sessions ELSE NULL END), 1)  AS sat,
    ROUND(AVG(CASE WHEN wkday = 6 THEN website_sessions ELSE NULL END), 1)  AS sun
FROM Get_Day
GROUP BY hr;