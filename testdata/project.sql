insert into project (
  project_guid,
  name,
  released,
  release_date,
  revision,
  tendering_organization_name,
  contract,
  created_by,
  reviewed_by,
  approved_by
) values (
  randomblob(16), 'Sample project', 1, '2021-05-05', 1, 'Tendering org', 'contract', 'John Doe', 'Jane Doe', null
);