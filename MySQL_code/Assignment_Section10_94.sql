-- avg_days_first_to_second min_days_first_to_second max_days_first_to_second


use mavenfuzzyfactory;

CREATE TEMPORARY TABLE sessions_w_repeats
SELECT
	new_sessions.user_id,
    new_sessions.website_session_id AS first_session_id,
    new_sessions.created_at AS first_date,
    website_sessions.website_session_id AS second_session_id,
    website_sessions.created_at AS second_date
FROM (
	SELECT
	user_id,
    website_session_id,
    created_at
	FROM website_sessions
	WHERE created_at < '2014-11-03' -- the date of the assignment
		AND created_at >= '2014-01-01' -- prescribed date range in assignment
		AND is_repeat_session = 0
) AS new_sessions
	LEFT JOIN website_sessions
		ON website_sessions.user_id = new_sessions.user_id
        AND website_sessions.is_repeat_session = 1 -- was a repeat session (redundant but good to illustrate)
        AND website_sessions.website_session_id > new_sessions.website_session_id -- session was later than new session
        AND website_sessions.created_at < '2014-11-03' -- the date of the assignment
        AND website_sessions.created_at >= '2014-01-01' -- prescrebed date range in assignment
;
SELECT * FROM sessions_w_repeats;

CREATE TEMPORARY TABLE sessions_w_one_repeats
SELECT 
	*,
    MIN(second_session_id)
FROM sessions_w_repeats
GROUP BY first_session_id
 ;
 
SELECT * FROM sessions_w_one_repeats;

SELECT 
	AVG(DATEDIFF(second_date, first_date)) AS avg_days_first_to_second  ,
    MIN(DATEDIFF(second_date, first_date)) AS min_days_first_to_second,
    MAX(DATEDIFF(second_date, first_date)) AS max_days_first_to_second
FROM sessions_w_one_repeats
WHERE second_session_id IS NOT NULL;

-- SELECT 
-- 	* ,
--     MIN(repeat_session_id)
-- FROM sessions_w_repeats
-- WHERE new_session_id = 175279;