@echo off
del template.db 2>NUL
sqlite3 template.db -cmd ".read template.sql"