# Molio Doc
This repository contains the SQLite schema for Molio Doc (todo: better name). Pull requests and comments are welcome.

**Running on Windows**
Install SQLite and add the folder where sqlite3.exe is located to PATH. Use Chocolatey to ease the process: `choco install sqlite3`

**Running on Ubuntu**
Install SQLite via `sudo apt-get install sqlite3`

**Building the database**
Execute `build_template` to create a plain database with schema only.
Execute `build_test` to create a database loaded with testdata.

**GZip**
If you want to experiment with GZip, you can use [7-Zip](https://www.7-zip.org/) on Windows and `gzip`/`gunzip` on Linux. If you prefer to use the command line for everything, install Windows Subsystem for Linux and run [this script to install Ubuntu 20.04](https://ja.nsommer.dk/articles/install-custom-wsl-distribution.html).