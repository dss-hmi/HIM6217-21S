-- Homework 6
-- All questions target the database `synpuf_3`
-- Note 1: When asking about the "number of patients" it is implied that patients are unique
-- Note 2: the "MUST use" requirement may not contain ALL the necessary keywords to complete the task
-- Note 3: If not explicitly forbidden in "must NOT use" requirement, any keywords can be used
-- Note 4: The uniqueness of the diagnosis is defined by its icd9_code, not icd9_description (e.g. 234.9 and 234.99 are not the same)


-- Version 1: Using a Regular Query
SELECT
 count(distinct v.care_site_id) as cs_count
FROM patient as p
  inner join visit as v on p.person_id = v.person_id
WHERE p.gender = "female"
;

-- Version 2: Using a Subquery
SELECT
 count(distinct care_site_id) as cs_count
FROM 
  (
   SELECT
     v.care_site_id
   FROM patient as p
     inner join visit as v on p.person_id = v.person_id
   WHERE p.gender = "female"
    
  )
;

-- Version 3: Using a Common Table Expression (CTE)
with cte_cs as(
  SELECT
    v.care_site_id
  FROM patient as p
    inner join visit as v on p.person_id = v.person_id
  WHERE p.gender = "female"
)
SELECT 
  count(distinct care_site_id) as cs_count
FROM cte_cs
;


-- 1) What gender made the most outpatient visits? 
-- CTE must return table with columns: visit_id, gender, place_of_service
-- Output dimensions: 2x3
-- Output must contain columns: gender, place_of_service, visit_count
-- Answer must appear in the first row
with cte as (
  SELECT 
    v.visit_id, p.gender, cs.place_of_service
  FROM visit v
    inner join patient p on v.person_id = p.person_id
    inner join care_site cs on v.care_site_id = cs.care_site_id
)
SELECT
  gender, place_of_service,
  count(distinct visit_id) as visit_count
FROM cte
WHERE place_of_service = 'Outpatient Hospital'
GROUP BY gender, place_of_service
ORDER BY visit_count desc
;
-- female


-- 2) What provider (provider_id) works in the most states? 
-- CTE must return a table with three columns: provider_id, care_site_id, state
-- NULL is not a provider
-- Output dimensions: ?x2
-- Output must contain columns: state_count, provider_id
-- Answer must appear in the first row
with cte as(
  SELECT  v.provider_id, v.care_site_id, cs.state
  FROM visit as v
    inner join care_site as cs on v.care_site_id = cs.care_site_id
  WHERE v.provider_id is not NULL
)
SELECT
  provider_id -- because it's the grain of the table
  ,count(distinct state) as state_count
FROM cte
GROUP BY provider_id
ORDER BY state_count desc, provider_id asc
;
-- 6083

-- 3) What is the average height of females at the their last known height observation? 
-- CTE must produce table with 3 columns: person_id, visit_id, max_date
-- Output dimensions: 1x1
-- Output must contain a single column: avg_height_cm
with last_obs as(
  SELECT  o.person_id, o.visit_id, max(visit_date) as max_date
  FROM observation o left join visit v on 
    o.person_id = v.person_id 
    and 
    o.visit_id = v.visit_id
  GROUP BY o.person_id
)
SELECT
  round(avg(o.value),1) as avg_height_cm
FROM patient p
 inner join observation o  on 
   p.person_id = o.person_id
 inner join last_obs as lo on 
   p.person_id = lo.person_id 
   and 
   o.visit_id  = lo.visit_id 
WHERE 
  o.measure = 'height_cm'  
  and 
  p.gender = 'female'
;
--144.9





-- 4) What state has the most diverse body of diagnoses (icd9_code)? 
-- CTE must return a table with two columns: visit_id, state
-- Output dimensions: ?x2
-- Output must contain columns: state, dx_count
-- Answer must appear in the first row
with cte as(
  SELECT  distinct v.visit_id, cs.state
  FROM visit as v
    inner join  care_site as cs on 
      v.care_site_id = cs.care_site_id
)
SELECT 
  cte.state
  ,count(distinct icd9_code) as dx_count
FROM dx as d
  inner join cte on 
    dx.visit_id = cte.visit_id
GROUP BY cte.state 
ORDER BY dx_count desc
;
-- California


-- 5) What state has the highest average number of visits per patient?
-- CTE must return a table with three columns: visit_id, person_id, state
-- Output dimensions: ?x4
-- Output must contain columns: state, visit_count, person_count, visit_per_person
-- MUST use: cast
-- visit_per_person must be a floating decimal, not integer
-- Consider re-writing as a single query
with cte as(
  SELECT
    v.visit_id
   ,v.person_id
   ,cs.state
  FROM visit as v
    inner join care_site as cs on 
      v.care_site_id = cs.care_site_id
)
SELECT
  state
  ,count(distinct visit_id) as visit_count
  ,count(distinct person_id) as person_count
  ,cast(count(distinct visit_id) as float)/count(distinct person_id) as visit_per_person
FROM cte
GROUP BY state
ORDER BY visit_per_person desc
;
-- California

-- 6) What state has the highest ratio of outpatient to inpatient hospitals? 
-- CTE must return a table with columns: state, inpatient_care_count
-- Output dimensions: ?x4
-- Output must contain columns: state, outpatient_care_site_count, inpatient_care_site_count, out_in_ratio
-- MUST use: with, cast
-- visit_per_person must be a floating decimal, not integer
-- Answer must appear in the first row
with cte as(
  SELECT 
    state
    ,count(distinct care_site_id) as inpatient_care_site_count
  FROM care_site
  WHERE place_of_service = 'Inpatient Hospital'
  GROUP BY state, place_of_service
) 
SELECT 
  cs.state
  ,count(distinct cs.care_site_id) as care_site_count
  ,coalesce(cte.inpatient_care_site_count, 0) as inpatient_care_site_count
  ,coalesce(cte.inpatient_care_site_count, 0) / cast(count(distinct cs.care_site_id) as float)  as in_patient_prop
  
FROM care_site as cs
  left join cte on cs.state = cte.state
GROUP BY cs.state
ORDER BY in_patient_prop desc
;
-- Arkansas