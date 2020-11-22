insert into work_spec (id, molio_spec_guid, work_area_code, work_area_name)
values (400, randomblob(16), '250', 'Murværk');

insert into work_spec_section (
  work_spec_id,
  parent_id,
  id,
  section_no,
  heading,
  molio_section_guid,
  body
) values (
  400, null, 500, 1, 'OMFANG', null, ''
);

insert into work_spec_section (
  work_spec_id,
  parent_id,
  id,
  section_no,
  heading,
  molio_section_guid,
  body
) values (
  400, 500, 501, 1, '[L]%AD1 Ydervæg, skalmur mod tung bagvæg', null, ''
);

insert into work_spec_section_construction_element_spec (
  id,
  work_spec_section_id,
  construction_element_spec_id
) values (
  600, 501, 200
);

insert into work_spec_section (
  work_spec_id,
  parent_id,
  id,
  section_no,
  heading,
  molio_section_guid,
  body
) values (
  400, 500, 502, 2, '[L]%AD2 Kælderydervæg, letklinker med tung bagvæg', null, ''
);

insert into work_spec_section_construction_element_spec (
  id,
  work_spec_section_id,
  construction_element_spec_id
) values (
  601, 502, 201
);