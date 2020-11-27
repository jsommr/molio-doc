-- This file might change at any time, and is not part of the file format.
-- It can be used as a reference to extract content as JSON.

/* View: JSON Project

   Returns a JSON representation of the project.
*/
create view json_project as
  select json_object(
    'project_guid', lower(hex(project_guid)),
    'name', name,
    'created_by_system', created_by_system,
    'created_date', created_date,
    'modified_date', modified_date,
    'builder', builder,
    'project_key', project_key
  )
  from project;

/* View: JSON Work Specification

   Returns a JSON representation of work specifications, their sections and
   linked construction element specifications.
*/
create view json_work_spec as
  with section as (
    select * from work_spec_section
    natural join work_spec_section_path
  ),
  construction_element_spec_ref as (
    select * from work_spec_section_construction_element_spec wssces
    join construction_element_spec ces
    on ces.id = wssces.construction_element_spec_id
  )
  select json_group_array(
    json_object(
      'id', id,
      'work_area_code', work_area_code,
      'work_area_name', work_area_name,
      'created_by_organization', created_by_organization,
      'created_by', created_by,
      'revision_date', revision_date,
      'revision', revision,
      'reviewed_by', reviewed_by,
      'approved_by', approved_by,
      'molio_spec_guid', iif(molio_spec_guid is null, null, lower(hex(molio_spec_guid))),
      'sections', (
        select json_group_array(
          json_object(
            'id', id,
            'depth', depth,
            'section_no', section_no,
            'section_path', section_path,
            'heading', heading,
            'body', body,
            'molio_section_guid', iif(molio_section_guid is null, null, lower(hex(molio_section_guid))),
            'parent_id', parent_id,
            'construction_element_spec_refs', (
              select json_group_array(
                json_object(
                  'construction_element_spec_id', construction_element_spec_id,
                  'name', name
                )
              )
              from construction_element_spec_ref cesr
              where cesr.work_spec_section_id = sect.id
            )
          )
        )
        from section sect where sect.work_spec_id = ws.id
      )
    )
  )
  from work_spec ws;

/* View: JSON Construction Element Specification

   Returns a JSON representation of construction element specifications and
   their sections.
*/
create view json_construction_element_spec as
  with section as (
    select * from construction_element_spec_section
    natural join construction_element_spec_section_path
  )
  select json_group_array(
    json_object(
      'id', id,
      'name', name,
      'created_by_organization', created_by_organization,
      'created_by', created_by,
      'revision_date', revision_date,
      'revision', revision,
      'reviewed_by', reviewed_by,
      'approved_by', approved_by,
      'molio_spec_guid', iif(molio_spec_guid is null, null, lower(hex(molio_spec_guid))),
      'control_plan_id', control_plan_id,
      'sections', (
        select json_group_array(
          json_object(
            'id', id,
            'depth', depth,
            'section_no', section_no,
            'section_path', section_path,
            'heading', heading,
            'body', body,
            'molio_section_guid', iif(molio_section_guid is null, null, lower(hex(molio_section_guid))),
            'parent_id', parent_id
          )
        )
        from section sect where sect.construction_element_spec_id = ces.id
      )
    )
  )
  from construction_element_spec ces;