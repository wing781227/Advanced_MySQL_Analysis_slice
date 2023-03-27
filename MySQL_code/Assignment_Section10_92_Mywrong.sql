-- repeat_sessions users
use mavenfuzzyfactory;

CREATE TEMPORARY TABLE repeat_0
SELECT
	0 AS repeat_sessions,
    user_id
FROM website_sessions
GROUP BY user_id
HAVING COUNT(user_id) = 1;

SELECT * FROM repeat_0;

CREATE TEMPORARY TABLE repeat_1
SELECT
	1 AS repeat_sessions,
    user_id
FROM website_sessions
GROUP BY user_id
HAVING COUNT(user_id) = 2;

SELECT * FROM repeat_1;

CREATE TEMPORARY TABLE repeat_2
SELECT
	2 AS repeat_sessions,
    user_id
FROM website_sessions
GROUP BY user_id
HAVING COUNT(user_id) = 3;

SELECT * FROM repeat_2;

CREATE TEMPORARY TABLE repeat_3
SELECT
	3 AS repeat_sessions,
    user_id
FROM website_sessions
GROUP BY user_id
HAVING COUNT(user_id) = 4;

SELECT * FROM repeat_3;

CREATE TEMPORARY TABLE final_data
SELECT
	*
FROM repeat_0
	UNION SELECT * FROM repeat_1
	UNION SELECT * FROM repeat_2
    UNION SELECT * FROM repeat_3;
    
SELECT * FROM final_data;

SELECT
	repeat_sessions,
    COUNT(user_id)
FROM final_data
GROUP BY repeat_sessions;
