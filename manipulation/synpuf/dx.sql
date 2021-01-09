-- use omop_synpuf;
SELECT
  dx.condition_occurrence_id          as dx_id
  ,dx.person_id
  ,dx.condition_start_date            as dx_date
  ,cdx.concept_code                   as icd9_code
  ,cdx.concept_name                   as icd9_description
  ,cast(case
    when dx.condition_type_concept_id = 38000200 then 1
    when dx.condition_type_concept_id = 38000230 then 0
    else                                              null
  end as bit)                                                as inpatient_visit
  -- ,dx.provider_id
  -- ,dx.visit_occurrence_id
FROM v5_2.condition_occurrence      as dx
  left  join v5_2.concept as cdx on dx.condition_source_concept_id = cdx.concept_id
WHERE
  person_id between 1 and 50
  and
  not dx.condition_occurrence_id in (5413)
ORDER BY person_id, dx_date
