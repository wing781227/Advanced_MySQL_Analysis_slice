-- time_period conv_rate aov products_per_order revenue_per_session
-- A. Pre_Birthday_Bear
-- B. Post_Birthday_Bear
-- 2013-11-12  2013-12-13  2014-01-13
use mavenfuzzyfactory;

SELECT
	user_id,
    website_session_id
FROM website_sessions
WHERE created_at < '2014-11-01' -- the date of the assignment
	AND created_at >= '2014-01-01' -- prescribed date range in assignment
    AND is_repeat_session = 0;

CREATE TEMPORARY TABLE sessions_w_repeats
SELECT
	new_sessions.user_id,
    new_sessions.website_session_id AS new_session_id,
    website_sessions.website_session_id AS repeat_session_id
FROM (
	SELECT
	user_id,
    website_session_id
	FROM website_sessions
	WHERE created_at < '2014-11-01' -- the date of the assignment
		AND created_at >= '2014-01-01' -- prescribed date range in assignment
		AND is_repeat_session = 0
) AS new_sessions
	LEFT JOIN website_sessions
		ON website_sessions.user_id = new_sessions.user_id
        AND website_sessions.is_repeat_session = 1 -- was a repeat session (redundant but good to illustrate)
        AND website_sessions.website_session_id > new_sessions.website_session_id -- session was later than new session
        AND website_sessions.created_at < '2014-11-01' -- the date of the assignment
        AND website_sessions.created_at >= '2014-01-01' -- prescrebed date range in assignment
;

SELECT * FROM sessions_w_repeats;

SELECT
	user_id,
	COUNT(DISTINCT new_session_id) AS new_sessions,
	COUNT(DISTINCT repeat_session_id) AS repeat_sessions
FROM sessions_w_repeats
GROUP BY 1
ORDER BY 3 DESC;

SELECT
	repeat_sessions,
    COUNT(DISTINCT user_id) AS users
FROM 
(
	SELECT
		user_id,
		COUNT(DISTINCT new_session_id) AS new_sessions,
		COUNT(DISTINCT repeat_session_id) AS repeat_sessions
	FROM sessions_w_repeats
    GROUP BY 1
    ORDER BY 3 DESC
) AS user_level
GROUP BY 1;
    
    
    
    
