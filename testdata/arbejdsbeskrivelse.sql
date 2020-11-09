insert into arbejdsbeskrivelse (arbejdsbeskrivelse_id, work_area_code, work_area_name, key)
values (400, '250', 'Murværk', randomblob(16));

insert into arbejdsbeskrivelse_section (
  arbejdsbeskrivelse_id,
  parent_id,
  arbejdsbeskrivelse_section_id,
  section_no,
  heading,
  molio_section_guid,
  text
) values (
  400, null, 500, 1, 'OMFANG', null, ''
);

insert into arbejdsbeskrivelse_section (
  arbejdsbeskrivelse_id,
  parent_id,
  arbejdsbeskrivelse_section_id,
  section_no,
  heading,
  molio_section_guid,
  text
) values (
  400, 500, 501, 1, '[L]%AD1 Ydervæg, skalmur mod tung bagvæg', null, ''
);

insert into arbejdsbeskrivelse_section_bygningsdelsbeskrivelse (
  arbejdsbeskrivelse_section_bygningsdelsbeskrivelse_id,
  arbejdsbeskrivelse_section_id,
  bygningsdelsbeskrivelse_id
) values (
  600, 501, 200
);

insert into arbejdsbeskrivelse_section (
  arbejdsbeskrivelse_id,
  parent_id,
  arbejdsbeskrivelse_section_id,
  section_no,
  heading,
  molio_section_guid,
  text
) values (
  400, 500, 502, 2, '[L]%AD2 Kælderydervæg, letklinker med tung bagvæg', null, ''
);

insert into arbejdsbeskrivelse_section_bygningsdelsbeskrivelse (
  arbejdsbeskrivelse_section_bygningsdelsbeskrivelse_id,
  arbejdsbeskrivelse_section_id,
  bygningsdelsbeskrivelse_id
) values (
  601, 502, 201
);