CREATE TABLE IF NOT EXISTS daily_ticket(
    'DATE' TEXT, 
 	'TOTAL_SALES' INTEGER,
 	'MIN_TICKET' INTEGER,
 	'MAX_TICKET' INTEGER
);

WITH purchasers_cte AS (
    SELECT 
        SUM(COUNTER) as 'AMOUNT',
        user_id, 
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
    GROUP BY user_id, DATE
    ORDER BY DATE, amount
),

calc_percentiles_cte AS (
    SELECT 
        DATE,
        AMOUNT,
        ROUND(CUME_DIST() OVER(PARTITION BY DATE ORDER BY AMOUNT), 2) AS 'PERCENTILE'
    FROM purchasers_cte
),

max_value AS (
    SELECT 
        DATE,
        MAX(AMOUNT) as "AMOUNT" 
    FROM purchasers_cte
        GROUP BY DATE
        ORDER BY AMOUNT DESC
),

min_value AS (
    SELECT 
        DATE,
        MIN(AMOUNT) as "AMOUNT" 
    FROM purchasers_cte
        GROUP BY DATE
        ORDER BY AMOUNT DESC
)

INSERT INTO daily_ticket
SELECT
    daily_stats.DATE as 'DATE',
    daily_stats.AMOUNT as 'TOTAL_SALES',
    min_value.AMOUNT as 'MIN_TICKET',
    max_value.AMOUNT as 'MAX_TICKET'
FROM daily_stats
LEFT JOIN 
    min_value ON purchasers_cte.DATE = min_value.DATE
LEFT JOIN 
    max_value ON purchasers_cte.DATE = max_value.DATE;

