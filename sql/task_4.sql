CREATE TABLE IF NOT EXISTS daily_stats(
    'DATE' DATE,
    'VISITORS' INTEGER,
    'SESSIONS' INTEGER,
    'VIEWERS' INTEGER,
    'VIEWS' INTEGER,
    'LEADERS' INTEGER,
    'LEADS' INTEGER,
    'PURCHASERS' INTEGER,
    'PURCHASES' INTEGER
);

WITH visitors_cte AS (
    SELECT 
        COUNT(DISTINCT user_id) AS 'VISITORS', 
        DATE(event_time) AS 'DATE'
    FROM event_clean 
    GROUP BY DATE(event_time)
),

sessions_cte AS (
    SELECT 
        COUNT(DISTINCT user_session) AS 'SESSIONS', 
        DATE(event_time) AS 'DATE'
    FROM event_clean 
    WHERE event_type = 'view' 
    GROUP BY DATE(event_time)
),

viewers_cte AS (
    SELECT 
        COUNT(user_id) AS 'VIEWERS', 
        DATE
    FROM (
        SELECT 
            COUNT(product_id) as 'COUNTER', 
            user_id, 
            DATE(event_time) as 'DATE'
        FROM event_clean
        WHERE event_type = 'view' 
        GROUP BY user_id, DATE(event_time) 
        HAVING COUNTER >= 1
    )
    GROUP BY DATE
),

views_cte AS (
    SELECT
        COUNT(product_id) AS 'VIEWS',
        DATE(event_time) AS 'DATE'
    FROM event_clean 
    WHERE event_type = 'view' 
    GROUP BY DATE(event_time)
),

leaders_cte AS (
    SELECT 
        COUNT(user_id) AS 'LEADERS', 
        DATE
    FROM (
        SELECT 
            COUNT(product_id) as 'COUNTER', 
            user_id, 
            DATE(event_time) as 'DATE'
        FROM event_clean
        WHERE event_type = 'cart' 
        GROUP BY user_id, DATE(event_time) 
        HAVING COUNTER >= 1
    )
    GROUP BY DATE
),

leads_cte AS (
    SELECT
        COUNT(product_id) AS 'LEADS',
        DATE(event_time) AS 'DATE'
    FROM event_clean 
    WHERE event_type = 'cart' 
    GROUP BY DATE(event_time)
),

purchasers_cte AS (
    SELECT 
        COUNT(user_id) AS 'PURCHASERS', 
        DATE
    FROM (
        SELECT 
            COUNT(product_id) as 'COUNTER', 
            user_id, 
            DATE(event_time) as 'DATE'
        FROM event_clean
        WHERE event_type = 'purchase' 
        GROUP BY user_id, DATE(event_time) 
        HAVING COUNTER >= 1
    )
    GROUP BY DATE
),

purchases_cte AS (
    SELECT
        COUNT(product_id) AS 'PURCHASES',
        DATE(event_time) AS 'DATE'
    FROM event_clean 
    WHERE event_type = 'purchase' 
    GROUP BY DATE(event_time)
)

INSERT INTO daily_stats 
SELECT
    visitors_cte.DATE AS 'DATE', 
    visitors_cte.VISITORS  AS 'VISITORS',
    sessions_cte.SESSIONS AS 'SESSIONS', 
    viewers_cte.VIEWERS AS 'VIEWERS', 
    views_cte.VIEWS  AS 'VIEWS',
    leaders_cte.LEADERS AS 'LEADERS', 
    leads_cte.LEADS  AS 'LEADS',
    purchasers_cte.PURCHASERS AS 'PURCHASERS', 
    purchases_cte.PURCHASES  AS 'PURCHASES'
    FROM visitors_cte
    LEFT JOIN sessions_cte ON
        visitors_cte.DATE = sessions_cte.DATE
    LEFT JOIN viewers_cte ON
        visitors_cte.DATE = viewers_cte.DATE
    LEFT JOIN views_cte ON
        visitors_cte.DATE = views_cte.DATE
    LEFT JOIN leaders_cte ON
        visitors_cte.DATE = leaders_cte.DATE
    LEFT JOIN leads_cte ON
        visitors_cte.DATE = leads_cte.DATE
    LEFT JOIN purchasers_cte ON
        visitors_cte.DATE = purchasers_cte.DATE
    LEFT JOIN purchases_cte ON
        visitors_cte.DATE = purchases_cte.DATE;
