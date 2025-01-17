-- Homework 3
-- All questions target the database `synpuf_2`
-- Note 1: all patients found in `dx` and `visit` can be found in `patient`
-- Note 2: Some patients from `patient` are missing from `dx`, `visit`, or both  
-- Note 3: When asking about the "number of patients" it is implied that patients are unique
-- Note 4: the "MUST use" requirement may not contain ALL the necessary keywords to complete the task
-- Note 5: If not explicitly forbidden in "must NOT use" requirement, any keywords can be used
-- Note 5: The uniqueness of the diagnosis is defined by its icd9_code, not icd9_description (e.g. 234.9 and 234.99 are not the same)

-- PART I

-- 1) How many patients can be observed in the `patient` table? 
-- Output dimensions: 1x1
-- Output must contain columns: `person_count`
SELECT 
count(distinct(person_id)) as person_count
FROM patient
;


-- 2) How many patients present in `dx` table are missing from `visit` table?
-- MUST use: IS NULL
-- Output dimensions: 1x1
-- Output must contain columns: `person_count`
SELECT
  count(distinct dx.person_id) as person_count
  --distinct dx.person_id -- to view id values
FROM  dx    
  left  join visit on dx.person_id = visit.person_id
WHERE visit.visit_id is null
;

-- 3) How many patients present in both `patient` and `dx` tables are missing from `visit` table?
-- MUST use: WHERE, LEFT JOIN, INNER JOIN
-- Output dimensions: 1x1
-- Output must contain columns: `person_count`
SELECT
  count(distinct p.person_id) as person_count
  --distinct p.person_id -- to view id values
FROM patient p
  inner join dx    as d on p.person_id = d.person_id
  left  join visit as v on p.person_id = v.person_id
WHERE v.visit_id is null
;


-- 4) How many patients present in `visit` table are missing from `dx` table?
-- Output dimensions: 1x1
-- Output must contain columns: `person_count`
SELECT
  count(distinct visit.person_id) as person_count
  --distinct visit.person_id -- to see why filtering on dx.dx_id works
  --,dx.dx_id
FROM  visit    
  left  join dx on visit.person_id = dx.person_id
WHERE dx.dx_id is null -- why does this work?
;

-- 5) How many unique patients present in both `patient` and `visit` tables are missing from `dx` table?
-- Output dimensions: 1x1
-- Output must contain columns: `person_count`
SELECT
  count(distinct
  p.person_id) as patient_count
  --*
FROM patient p
  left  join dx    as d on p.person_id = d.person_id
  inner join visit as v on p.person_id = v.person_id
WHERE d.dx_id is null
;

-- 6) How many patients are present in all three tables?
-- MUST use: LEFT JOIN
-- must NOT use: INNER JOIN
-- Output dimensions: 1x1
-- Output must contain columns: `person_count`
SELECT 
 count(distinct p.person_id) as person_count
FROM patient p
  left  join dx    as d on p.person_id = d.person_id
  left  join visit as v on p.person_id = v.person_id
WHERE 
  d.dx_id   is not null
  and
  v.visit_id is not null 
;


-- 7) How many persons in `patient` table are missing from both `dx` and `visit` tables? 
-- MUST use: LEFT JOIN
-- must NOT use: INNER JOIN
-- Output dimensions: 1x1
-- Output must contain columns: `person_count`
SELECT
  -- distinct patient.person_id, dx.dx_id, visit.visit_id
  count(distinct patient.person_id) as person_count
FROM patient 
  left  join dx    on patient.person_id = dx.person_id
  left  join visit on patient.person_id = visit.person_id
WHERE 
  dx.dx_id   is null
  and
  visit.visit_id is null
;


-- PART II

-- 8) Among  patients in `dx` table who are missing from `visit` table, what `person_id` number is the smallest?
-- Write the query that lists patients present in `dx` but NOT in `visit` table
-- Sort by `person_id` found in the `visit` table
-- Output dimensions: ?x2
-- Output must include columns named: `person_id_dx`, `person_id_visit`
select 
distinct dx.person_id as person_id_dx
, visit.person_id as person_id_visit
from dx
left join visit on dx.person_id = visit.person_id
order by person_id_visit
;


