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

      created_by_system - Name of the system that created the project.

      created_date
         Date time (UTC) the project was created. Defaults to current date and
         time. Format: YYYY-MM-DD hh:mm:ss

      modified_date
         Date time (UTC) the project was last modified. Defaults to current date
         and time. Format: YYYY-MM-DD hh:mm:ss
      
      builder - Name of the builder for this project.

      project_key - Custom project key.
*/
create table project (
  project_guid      blob primary key,
  name              text not null,
  created_by_system text not null,
  created_date      text not null default (datetime('now', 'utc')),
  modified_date     text not null default (datetime('now', 'utc')),
  builder           text not null default '',
  project_key       text not null default '',

  constraint "Invalid datetime used for created_date"
  check (datetime(created_date) is not null),

  constraint "Invalid datetime used for modified_date"
  check (datetime(modified_date) is not null),
  
  constraint "project_guid is not a valid guid"
  check (typeof(project_guid) = 'blob' and
         length(project_guid) = 16)
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

/* Table: Control Plan

   Columns:

      id - Primary key.
*/
create table control_plan (
  id integer primary key
);

/* Table: Control Plan Section

   Columns:

      id - Primary key.

      control_plan_id - The control plan this section belongs to.

      section_no - Section number for this section. Use digits only.

      heading - Section heading.

      --- TODO: document all columns ---

      parent_id - The parent section. Optional.
*/
create table control_plan_section (
  id                  integer primary key,
  control_plan_id     integer not null,
  section_no          integer not null,
  heading             text    not null,
  subject             text    not null default '',
  reference           text    not null default '',
  method              text    not null default '',
  quantity            text    not null default '',
  time                text    not null default '',
  acceptance_criteria text    not null default '',
  parent_id           integer,

  foreign key (control_plan_id)
  references control_plan (id),

  foreign key (parent_id)
  references control_plan_section (id),

  constraint "Non-integer value used for section_no"
  check (typeof(section_no) = 'integer')
);

create unique index control_plan_section_unique_section_paths
on control_plan_section (
  id,
  ifnull(parent_id, -1), -- All nulls are treated as unique, convert to -1 instead
  section_no
);

/* Table: Construction Element Specification
   
   Columns:

      id - Primary key.

      name - Name of the construction element specification.

      created_by_organization
         Name of the organization that created this document.

      created_by - Fullname of the creator of this document.

      revision_date - Defaults to current date. Format: YYYY-MM-DD
         
      revision - Increment whenever revision_date is updated. Defaults to 1.

      reviewed_by - Fullname of the reviewer. Defaults to empty string.

      approved_by
         Fullname of the person who approved this document. Defaults to empty
         string.

      molio_spec_guid
         Identifier for external Molio texts related to the construction
         element specification. Used when requesting basis specifications
         through the api. Optional.

      control_plan_id - Reference to associated control plan.
*/
create table construction_element_spec (
  id                      integer primary key,
  name                    text    not null,
  created_by_organization text    not null,
  created_by              text    not null,
  revision_date           text    not null default (date()),
  revision                integer not null default 1,
  reviewed_by             text    not null default '',
  approved_by             text    not null default '',
  molio_spec_guid         blob,
  control_plan_id         integer,

  foreign key (control_plan_id)
  references control_plan (id),

  constraint "molio_spec_guid is not a valid guid"
  check (molio_spec_guid is null or
         (typeof(molio_spec_guid) = 'blob' and
          length(molio_spec_guid) = 16)),

  constraint "Non-integer value used for revision"
  check (typeof(revision) = 'integer'),

  constraint "Invalid date used for revision_date"
  check (date(revision_date) is not null)
);

/* Table: Construction Element Specification Section

   Columns:
  
      id - Primary key.

      construction_element_spec_id
         The construction element specification this section belongs to.

      section_no
         Section number for this section. Use digits only. See the view
         `construction_element_spec_section_path` for a way to
         retrieve the complete section path (eg. 1.2.2).

      heading - Section heading.

      body - Contents of the section. Some html tags are supported.

      molio_section_guid
         Identifier for external Molio texts. Used for finding the
         basis specification for this section, which is part of the json-
         document retrieved from the api using `molio_spec_guid` in
         the related `construction_element_spec`. Optional.

      parent_id - The parent section. Optional.
*/
create table construction_element_spec_section (
  id                           integer primary key,
  construction_element_spec_id integer not null,
  section_no                   integer not null,
  heading                      text    not null,
  body                         text    not null default '',
  molio_section_guid           blob,
  parent_id                    integer,

  foreign key (construction_element_spec_id)
  references construction_element_spec (id),

  foreign key (parent_id)
  references construction_element_spec_section (id),

  constraint "molio_section_guid is not a valid guid"
  check (molio_section_guid is null or
         (typeof(molio_section_guid) = 'blob' and
          length(molio_section_guid) = 16)),

  constraint "Non-integer value used for section_no"
  check (typeof(section_no) = 'integer')
);

create unique index construction_element_spec_section_unique_section_paths
on construction_element_spec_section (
  id,
  ifnull(parent_id, -1), -- All nulls are treated as unique, convert to -1 instead
  section_no
);

/* Table: Work Specification
   
   Columns:
  
      id - Primary key.

      work_area_code

      work_area_name

      created_by_organization
         Name of the organization that created this document.

      created_by - Fullname of the creator of this document.

      revision_date - Defaults to current date. Format: YYYY-MM-DD
         
      revision - Increment whenever revision_date is updated. Defaults to 1.

      reviewed_by - Fullname of the reviewer. Defaults to empty string.

      approved_by
         Fullname of the person who approved this document. Defaults to empty
         string.

      molio_spec_guid
         Identifier for external Molio texts related to the work specification.
         Used when requesting basis specifications through the api. Optional.
*/
create table work_spec (
  id                      integer primary key,
  work_area_code          text    not null,
  work_area_name          text    not null,
  created_by_organization text    not null,
  created_by              text    not null,
  revision_date           text    not null default (date()),
  revision                integer not null default 1,
  reviewed_by             text    not null default '',
  approved_by             text    not null default '',
  molio_spec_guid         blob,
  -- TODO: foreign key to contract-table

  constraint "molio_spec_guid is not a valid guid"
  check (molio_spec_guid is null or
         (typeof(molio_spec_guid) = 'blob' and
          length(molio_spec_guid) = 16)),

  constraint "Non-integer value used for revision"
  check (typeof(revision) = 'integer'),

  constraint "Invalid date used for revision_date"
  check (date(revision_date) is not null)
);

/* Table: Work Specification Section

   Columns:

      id - Primary key.

      work_spec_id - The work specification this section belongs to.

      section_no
         Section number for this section. Use digits only. See the view
         `work_spec_section_path` for a way to retrieve the complete
         section path (eg. 1.2.2).

      heading - Section heading.

      body - Contents of the section. Some html tags are supported.

      molio_section_guid
         Identifier for external Molio texts. Used for finding the
         basis specification for this section, which is part of the json-
         document retrieved from the api using `molio_spec_guid` in
         the related `work_spec`. Optional.

      parent_id - The parent section. Optional.
*/
create table work_spec_section (
  id                 integer primary key,
  work_spec_id       integer not null,
  section_no         int     not null,
  heading            text    not null,
  body               text    not null default '',
  molio_section_guid blob,
  parent_id          integer,

  foreign key (work_spec_id)
  references work_spec (id),

  foreign key (parent_id)
  references work_spec_section (id),

  constraint "molio_section_guid is not a valid guid"
  check (molio_section_guid is null or
         (typeof(molio_section_guid) = 'blob' and
          length(molio_section_guid) = 16)),

  constraint "Non-integer value used for section_no"
  check (typeof(section_no) = 'integer')
);

create unique index work_spec_section_unique_section_paths
on work_spec_section (
  id,
  ifnull(parent_id, -1), -- All nulls are treated as unique, convert to -1 instead
  section_no
);

/* Table: Work Specification Section Construction Element Specification

   Many-to-many relationship table for `work_spec_section` and
   `section_construction_element_spec`.
*/
create table work_spec_section_construction_element_spec (
  id                           integer primary key,
  work_spec_section_id         integer not null,
  construction_element_spec_id integer not null,

  foreign key (work_spec_section_id)
  references work_spec_section (id),

  foreign key (construction_element_spec_id)
  references construction_element_spec (id),

  constraint "Same construction_element_spec cannot be referenced more than once for the same work_spec_section"
  unique (work_spec_section_id, construction_element_spec_id)
);

/* Table: Interface Diagram PDF

   Only one interface diagram pdf per file is supported.

   Columns:

      id - Primary key.

      content - The PDF.
*/
create table interface_diagram_pdf (
  id      integer primary key,
  content blob    not null,

  constraint "content is not a blob"
  check (typeof(content) = 'blob')
);

create trigger interface_diagram_pdf_constraint_to_one_row before insert on interface_diagram_pdf
when (select count(*) from interface_diagram_pdf) >= 1
begin
  select raise(fail, 'Only one interface diagram pdf per file is supported.');
end;

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

   `work_spec_section` is a self-referencing table where sections might
   have 0 to many sub sections. This view can be joined for useful columns when
   displaying the tree.

   Columns:

      id - A Work Specification Section id. Used for joins.

      section_path
         Contains the section_no path to the row, separated by a dot (.)
         If parent_id points to a parent with section_no = 3 and the row contains
         section_no = 1, then section_path = 3.1 (column type = text).

      depth - The depth in the tree of sections, starting at 1.

   Example:

      select * from work_spec_section
      natural join work_spec_section_path
      order by section_path;
*/
create view work_spec_section_path as
  with recursive tree (
    id,           -- integer
    section_no,   -- integer
    section_path, -- text
    depth         -- integer
  ) as (
    select
      id,
      section_no,
      cast(section_no as text),
      1 as depth
    from work_spec_section
    where parent_id is null
    union all
    select
      node.id,
      node.section_no,
      tree.section_path || '.' || node.section_no,
      tree.depth + 1
    from work_spec_section node, tree
    where node.parent_id = tree.id
  )
  select id, section_path, depth from tree;

/* View: Construction Element Specification Section Path

   `construction_element_spec_section` is a self-referencing table where sections might
   have 0 to many sub sections. This view can be joined for useful columns when
   displaying the tree.

   Columns:

      id - A Construction Element Specification Section id. Used for joins.

      section_path
         Contains the section_no path to the row, separated by a dot (.)
         If parent_id points to a parent with section_no = 3 and the row contains
         section_no = 1, then section_path = 3.1 (column type = text).

      depth - The depth in the tree of sections, starting at 1.

   Example:

      select * from construction_element_spec_section
      natural join construction_element_spec_section_path
      order by section_path;
*/
create view construction_element_spec_section_path as
  with recursive tree (
    id,           -- integer
    section_no,   -- integer
    section_path, -- text
    depth         -- integer
  ) as (
    select
      id,
      section_no,
      cast(section_no as text),
      1 as depth
    from construction_element_spec_section
    where parent_id is null
    union all
    select
      node.id,
      node.section_no,
      tree.section_path || '.' || node.section_no,
      tree.depth + 1
    from construction_element_spec_section node, tree
    where node.parent_id = tree.id
  )
  select id, section_path, depth from tree;
