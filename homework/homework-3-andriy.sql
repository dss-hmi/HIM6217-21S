-- Homework 3
-- All questions target the database `synpuf_2`
-- Note 1: all patients found in `dx` and `visit` can be found in `patient`
-- Note 2: Some patients from `patient` are missing from `dx`, `visit`, or both  

-- Requirements:
-- Must use: count(), distinct(), WHERE, LIKE
-- Must NOT use: 
-- Output dimensions: 1x1
-- Output must contain columns: n_contain_pain


--  1)

;

-- PART I

-- How many unique patients can be observed in the `patient` table? 
-- Output dimensions: 1x1
SELECT 
count(distinct(person_id)) as person_count
FROM patient
;



-- How many patients are present in all three tables?
-- MUST use: LEFT JOIN
-- must NOT use: INNER JOIN
-- Output dimensions: 1x1
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


-- How many unique patients present in `dx` table but missing in `visit` table?
-- MUST use: IS NULL
SELECT
  count(distinct dx.person_id) as patient_count
  --distinct dx.person_id
FROM  dx    
  left  join visit on dx.person_id = visit.person_id
WHERE visit.visit_id is null;

-- How many unique patients present in both `patient` and `dx` tables but absent from `visit` table?
-- MUST use: WHERE, LEFT JOIN, INNER JOIN,
SELECT
  --distinct p.person_id
  count(distinct p.person_id) as patient_count
FROM patient p
  inner join dx    as d on p.person_id = d.person_id
  left  join visit as v on p.person_id = v.person_id
WHERE v.visit_id is null;


-- How many unique patients are present in `visit` table but absent from `dx` table?
-- MUST use: LEFT JOIN, WHERE, IS NULL
SELECT
  count(distinct visit.person_id) as patient_count
  --distinct visit.person_id -- to see why filtering on dx.dx_id works
  --,dx.dx_id
FROM  visit    
  left  join dx on visit.person_id = dx.person_id
WHERE dx.dx_id is null -- why does this work?
;

-- How many unique patients are present in both `patient` and `visit` tables but absent from `ds` table?
SELECT
  count(distinct
  p.person_id) as patient_count
  --*
FROM patient p
  left  join dx    as d on p.person_id = d.person_id
  inner join visit as v on p.person_id = v.person_id
WHERE d.dx_id is null
;

-- How many persons in `patient` table are missing from both `dx` and `visit` tables? 
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


-- Speaking of patients observed in the `visit` table, 
-- What is the average number of visits per person? (rounded down to the nearest integer)
-- Output dimensions: 1x3
-- Output must include columns named `person_count`, `visit_count`, `visit_mean`
SELECT 
 count(distinct(person_id)) as person_count
,count(distinct(visit_id)) as visit_count
,count(distinct(visit_id))/count(distinct(person_id)) as mean_visit
FROM visit
;

-- How many unique patients can be observed in the `dx` table? 
-- Write the query that returns counts of unique values for each column
-- Requirements:
-- Output dimensions: 1x6
-- Output must include columns named:
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


-- What is the average number of unique diagnoses (icd9_code) per patient in the `dx` table
-- (rounded down to the nearest integer)
-- Transitional questions (ones you must answer en route):
-- How many unique patients are in the `dx` table? 
-- How many unique diagnoses (codes) are in the `dx` table?
SELECT 
 count(distinct(person_id)) as person_count
,count(distinct(icd9_code)) as dx_count
,count(distinct(icd9_code))/count(distinct(person_id)) as mean_dx
FROM dx
;

-- What is the average number of diagnoses (icd9_code) per patient in the `dx` table
-- (rounded down to the nearest integer)
-- Transitional questions (ones you must answer en route):
-- How many unique patients are in the `dx` table? 
-- How many diagnoses (icd9_code) are in the `dx` table?
SELECT 
count(distinct(dx_id)) as dx_count
,count(distinct(person_id)) as person_count
,count(distinct(dx_id))/count(distinct(person_id)) as mean_dx
FROM dx
;


-- Write the query that returns `icd9_description`s that have multiple `icd9_code`s. 
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

-- What visit category has the highest average number of visits per patient? 
-- NULL is not a category
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

-- PART III



-- List ids of patients present in ALL THREE tables and sort them in descending order
-- What value appears in the first row?
-- MUST use: INNER JOIN
-- must NOT use: LEFT JOIN
-- Output dimensions: ?x1
SELECT
  distinct
  p.person_id
  -- count(distinct p.person_id) as person_count
FROM patient p
  inner join dx    as d on p.person_id = d.person_id
  inner join visit as v on p.person_id = v.person_id
ORDER BY p.person_id desc
;
 

-- Among  patients in `dx` table who are missing from `visit` table, what person_id number is the smallest?
-- Hint 1: Write the query that lists patients present in `dx` but NOT in `visit` table
-- Hint 2: Sort by person_id found in the `visit` table
-- Output dimensions: ?x2
-- Output must include columns named: `person_id_dx`, `person_id_visit`
select 
distinct dx.person_id as person_id_dx
, visit.person_id as person_id_visit
from dx
left join visit on dx.person_id = visit.person_id
order by person_id_visit
;


