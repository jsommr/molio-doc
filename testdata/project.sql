insert into project (
  project_guid,
  name,
  created_by_system,
  builder,
  project_key
) values (
  randomblob(16), 'Sample project', 'Test system', 'Builder name', '2000-03'
);