-- 9) Among patients in `visit` table who are missing from `dx` table, what `person_id` number is the smallest?
-- Hint 1: Write the query that lists patients present in `visit` but NOT in `dx` table
-- Hint 2: Sort by person_id found in the `dx` table
-- Output dimensions: ?x2
-- Output must include columns named: `person_id_visit`, `person_id_dx`
select 
distinct visit.person_id as person_id_visit
, dx.person_id as person_id_dx
from visit
left join dx on visit.person_id = dx.person_id
order by person_id_dx
;

-- 10) Among patients missing from both `dx` and `visit` tables, what person_id number is the smallest?
-- Output dimensions: ?x3
-- Output must include columns named: `person_id_patient`, `dx_id`, `visit_id`
SELECT
  distinct patient.person_id as person_id_patient, dx.dx_id, visit.visit_id
  --count(distinct patient.person_id) as person_count
FROM patient 
  left  join dx    on patient.person_id = dx.person_id
  left  join visit on patient.person_id = visit.person_id
WHERE 
  dx.dx_id   is null
  and
  visit.visit_id is null
ORDER BY patient.person_id asc
;


-- 11) Among patients present in all three tables, what person_id number is the smallest?
-- Output dimensions: ?x3
-- Output must include columns named: `person_id_patient`, `person_id_dx`, `person_id_visit`
SELECT
  distinct patient.person_id as person_id_patient,
  dx.person_id as person_id_dx
  ,visit.person_id as person_id_visit
  --count(distinct patient.person_id) as person_count
FROM patient 
  inner  join dx    on patient.person_id = dx.person_id
  inner  join visit on patient.person_id = visit.person_id
ORDER BY patient.person_id asc
;


-- PART III

-- 12) What is the difference (in absolute value) between the number of persons in `patient` table
-- and the number of persons in the `dx` table?
-- Output dimensions: 1x3
-- Output must contain columns: `n_person_patient`, `n_person_dx`, `n_diff`
SELECT 
count(distinct(a.person_id)) as person_count_patient,
count(distinct(b.person_id)) as person_count_dx,
abs(count(distinct(b.person_id)) - count(distinct(a.person_id))) as difference_count
FROM patient as a
LEFT join dx as b
;

-- 13) Speaking of patients observed in the `visit` table, 
-- What is the average number of visits per person? (rounded down to the nearest integer)
-- Output dimensions: 1x3
-- Output must include columns named `person_count`, `visit_count`, `visit_mean`
SELECT 
 count(distinct(person_id)) as person_count
,count(distinct(visit_id)) as visit_count
,count(distinct(visit_id))/count(distinct(person_id)) as mean_visit
FROM visit
;

-- 14) What visit category has the highest average number of visits per patient? 
-- Hint: NULL is not a category
-- Output dimensions: 2x4
-- Output must contain columns:  `visit_category`, `person_count`, `visit_count`, `mean_visit_count`
SELECT 
visit_category
,count(distinct(person_id)) as person_count
,count(distinct(visit_id)) as visit_count
,count(distinct(visit_id))/count(distinct(person_id)) as mean_visit_count
FROM visit
WHERE visit_category is not null
GROUP BY visit_category 
ORDER BY mean_visit_count desc
;

-- 15) How many unique diagnosis codes can be observed in the `dx` table? 
-- Write the query that returns counts of unique values for each column
-- Output dimensions: 1x6
-- Output must contain columns: 
-- `dx_count`, `person_count`, `date_count`, `dx_code_count`, `dx_label_count`, `ipv_count`
select
 count(distinct dx_id) as dx_count
,count(distinct person_id) as person_count
,count(distinct dx_date) as date_count
,count(distinct icd9_code) as dx_code_count
,count(distinct icd9_description) as dx_label_count
,count(distinct inpatient_visit) as ipv_count
from dx
;

-- 16) Write the query that returns unique `icd9_description`s that have multiple `icd9_code`s. 
-- What value of `icd9_description` appears in the first row when sorted alphabetically?
-- MUST use: HAVING
-- must NOT use: WHERE, LEFT JOIN, INNER JOIN
-- Output dimensions: ?x3
-- Output must include columns named `icd9_description`, `icd9_code`, `icd9_code_count`
select
   distinct(icd9_description) as icd9_description
  ,icd9_code
  ,count(distinct icd9_code) as icd9_code_count
