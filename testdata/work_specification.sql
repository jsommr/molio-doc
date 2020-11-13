insert into work_specification (work_specification_id, work_area_code, work_area_name, key)
values (400, '250', 'Murværk', randomblob(16));

insert into work_specification_section (
  work_specification_id,
  parent_id,
  work_specification_section_id,
  section_no,
  heading,
  molio_section_guid,
  body
) values (
  400, null, 500, 1, 'OMFANG', null, ''
);

insert into work_specification_section (
  work_specification_id,
  parent_id,
  work_specification_section_id,
  section_no,
  heading,
  molio_section_guid,
  body
) values (
  400, 500, 501, 1, '[L]%AD1 Ydervæg, skalmur mod tung bagvæg', null, ''
);

insert into work_specification_section_construction_element_specification (
  work_specification_section_construction_element_specification_id,
  work_specification_section_id,
  construction_element_specification_id
) values (
  600, 501, 200
);

insert into work_specification_section (
  work_specification_id,
  parent_id,
  work_specification_section_id,
  section_no,
  heading,
  molio_section_guid,
  body
) values (
  400, 500, 502, 2, '[L]%AD2 Kælderydervæg, letklinker med tung bagvæg', null, ''
);

insert into work_specification_section_construction_element_specification (
  work_specification_section_construction_element_specification_id,
  work_specification_section_id,
  construction_element_specification_id
) values (
  601, 502, 201
);