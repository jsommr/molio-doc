@echo off
del file.mspectpl 2>NUL
sqlite3 file.mspectpl -cmd ".read template.sql"