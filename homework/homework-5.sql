-- Homework 5
-- All questions target the database `synpuf_3`
-- Note 1: When asking about the "number of patients" it is implied that patients are unique
-- Note 2: the "MUST use" requirement may not contain ALL the necessary keywords to complete the task
-- Note 3: If not explicitly forbidden in "must NOT use" requirement, any keywords can be used
-- Note 4: The uniqueness of the diagnosis is defined by its icd9_code, not icd9_description (e.g. 234.9 and 234.99 are not the same)

--- Demonstration:
-- Q. How many different care sites did all female patients visit?
-- Version 1: Query
SELECT
 count(distinct v.care_site_id) as cs_count
FROM patient as p
INNER JOIN visit as v
  ON  p.person_id = v.person_id
WHERE p.gender = "female"
;

-- Version 2: Subquery
SELECT
 count(distinct care_site_id) as cs_count
FROM 
  (
   SELECT
     v.care_site_id
   FROM patient as p
   INNER JOIN visit as v
     ON p.person_id = v.person_id
   WHERE p.gender = "female"
    
  )
;

-- Version 3: Common Table Expression (CTE)
with cte_cs as(
   SELECT
     v.care_site_id
   FROM patient as p
   INNER JOIN visit as v
     ON p.person_id = v.person_id
   WHERE p.gender = "female"
)
SELECT 
  count(distinct care_site_id) as cs_count
FROM cte_cs
;


-- What state has the highest ration of outpatient to inpatient hospitals? 
-- What place of service has the highest average number of visits per patient?
-- What state has the most diverse body of diagnoses? 
-- What is the avarage bmi of females at their first visit? 
-- What is the average height of males at the their last visit? 
-- What state has the oldest body of patients?
-- What provider works in the most states? 

