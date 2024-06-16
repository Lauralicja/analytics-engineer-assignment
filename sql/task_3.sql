CREATE TABLE IF NOT EXISTS daily_sales(
    'DATE' DATE,
    'TOTAL_SALES' INTEGER
);

INSERT INTO daily_sales ('DATE', 'TOTAL_SALES')
SELECT
    DATE(event_time) AS 'DATE', 
    COUNT(*) AS 'TOTAL_SALES'
    FROM event_clean
    WHERE event_type = 'purchase' 
    GROUP BY DATE(event_time), event_type;
