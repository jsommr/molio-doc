insert into construction_element_specification (construction_element_specification_id, title, molio_specification_guid)
values (200, 'En construction_element_specification', randomblob(16));

insert into construction_element_specification (construction_element_specification_id, title, molio_specification_guid)
values (201, 'En anden construction_element_specification', randomblob(16));

insert into construction_element_specification_section (
  construction_element_specification_id,
  parent_id,
  construction_element_specification_section_id,
  section_no,
  heading,
  molio_section_guid,
  body
) values (
  200, null, 300, 1, 'OMFANG', null,
  'Arbejdet omfatter levering og montering af:\n•\tBlank skalmur med varmeisolering foran facade, gavle og false\n•\tTegloverliggere, fugtspærre, kuldebrosisolering, bindere, armering, konsoljern, m.m.\n•\tSålbænke, præfabrikeret beton'
);

insert into construction_element_specification_section (
  construction_element_specification_id,
  parent_id,
  construction_element_specification_section_id,
  section_no,
  heading,
  molio_section_guid,
  body
) values (
  200, null, 301, 2, 'ALMENE SPECIFIKATIONER', randomblob(16),
  'Stk. 1. Leverandøren bør, inden arbejdet påbegyndes, sikre sig, at det overordnede grundlag for et konditionsmæssigt arbejde er til stede. Såfremt dette ikke er tilfældet, skal der straks rettes henvendelse til byggeledelsen. \n\nStk. 2. Såfremt det under arbejdet konstateres, at grundlaget for et konditionsmæssigt arbejde ikke er tilstede, rettes straks henvendelse til byggeledelsen.'
);

insert into construction_element_specification_section (
  construction_element_specification_id,
  parent_id,
  construction_element_specification_section_id,
  section_no,
  heading,
  molio_section_guid,
  body
) values (
  200, 301, 302, 1, 'Generelt', randomblob(16),
  'Stk. 1. Leverandøren bør, inden arbejdet påbegyndes, sikre sig, at det overordnede grundlag for et konditionsmæssigt arbejde er til stede. Såfremt dette ikke er tilfældet, skal der straks rettes henvendelse til byggeledelsen. \n\nStk. 2. Såfremt det under arbejdet konstateres, at grundlaget for et konditionsmæssigt arbejde ikke er tilstede, rettes straks henvendelse til byggeledelsen.'
);

insert into construction_element_specification_section (
  construction_element_specification_id,
  parent_id,
  construction_element_specification_section_id,
  section_no,
  heading,
  molio_section_guid,
  body
) values (
  200, 301, 303, 2, 'Orientering', null,
  'Stk. 1. Bygningsdelsbeskrivelse og tegninger/bygningsmodeller gælder frem for basis_specification.\n\nStk. 2. Bygningsdelsbeskrivelse gælder frem for byggesagsbeskrivelsen.\n\nStk. 3. Hvor der i basis_specificationr og construction_element_specificationr er anvendt forkortelser for bekendtgørelser og lignende henvises til byggesagsbeskrivelsen...'
);

insert into construction_element_specification_section (
  construction_element_specification_id,
  parent_id,
  construction_element_specification_section_id,
  section_no,
  heading,
  molio_section_guid,
  body
) values (
  200, 303, 304, 1, 'Generelt', null,
  'Stk. 1. Bygningsdelsbeskrivelse og tegninger/bygningsmodeller gælder frem for basis_specification.\r\n\r\nStk. 2. Bygningsdelsbeskrivelse gælder frem for byggesagsbeskrivelsen.\r\n\r\nStk. 3. Hvor der i basis_specificationr og construction_element_specificationr er anvendt forkortelser for bekendtgørelser og lignende henvises til byggesagsbeskrivelsen for den fulde...'
);