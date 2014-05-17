# Load the data into database, combine, filter, export
cat sqlite-data-import.sql | /usr/local/opt/sqlite/bin/sqlite3 > result.csv

# for old versions of sqlite
# cat sqlite-data-import-from-db.sql | sqlite3 portal_mammals.sqlite

# Load into R for analysis and plotting
R CMD BATCH barplot-figure.R