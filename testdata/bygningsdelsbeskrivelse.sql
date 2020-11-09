insert into bygningsdelsbeskrivelse (bygningsdelsbeskrivelse_id, name, bygningsdelsbeskrivelse_guid, basisbeskrivelse_version_guid)
values (200, 'En bygningsdelsbeskrivelse', randomblob(16), randomblob(16));

insert into bygningsdelsbeskrivelse (bygningsdelsbeskrivelse_id, name, bygningsdelsbeskrivelse_guid, basisbeskrivelse_version_guid)
values (201, 'En anden bygningsdelsbeskrivelse', randomblob(16), randomblob(16));

insert into bygningsdelsbeskrivelse_section (
  bygningsdelsbeskrivelse_id,
  parent_id,
  bygningsdelsbeskrivelse_section_id,
  section_no,
  heading,
  molio_section_guid,
  text
) values (
  200, null, 300, 1, 'OMFANG', null,
  'Arbejdet omfatter levering og montering af:\n•\tBlank skalmur med varmeisolering foran facade, gavle og false\n•\tTegloverliggere, fugtspærre, kuldebrosisolering, bindere, armering, konsoljern, m.m.\n•\tSålbænke, præfabrikeret beton'
);

insert into bygningsdelsbeskrivelse_section (
  bygningsdelsbeskrivelse_id,
  parent_id,
  bygningsdelsbeskrivelse_section_id,
  section_no,
  heading,
  molio_section_guid,
  text
) values (
  200, null, 301, 2, 'ALMENE SPECIFIKATIONER', randomblob(16),
  'Stk. 1. Leverandøren bør, inden arbejdet påbegyndes, sikre sig, at det overordnede grundlag for et konditionsmæssigt arbejde er til stede. Såfremt dette ikke er tilfældet, skal der straks rettes henvendelse til byggeledelsen. \n\nStk. 2. Såfremt det under arbejdet konstateres, at grundlaget for et konditionsmæssigt arbejde ikke er tilstede, rettes straks henvendelse til byggeledelsen.'
);

insert into bygningsdelsbeskrivelse_section (
  bygningsdelsbeskrivelse_id,
  parent_id,
  bygningsdelsbeskrivelse_section_id,
  section_no,
  heading,
  molio_section_guid,
  text
) values (
  200, 301, 302, 1, 'Generelt', randomblob(16),
  'Stk. 1. Leverandøren bør, inden arbejdet påbegyndes, sikre sig, at det overordnede grundlag for et konditionsmæssigt arbejde er til stede. Såfremt dette ikke er tilfældet, skal der straks rettes henvendelse til byggeledelsen. \n\nStk. 2. Såfremt det under arbejdet konstateres, at grundlaget for et konditionsmæssigt arbejde ikke er tilstede, rettes straks henvendelse til byggeledelsen.'
);

insert into bygningsdelsbeskrivelse_section (
  bygningsdelsbeskrivelse_id,
  parent_id,
  bygningsdelsbeskrivelse_section_id,
  section_no,
  heading,
  molio_section_guid,
  text
) values (
  200, 301, 303, 2, 'Orientering', null,
  'Stk. 1. Bygningsdelsbeskrivelse og tegninger/bygningsmodeller gælder frem for basisbeskrivelse.\n\nStk. 2. Bygningsdelsbeskrivelse gælder frem for byggesagsbeskrivelsen.\n\nStk. 3. Hvor der i basisbeskrivelser og bygningsdelsbeskrivelser er anvendt forkortelser for bekendtgørelser og lignende henvises til byggesagsbeskrivelsen...'
);

insert into bygningsdelsbeskrivelse_section (
  bygningsdelsbeskrivelse_id,
  parent_id,
  bygningsdelsbeskrivelse_section_id,
  section_no,
  heading,
  molio_section_guid,
  text
) values (
  200, 303, 304, 1, 'Generelt', null,
  'Stk. 1. Bygningsdelsbeskrivelse og tegninger/bygningsmodeller gælder frem for basisbeskrivelse.\r\n\r\nStk. 2. Bygningsdelsbeskrivelse gælder frem for byggesagsbeskrivelsen.\r\n\r\nStk. 3. Hvor der i basisbeskrivelser og bygningsdelsbeskrivelser er anvendt forkortelser for bekendtgørelser og lignende henvises til byggesagsbeskrivelsen for den fulde...'
);