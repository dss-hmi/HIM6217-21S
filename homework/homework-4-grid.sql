with dx_cte as (
  SELECT
    distinct
    person_id
  FROM dx
 )
 ,visit_cte as (
  SELECT
    distinct
    person_id
  FROM visit
)
 
SELECT
  p.person_id   as in_patient_table
  ,d.person_id  as in_dx_table
  ,v.person_id  as in_visit_table
FROM patient p
  left  join dx_cte    d on p.person_id = d.person_id
  left  join visit_cte v on p.person_id = v.person_id
ORDER BY p.person_id
