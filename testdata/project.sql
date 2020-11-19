insert into project (
  project_guid,
  name,
  release_date,
  revision,
  created_by_organization,
  contract,
  created_by,
  reviewed_by,
  approved_by
) values (
  randomblob(16), 'Sample project', '2021-05-05', 1, 'Tendering org', 'contract', 'John Doe', 'Jane Doe', null
);