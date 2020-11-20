insert into attachment (id, name, mime_type, content)
values (100, 'referenceliste.json', 'application/json', readfile('testdata/Referenceliste_B240_Murvaerk_20190828_3.json'));