from dx
group by icd9_description
having icd9_code_count > 1
order by icd9_description asc
;


-- 17) What is the average number of unique diagnoses (icd9_code) per patient in the `dx` table
-- (rounded down to the nearest integer)
-- Helper questions:
-- How many unique patients are in the `dx` table? 
-- How many unique diagnoses (codes) are in the `dx` table?
-- Output dimensions: 1x3
-- Output must contain columns:  `dx_count`,`person_count`, `mean_unique_dx`
SELECT 
 count(distinct(icd9_code)) as dx_count
,count(distinct(person_id)) as person_count
,count(distinct(icd9_code))/count(distinct(person_id)) as mean_unique_dx
FROM dx
;

-- 18) What is the average number of non-unique diagnoses (icd9_code) per patient in the `dx` table
-- (rounded down to the nearest integer)
-- Transitional questions (ones you must answer en route):
-- How many unique patients are in the `dx` table? 
-- How many non-unique diagnoses (icd9_code) are in the `dx` table?
-- Output dimensions: 1x3
-- Output must contain columns:   `dx_count`,`person_count`, `mean_dx`
SELECT 
count(distinct(dx_id)) as dx_count
,count(distinct(person_id)) as person_count
,count(distinct(dx_id))/count(distinct(person_id)) as mean_dx
FROM dx
;



-- PART IV
-- 19) How many NULL values does the column `race` contain? 
-- Write the query that counts the number of NULL values  in each column of the `patient` table
-- Must use: SUM, CASE WHEN, NULL
-- Must NOT use: COUNT, 
-- Output dimensions: 1x5
-- Output must contain columns:
-- `person_id_null_count`,`dob_null_count`,`gender_null_count`,`race_null_count`,`ethnicity_null_count`

SELECT 
   sum( case when person_id is NULL then 1 else 0 end)  as person_id_null_count
  ,sum( case when dob       is NULL then 1 else 0 end)  as dob_null_count
  ,sum( case when gender    is NULL then 1 else 0 end)  as gender_null_count
  ,sum( case when race      is NULL then 1 else 0 end)  as race_null_count
  ,sum( case when ethnicity is NULL then 1 else 0 end)  as ethnicity_null_count
FROM patient
;


-- 20) How many NULL values does the column `visit_category` contain? 
-- Write the query that counts the number of NULL values in each column of the `visit` table
-- Must use: COUNT
-- Must NOT use: SUM, CASE WHEN, NULL
-- Output dimensions: 1x6
-- Output must contain columns:
-- `visit_id_null_count`,`person_id_null_count`,`visit_category_null_count`,`visit_date_null_count`,`provider_id_null_count`,`care_site_id_null_count`

SELECT 
    count(*) - count(visit_id)       as visit_id_null_count
   ,count(*) - count(person_id)      as person_id_null_count
   ,count(*) - count(visit_category) as visit_category_null_count
   ,count(*) - count(visit_date)     as visit_date_null_count
   ,count(*) - count(provider_id)    as provider_id_null_count
   ,count(*) - count(care_site_id)   as care_site_id_null_count
FROM visit
;




-- Helper code

-- How many unique patients are present in all three tables? 
SELECT 
count(distinct(a.person_id)) as n_person_patient,
count(distinct(b.person_id)) as n_person_dx,
count(distinct(c.person_id)) as n_person_visit
FROM patient as a
inner join dx as b on a.person_id = b.person_id
inner join visit as c on a.person_id = c.person_id
;

-- How many unique patients are in each table?
SELECT 
count(distinct(a.person_id)) as person_count_patient,
count(distinct(b.person_id)) as person_count_dx,
count(distinct(c.person_id)) as person_count_visit
FROM patient as a
LEFT join dx as b on a.person_id = b.person_id
LEFT join visit as c on a.person_id = c.person_id
;

-- Write a query that shows what person_id shows up in what table
SELECT 
distinct(a.person_id) as person_id_patient,
b.person_id as person_id_dx,
c.person_id as person_id_visit
FROM patient as a
LEFT join dx as b on a.person_id = b.person_id
LEFT join visit as c on a.person_id = c.person_id
ORDER BY person_id_dx, person_id_visit
;



