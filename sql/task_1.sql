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

