CREATE TABLE temp_table(
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


CREATE TABLE event_raw(
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

-- .mode csv
-- .import --skip 1 data/2020-Jan.csv event_raw
-- .import data/2020-Jan.csv event_raw
-- skip not implemented before 3.31 XD

