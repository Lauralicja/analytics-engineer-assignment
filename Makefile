.DEFAULT_GOAL := run

create-empty-table:
	@echo "Creating empty table"
	@sqlite3 db/assignment.db  ".read sql/create-empty-table.sql"

# TODO: Add all the necessary steps to complete the assignment
run:
	@sqlite3 db/assignment.db  ".read sql/task_1.sql"
	@sqlite3 db/assignment.db  ".mode csv" ".import data/2020-Jan.csv temp_table"
	@sqlite3 db/assignment.db  ".read sql/task_1_cleaning.sql"
	@sqlite3 db/assignment.db  ".read sql/task_2.sql"
	@sqlite3 db/assignment.db  ".read sql/task_3.sql"
	@sqlite3 db/assignment.db  ".read sql/task_4.sql"
	@sqlite3 db/assignment.db  ".read sql/task_5.sql"
	@sqlite3 db/assignment.db  ".read sql/task_6.sql"
	# TASK 7
	@sqlite3 db/assignment.db  ".mode csv" ".import data/2020-Feb.csv temp_table"
	@sqlite3 db/assignment.db  ".read sql/task_1_cleaning.sql"
	@sqlite3 db/assignment.db  ".read sql/task_2.sql"
	@sqlite3 db/assignment.db  ".read sql/task_3.sql"
	@sqlite3 db/assignment.db  ".read sql/task_4.sql"
	@sqlite3 db/assignment.db  ".read sql/task_5.sql"
	@sqlite3 db/assignment.db  ".read sql/task_6.sql"

