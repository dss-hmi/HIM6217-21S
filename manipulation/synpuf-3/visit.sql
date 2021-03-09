-- use omop_synpuf
SELECT
  v.visit_occurrence_id as visit_id
  ,v.person_id
  --,case
  --  when v.visit_concept_id = 0 then null
  --  else                             cv.concept_name
  --end                                                   as visit_category
  -- ,v.visit_concept_id                                   as visit_category_concept_id
  ,v.visit_start_date as visit_date
  -- ,cvt.concept_name
  -- ,v.visit_type_concept_id
  ,v.provider_id
  ,v.care_site_id
  ,row_number() over (partition by v.person_id order by v.visit_start_date) as visit_within_pt_index
  -- ,v.admitting_source_concept_id
  -- ,v.admitting_source_value
  -- ,v.discharge_to_concept_id
  -- ,v.discharge_to_source_value
  -- ,v.preceding_visit_occurrence_id
FROM v5_2.visit_occurrence v
  inner join v5_2.concept     as cv  on v.visit_concept_id      = cv.concept_id
  -- inner join v5_2.concept     as cvt on v.visit_type_concept_id = cvt.concept_id
-- WHERE v.visit_type_concept_id        != 44818517  -- all the same value in this table
-- WHERE v.admitting_source_concept_id  != 0         -- all the same value in this table
-- WHERE v.discharge_to_concept_id      != 0         -- all the same value in this table

