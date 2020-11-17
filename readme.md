# Molio Specification Version 1 File Format
This repository contains the SQLite schema for the Molio Specification version 1 file format. Pull requests and comments are welcome.

## Getting Started

**Running on Windows**

Install SQLite and add the folder where sqlite3.exe is located to PATH. Use Chocolatey to ease the process: `choco install sqlite3`

**Running on Ubuntu**

`sudo apt-get install sqlite3`

**Building the database**

Execute `build_template` to create a plain database with schema only.
Execute `build_test` to create a database loaded with testdata.

**GZip**

If you want to experiment with GZip, you can use [7-Zip](https://www.7-zip.org/) on Windows and `gzip`/`gunzip` on Linux. If you prefer to use the command line for everything, install Windows Subsystem for Linux and run [this script to install Ubuntu 20.04](https://ja.nsommer.dk/articles/install-custom-wsl-distribution.html).

## Mime Type

**application/vnd.molio.specification;version=1**

Standard mime type for Molio Specification files.

File extension: .mspec

**application/vnd.molio.specification.template;version=1**

Files that are identical to `application/vnd.molio.specification;version=1`, but preloaded with data users are supposed to adjust according to their needs.

File extension: .mspectpl

## HTML

Supported html in section body-columns:

| Element | Description            |
|---------|------------------------|
| p       | Paragraph              |
| br      | Line break             |
| em      | Emphasized/italic text |
| strong  | Bold text              |
| ul      | Unordered list         |
| ol      | Ordered list           |
| li      | List item              |
| img     | Image                  |
| table   | Table                  |
| thead   | Table header           |
| tbody   | Table body             |
| tfoot   | Table footer           |
| tr      | Table row              |
| td      | Table data cell        |
| th      | Table heading cell     |

All element attributes must be removed, except for src on img.
