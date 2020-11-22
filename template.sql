-- Enforce foreign key constraints
pragma foreign_keys = on;

-- File format version
pragma user_version = 1;

/* Table: Project

   This table is first set when the template is saved as a document for an
   actual project. In other words, a version containing Molio specifications
   is downloaded from molio.dk, uploaded to an editor, changed according to
   the tendering organization's needs, and used as a template for new projects.
   When going from template -> project, this table is set.
   
   Only one project per file is supported.

   Columns:

      project_guid
         Primary key. A unique identifier for the project that's used to
         associate external data to the mspec file, and to know when two or
         more mspec files are the same project.

      name - Project name.
      
      created_by_organization
         Name of the organization that created this document.

      created_by - Fullname of the creator of this document.

      revision_date
         Last document change date. Update whenever the user saves the
         document. Defaults to current date. Format: YYYY-MM-DD
         
      revision - Increment whenever revision_date is updated. Defaults to 1.

      contract
         Defaults to an empty string if the contract is unknown when creating
         the project.

      reviewed_by - Fullname of the reviewer. Optional.

      approved_by - Fullname of the person who approved this document. Optional.
      
      release_date
         When this document is sent to a recipient, someone who will perform
         what is specified. Format: YYYY-MM-DD. Optional.
*/
create table project (
  project_guid            blob    primary key,
  name                    text    not null,
  created_by_organization text    not null,
  created_by              text    not null,
  revision_date           text    not null default (date()),
  revision                integer not null default 1,
  contract                text    not null default '',
  reviewed_by             text,
  approved_by             text,
  release_date            text,
  
  constraint "project_guid is not a valid guid"
  check (typeof(project_guid) = 'blob' and
         length(project_guid) = 16),

  constraint "Invalid date used for release_date"
  check (release_date is null or date(release_date) is not null),

  constraint "Non-integer value used for revision"
  check (typeof(revision) = 'integer'),

  constraint "Invalid date used for revision_date"
  check (date(revision_date) is not null)
);
   
create trigger project_constraint_to_one_row before insert on project
when (select count(*) from project) >= 1
begin
  select raise(fail, 'Only one project per file is supported.');
end;

/* Table: Attachment

   Contains images and other binary files used in the document.

   Columns:

      id - Primary key.

      mime_type - Type of binary, eg. image/bmp or application/pdf.

      content - Binary data. Encode as UTF-8 if storing text.

      name - Attachment name. Defaults to an empty string.

      sha1_hash
         SHA1 hash of `content`. Used to determine if a file is already
         attached. Optional.
*/
create table attachment (
  id        integer primary key,
  mime_type text    not null,
  content   blob    not null,
  name      text    not null default '',
  sha1_hash blob,

  constraint "content is not a blob"
  check (typeof(content) = 'blob'),

  constraint "sha1_hash is not a valid SHA1 hash"
  check (sha1_hash is null or
         (typeof(sha1_hash) = 'blob' and
          length(sha1_hash) = 20)),

  constraint "duplicate sha1_hash detected"
  unique (sha1_hash)
);

/* Table: Construction Element Specification
   
   Columns:

      id - Primary key.

      molio_specification_guid
         Identifier for external Molio texts related to the construction
         element specification. Used when requesting basis specifications
         through the api.

      name - Name of the construction element specification.
*/
create table construction_element_specification (
  id                       integer primary key,
  molio_specification_guid blob    not null,
  name                     text    not null,

  constraint "molio_specification_guid is not a valid guid"
  check (typeof(molio_specification_guid) = 'blob' and
         length(molio_specification_guid) = 16)
);

/* Table: Construction Element Specification Section

   Columns:
  
      id - Primary key.

      construction_element_specification_id
         The construction element specification this section belongs to.

      section_no
         Section number for this section. Use digits only. See the view
         `construction_element_specification_section_path` for a way to
         retrieve the complete section path (eg. 1.2.2).

      heading - Section heading.

      body - Contents of the section. Some html tags are supported.

      molio_section_guid
         Identifier for external Molio texts. Used for finding the
         basis specification for this section, which is part of the json-
         document retrieved from the api using `molio_specification_guid` in
         the related `construction_element_specification`. Optional.

      parent_id - The parent section. Optional.
*/
create table construction_element_specification_section (
  id                                    integer primary key,
  construction_element_specification_id integer not null,
  section_no                            integer not null,
  heading                               text    not null,
  body                                  text    not null default '',
  molio_section_guid                    blob,
  parent_id                             integer,

  foreign key (construction_element_specification_id)
  references construction_element_specification (id),

  foreign key (parent_id)
  references construction_element_specification_section (id),

  constraint "molio_section_guid is not a valid guid"
  check (molio_section_guid is null or
         (typeof(molio_section_guid) = 'blob' and
          length(molio_section_guid) = 16)),

  constraint "Non-integer value used for section_no"
  check (typeof(section_no) = 'integer')
);

create unique index construction_element_specification_section_unique_section_paths
on construction_element_specification_section (
  id,
  ifnull(parent_id, -1), -- All nulls are treated as unique, convert to -1 instead
  section_no
);