-- Among patients in `visit` table who are missing from `dx` table, what person_id number is the smallest?
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

-- Among patients missing from both `dx` and `visit` tables, what person_id number is the smallest?
SELECT
  distinct patient.person_id, dx.dx_id, visit.visit_id
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

-- Among patients present in all three tables, what person_id number is the smallest?
SELECT
  distinct patient.person_id as person_id_patient,
  dx.person_id as person_id_dx, visit.person_id as person_id_visit
  --count(distinct patient.person_id) as person_count
FROM patient 
  inner  join dx    on patient.person_id = dx.person_id
  inner  join visit on patient.person_id = visit.person_id
ORDER BY patient.person_id asc
;


-- PART III

-- 1) How many more patients are in `patient` table than in the `dx` table?
-- Requirements:
-- Must use: count(), distinct()
-- Output dimensions: 1x3
-- Output must contain columns: n_person_patient, n_person_dx, n_diff
SELECT 
count(distinct(a.person_id)) as person_count_patient,
count(distinct(b.person_id)) as person_count_dx,
abs(count(distinct(b.person_id)) - count(distinct(a.person_id))) as difference_count
FROM patient as a
LEFT join dx as b
;


-- 2) list person_id that are present in both `patient` and `dx` tables 
--    and sort them descending order. What value appears in the first row? 
-- Requirements:
-- Must use: AS, ON
-- Output dimensions: ?x1
-- Output must contain columns: person_id
SELECT distinct(patient.person_id) as person_id
FROM patient
inner join dx
ON patient.person_id = dx.person_id
ORDER BY person_id desc
;

-- 3) list person_id that are present in `patient` but are missing in `dx` table 
--    and sort them descending order. What value appears in the first row? 

SELECT 
   distinct(patient.person_id) as person_id_patient
   , dx.person_id as person_id_dx
FROM patient
left join dx
ON patient.person_id = dx.person_id
ORDER BY person_id_patient desc
;

-- Create a table listing the 

-- 3) list person_id that are present in `dx` but are missing in `patient` table 
--    and sort them descending order. What value appears in the first row? 


-- 1) List the inpa

SELECT distinct(dx.person_id) as person_id
FROM dx 
LEFT JOIN patient
ON dx.person_id = patient.person_id
WHERE dx.inpatient_visit = 1 
ORDER BY person_id DESC
;




-- PART IV
-- Write the query that counts the number of NULL values  in each column of the `patient` table
-- How many NULL values does the column `race` contain? 
-- Requirements:
-- Must use: SUM, CASE WHEN, NULL
-- Must NOT use: COUNT, 
-- Output dimensions: 1x5
-- Output must contain columns: n_null_person_id, n_null_dob, n_null_gender, n_null_race, n_null_ethnicity
SELECT 
   sum( case when person_id is NULL then 1 else 0 end)  as n_null_person_id
  ,sum( case when dob       is NULL then 1 else 0 end)  as n_null_dob
  ,sum( case when gender    is NULL then 1 else 0 end)  as n_null_gender
  ,sum( case when race      is NULL then 1 else 0 end)  as n_null_race
  ,sum( case when ethnicity is NULL then 1 else 0 end)  as n_null_ethnicity
FROM patient
;

-- Write the query that counts the number of NULL values  in each column of the `dx` table
-- How many NULL values does the column `icd9_code` contain? 
-- Requirements:
-- Must use: SUM, CASE WHEN, NULL
-- Must NOT use: COUNT, 
-- Output dimensions: 1x6
SELECT 
   sum( case when dx_id            is NULL then 1 else 0 end) as n_null_dx_id
  ,sum( case when person_id        is NULL then 1 else 0 end) as n_null_person_id  
  ,sum( case when dx_date          is NULL then 1 else 0 end) as n_null_dx_date
  ,sum( case when icd9_code        is NULL then 1 else 0 end) as n_null_icd9_code
  ,sum( case when icd9_description is NULL then 1 else 0 end) as n_null_icd9_description
  ,sum( case when inpatient_visit  is NULL then 1 else 0 end) as n_null_inpatient
FROM dx
;

-- Write the query that counts the number of NULL values in each column of the `visit` table
-- How many NULL values does the column `visit_category` contain? 
-- Requirements:
-- Must use: COUNT
-- Must NOT use: SUM, CASE WHEN, NULL
-- Output dimensions: 1x6
SELECT 
    count(*) - count(visit_id)       as n_null_visit_id
   ,count(*) - count(person_id)      as n_null_person_id
   ,count(*) - count(visit_category) as n_null_visit_category
   ,count(*) - count(visit_date)     as n_null_visit_date
   ,count(*) - count(provider_id)    as n_null_provider_id
   ,count(*) - count(care_site_id)   as n_null_care_site_id
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



