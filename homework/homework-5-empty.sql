-- Homework 5
-- All questions target the database `synpuf_3`
-- Note 1: All joins in this project will require inner join
-- Note 2: All queries in this assignment must use common table expression (CTE) implemented by a 'with' keyword
-- Note 3: When asking about the "number of patients" it is implied that patients are unique
-- Note 4: the "MUST use" requirement may not contain ALL the necessary keywords to complete the task
-- Note 5: If not explicitly forbidden in "must NOT use" requirement, any keywords can be used
-- Note 6: The uniqueness of the diagnosis is defined by its icd9_code, not icd9_description (e.g. 234.9 and 234.99 are not the same)

-- Demonstration of using Common Table Expressions (CTE)
-- Q. How many different care sites did all female patients visit?
-- Below are three ways to answer this questions, producing the same result

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


-- 2) What provider (provider_id) works in the most states? 
-- CTE must return a table with three columns: provider_id, care_site_id, state
-- NULL is not a provider
-- Output dimensions: ?x2
-- Output must contain columns: state_count, provider_id
-- Answer must appear in the first row


-- 3) What is the average height of females at the their last known height observation? 
-- CTE must produce table with 3 columns: person_id, visit_id, max_date
-- Output dimensions: 1x1
-- Output must contain a single column: avg_height_cm


-- 4) What state has the most diverse body of diagnoses (icd9_code)? 
-- CTE must return a table with two columns: visit_id, state
-- Output dimensions: ?x2
-- Output must contain columns: state, dx_count
-- Answer must appear in the first row


-- 5) What state has the highest average number of visits per patient?
-- CTE must return a table with three columns: visit_id, person_id, state
-- Output dimensions: ?x4
-- Output must contain columns: state, visit_count, person_count, visit_per_person
-- MUST use: cast
-- visit_per_person must be a floating decimal, not integer


-- 6) What state has the highest ratio of outpatient to inpatient hospitals? 
-- CTE must return a table with columns: state, inpatient_care_count
-- Output dimensions: ?x4
-- Output must contain columns: state, outpatient_care_site_count, inpatient_care_site_count, out_in_ratio
-- MUST use: with, cast
-- visit_per_person must be a floating decimal, not integer
-- Answer must appear in the first row
