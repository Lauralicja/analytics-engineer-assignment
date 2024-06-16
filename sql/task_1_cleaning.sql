INSERT INTO event_raw
SELECT
    *
FROM temp_table;

DELETE FROM temp_table;

DELETE FROM event_raw WHERE event_time = 'event_time';