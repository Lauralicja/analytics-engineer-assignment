CREATE TABLE IF NOT EXISTS event_clean(
    event_time TEXT,
    event_type TEXT,
    product_id INTEGER,
    category_id INTEGER,
    category_code TEXT,
    brand TEXT,
    price NUMERIC,
    user_id INTEGER,
    user_session TEXT
);


INSERT INTO event_clean
SELECT
    NULLIF(rtrim(event_time, " UTC"), '') AS event_time, -- we can do this only because all are utc; we need to parse them so we could use any date/time functions in the future
    NULLIF(event_type, '') AS event_type,
    NULLIF(product_id, '') AS product_id,
    NULLIF(category_id, '') AS category_id,
    NULLIF(category_code, '') AS category_code,
    NULLIF(brand, '') AS brand,
    NULLIF(price, '') AS price,
    NULLIF(user_id, '') AS user_id,
    NULLIF(user_session, '') AS user_session
FROM event_raw;

