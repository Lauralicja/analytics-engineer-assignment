# Solution
During around 6 hours that I worked on this task, I managed to finish all of them except task number 6, which is not created fully (percentiles are not finished).
### Why SQL
I've decided to choose SQL instead of Python (even though I feel much more confident in Python) as those tasks seemed like a good case for SQL:
- Almost all of them are simple enough to be defined by a short SQL script.
- Scripts can be scheduled and ran on the database in various ways (scheduled queries, operators, ...)
- In case of collaboration with Data Analysts it would also provide for a better environment to collaborate.
- Description of the task and `sql` directory suggested this language a bit
- I wanted to excercise my SQL skill :)

In case of data manipulations being too complex, I'd resort to creating a python connector that would connect to the database, do the calculations required and then sink those into the database, pseudocode below:
```
import sqlite3
import pandas as pd
				
db = sqlite3.connect(‘assignment.db’)							
df = pd.read_sql_query("SELECT * FROM event_clean ... ", db)

daily_ticket = pd.DataFrame(columns["DATE", "TOTAL_SALES", "25_PERCENTILE" ... ])
daily_ticket.apply(lambda x: x["25_PERCENTILE"] = x.quantile(0.25))
daily_ticket.apply(lambda x: x["50_PERCENTILE"] = x.quantile(0.5))
daily_ticket.apply(lambda x: x["90_PERCENTILE"] = x.quantile(0.9))

cursor = db.cursor()								
cursor.execute(‘INSERT INTO ...’)							
cursor.fetchall()

```

In SQLite there is not enough analytics functions to calculate that with ease - the best I could create was creating a table with sum of tickets with their adjacent percentiles (per user and day):
|    DATE    | AMOUNT | PERCENTILE |
|:----------:|:------:|:----------:|
| 2020-01-01 | 1      | 0.01       | 
| 2020-01-01 | 2      | 0.12       | 
| ... | ...      | ...       | 
| 2020-01-31 | 256      | 1.0       | 

With python those would be easily calculated, with more features to be easily added in the future.
Although for batch load it would require to be scheduled differently than SQL (Airflow operators would not suffice as the data may take up too much space).

In general for my work I prefer using python.

Task 7 is mimicked in `Makefile`.
This behavior would be scheduled via any orchestrating tool.


There is a typo in the `create-empty-table.sql` file for which I posted a PR to fix.