/* Table: Work Specification
   
   Columns:
  
      id - Primary key.

      molio_specification_guid
         Identifier for external Molio texts related to the work specification.
         Used when requesting basis specifications through the api.

      work_area_code

      work_area_name
*/
create table work_specification (
  id                       integer primary key,
  molio_specification_guid blob    not null,
  work_area_code           text    not null,
  work_area_name           text    not null,

  constraint "molio_specification_guid is not a valid guid"
  check (typeof(molio_specification_guid) = 'blob' and
         length(molio_specification_guid) = 16)
);

/* Table: Work Specification Section

   Columns:

      id - Primary key.

      work_specification_id - The work specification this section belongs to.

      section_no
         Section number for this section. Use digits only. See the view
         `work_specification_section_path` for a way to retrieve the complete
         section path (eg. 1.2.2).

      heading - Section heading.

      body - Contents of the section. Some html tags are supported.

      molio_section_guid
         Identifier for external Molio texts. Used for finding the
         basis specification for this section, which is part of the json-
         document retrieved from the api using `molio_specification_guid` in
         the related `work_specification`. Optional.

      parent_id - The parent section. Optional.
*/
create table work_specification_section (
  id                    integer primary key,
  work_specification_id integer not null,
  section_no            int     not null,
  heading               text    not null,
  body                  text    not null default '',
  molio_section_guid    blob,
  parent_id             integer,

  foreign key (work_specification_id) references work_specification,
  foreign key (parent_id) references work_specification_section (id),

  constraint "molio_section_guid is not a valid guid"
  check (molio_section_guid is null or
         (typeof(molio_section_guid) = 'blob' and
          length(molio_section_guid) = 16)),

  constraint "Non-integer value used for section_no"
  check (typeof(section_no) = 'integer')
);

/* Table: Work Specification Section Construction Element Specification

   Many-to-many relationship table for `work_specification_section` and
   `section_construction_element_specification`.
*/
create table work_specification_section_construction_element_specification (
  id                                    integer primary key,
  work_specification_section_id         integer not null,
  construction_element_specification_id integer not null,

  foreign key (work_specification_section_id)
  references work_specification_section (id),

  foreign key (construction_element_specification_id)
  references construction_element_specification (id),

  constraint "Same construction_element_specification cannot be referenced more than once for the same work_specification_section"
  unique (work_specification_section_id, construction_element_specification_id)
);

create unique index work_specification_section_unique_section_paths
on work_specification_section (
  id,
  ifnull(parent_id, -1), -- All nulls are treated as unique, convert to -1 instead
  section_no
);

/* Table: Custom Data

   Used to store any kind of custom key-value pairs.

   Columns:

      key - Primary key.

      value - Binary content. Prefer UTF-8 if storing text.
*/
create table custom_data (
  key   text primary key,
  value blob
);

/* View: Work Specification Section Path

   `work_specification_section` is a self-referencing table where sections might
   have 0 to many sub sections. This view can be joined for useful columns when
   displaying the tree.

   Columns:

      id - A Work Specification Section id. Used for joins.

      section_path
         Contains the section_no path to the row, separated by a dot (.)
         If parent_id points to a parent with section_no = 3 and the row contains
         section_no = 1, then section_path = 3.1 (column type = text).

      level - The level in the tree of sections, starting at 1.

   Example:

      select * from work_specification_section
      natural join work_specification_section_path
      order by section_path;
*/
create view work_specification_section_path as
  with recursive tree (
    id,           -- integer
    section_no,   -- integer
    section_path, -- text
    level         -- integer
  ) as (
    select
      id,
      section_no,
      cast(section_no as text),
      1 as level
    from work_specification_section
    where parent_id is null
    union all
    select
      node.id,
      node.section_no,
      tree.section_path || '.' || node.section_no,
      tree.level + 1
    from work_specification_section node, tree
    where node.parent_id = tree.id
  )
  select id, section_path, level from tree;

/* View: Construction Element Specification Section Path

   `construction_element_specification_section` is a self-referencing table where sections might
   have 0 to many sub sections. This view can be joined for useful columns when
   displaying the tree.

   Columns:

      id - A Construction Element Specification Section id. Used for joins.

      section_path
         Contains the section_no path to the row, separated by a dot (.)
         If parent_id points to a parent with section_no = 3 and the row contains
         section_no = 1, then section_path = 3.1 (column type = text).

      level - The level in the tree of sections, starting at 1.

   Example:

      select * from construction_element_specification_section
      natural join construction_element_specification_section_path
      order by section_path;
*/
create view construction_element_specification_section_path as
  with recursive tree (
    id,           -- integer
    section_no,   -- integer
    section_path, -- text
    level         -- integer
  ) as (
    select
      id,
      section_no,
      cast(section_no as text),
      1 as level
    from construction_element_specification_section
    where parent_id is null
    union all
    select
      node.id,
      node.section_no,
      tree.section_path || '.' || node.section_no,
      tree.level + 1
    from construction_element_specification_section node, tree
    where node.parent_id = tree.id
  )
  select id, section_path, level from tree;
