CREATE TABLE IF NOT EXISTS daily_funnel(
    'DATE' DATE,
    'VISITORS' INTEGER,
    'VIEWERS' INTEGER,
    'LEADERS' INTEGER,
    'PURCHASERS' INTEGER,
    'VISITOR_TO_VIEWER' INTEGER,
    'VIEWER_TO_LEADER' INTEGER,
    'LEADER_TO_PURCHASER' INTEGER
);

WITH visitors_cte AS (
    SELECT 
        COUNT(DISTINCT user_id) AS 'VISITORS', 
        DATE(event_time) AS 'DATE'
    FROM event_clean 
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
)


INSERT INTO daily_funnel 
SELECT
    visitors_cte.DATE AS 'DATE', 
    visitors_cte.VISITORS  AS 'VISITORS',
    viewers_cte.VIEWERS AS 'VIEWERS', 
    leaders_cte.LEADERS AS 'LEADERS', 
    purchasers_cte.PURCHASERS AS 'PURCHASERS', 
    ROUND(viewers_cte.VIEWERS * 1.0 / visitors_cte.VISITORS, 2) AS 'VISITOR_TO_VIEWER',
    ROUND(leaders_cte.LEADERS * 1.0 / viewers_cte.VIEWERS, 2) AS 'VIEWER_TO_LEADER',
    ROUND(purchasers_cte.PURCHASERS * 1.0 / leaders_cte.LEADERS, 2) AS 'LEADER_TO_PURCHASER'
    FROM visitors_cte
    LEFT JOIN viewers_cte ON
        visitors_cte.DATE = viewers_cte.DATE
    LEFT JOIN leaders_cte ON
        visitors_cte.DATE = leaders_cte.DATE
    LEFT JOIN purchasers_cte ON
        visitors_cte.DATE = purchasers_cte.DATE;
