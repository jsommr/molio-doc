@echo off
del test.db 2>NUL
sqlite3 test.db -cmd ".read template.sql" -cmd ".read testdata.sql"