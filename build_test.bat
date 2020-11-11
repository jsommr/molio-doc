@echo off
del file.mspec 2>NUL
sqlite3 file.mspec -cmd ".read template.sql" -cmd ".read testdata.sql"