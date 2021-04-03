# 04_Load_data_from_dump

This directory is aimed at external users. It loads TSV files published at https://people.wikimedia.org/~urbanecm/wmcz/dashboard-stats-data/ (temporary location as of April 2021) into a MySQL database, which can then be queried.

## How-to

1. Copy `env.example` to `env`, open it with an editor, and change the variables.
    * `DB_NAME`: change this to your database name (you also need to create the database first)
    * `DB_HOST`: point this to your MySQL hostname (likely `localhost`)
    * `DB_DEFAULTS`: path to [MySQL user option file](https://dev.mysql.com/doc/refman/8.0/en/option-files.html), which should have both DB username and password set
2. Run  `load_data_from_dump.sh`
3. You should have a near-precise replica of original data generated in Hive in your MySQL database

## Notable differences from Hive tables

The original Hive `wmcz_outreach_dashboard_courses_csv` table uses `array<string>` to store wikis which are tracked in that particular course. Since MySQL doesn't have a comparable data type, `VARCHAR(255)` is used instead, with the data encoded in JSON array.
