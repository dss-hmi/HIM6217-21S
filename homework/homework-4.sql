-- Homework 4
-- All questions target the database `synpuf_2`
-- Note 1: all patients found in `dx` and `visit` can be found in `patient`
-- Note 2: Some patients from `patient` are missing from `dx`, `visit`, or both  
-- Note 3: When asking about the "number of patients" it is implied that patients are unique
-- Note 4: the "MUST use" requirement may not contain ALL the necessary keywords to complete the task
-- Note 5: If not explicitly forbidden in "must NOT use" requirement, any keywords can be used
-- Note 5: The uniqueness of the diagnosis is defined by its icd9_code, not icd9_description (e.g. 234.9 and 234.99 are not the same)


-- 1) How many visits are observed in the care site with the most providers?
-- MUST use: count(), distinct, count(*)
-- Output dimensions: ?x3
-- Output must contain columns: `care_site_id`,'provider_id_count','visit_count'
SELECT 
  care_site_id
  ,count(distinct provider_id) as provider_id_count
  ,count(*)                    as visit_count
FROM visit
GROUP BY care_site_id
ORDER BY provider_id_count desc
;
--54



-- 2) How many care sites does the busiest provider (physician) practice at? 
-- Hint: "busiest" defined as one with the most visits
-- MUST use: count(), distinct, count(*)
-- Output dimensions: ?x3
-- Output must contain columns: `provider_id`,'care_site_id_count','visit_count'
SELECT
  provider_id
  ,count(distinct care_site_id) as care_site_id_count
  ,count(*)                     as visit_count
FROM visit
GROUP BY provider_id
ORDER BY visit_count desc
;
-- 1

-- 3) How many providers practice at more than 1 care site?
-- MUST Use: subquery
-- MUST use: count(*), count, distinct, HAVING
-- Output dimensions: 1x1
-- Output must contain columns: `provider_count`
SELECT count(*) AS provider_count
FROM (
SELECT
  provider_id
  ,count(distinct care_site_id) as care_site_id_count
FROM visit
WHERE provider_id is not NULL
GROUP BY provider_id
HAVING care_site_id_count > 1
ORDER BY care_site_id_count desc
)
;
-- 35

-- 4) What is the age of the oldest male patient at first diagnosis? 
-- Hint: calcualte the age of each patient at first diagnosis
-- Report age in years, rounded to two decimal places (`age_at_first_dx`)
-- Hint: divide the (difference in days between dob and date of first diagnosis) by 365.25 
-- Output dimensions: 1x5
-- Output must contain columns: `person_id`,`dob`,`dx_date`,`age_at_first_dx`,`dx_count`
-- MUST use: julianday(), min(), round()

SELECT
  p.person_id
  ,p.dob
  ,d.dx_date
  --,(julianday(d.dx_date) - julianday(p.dob)) as date_diff -- diff in days
  --,(julianday(d.dx_date) - julianday(p.dob))/365.25 as date_diff -- diff in years
  --,round((julianday(d.dx_date) - julianday(p.dob))/365.25, 2) as date_diff -- diff in years
  ,min(round((julianday(d.dx_date) - julianday(p.dob))/365.25, 2)) as age_at_first_dx -- age at first dx
  --,avg(round((julianday(d.dx_date) - julianday(p.dob))/365.25, 2)) as age_mean
  --,max(round((julianday(d.dx_date) - julianday(p.dob))/365.25, 2)) as age_max  -- age at last dx
  ,count(d.dx_id)                                                  as dx_count
FROM patient as p
  left join dx as d on p.person_id = d.person_id
  WHERE gender = 'male'
GROUP BY p.person_id, p.dob
ORDER BY age_at_first_dx desc
;
-- 85.79


-- 5) What is the age of the youngest female patient at last visit ? 
-- Hint: calcualte the age of each patient at last visit
-- Report age in years, rounded to two decimal places (`age_at_last_visit`)
-- Hint: divide the (difference in days between dob and date of last visit) by 365.25
-- Output dimensions: 1x5
-- Output must contain columns: `person_id`,`dob`,`visit_date`,`age_at_last_visit`,`visit_count`
-- MUST use: julianday(), max(), round()
SELECT
  p.person_id
  ,p.dob
  ,v.visit_date
  ,max(round((julianday(v.visit_date) - julianday(p.dob))/365.25, 2)) as age_at_last_visit  -- age at last dx
  ,count(v.visit_id)                                                  as visit_count
FROM patient as p
  left join visit as v on p.person_id = v.person_id
WHERE 
  gender = 'female'
  and 
  visit_date is not NULL
GROUP BY p.person_id, p.dob
ORDER BY age_at_last_visit asc
;
-- 29.62



-- 6) What is the average age of female patients at their last recorded visit? 
-- Hint: calcualte the age of each patient at last visit
-- Report age in years, rounded to 1 decimal place (`age_average_at_last_visit`)
-- Output dimensions: 1x1
-- Output must contain columns: `age_average_at_last_visit`
-- MUST use: subquery
-- MUST use: julianday(), max(), round(), avg()
-- Round `age_average_at_last_visit` to 1 decimal place
SELECT 
  round(avg(age_max),1) as age_average_at_last_visit
FROM 
  (
    SELECT
      p.person_id
      ,p.dob
      ,v.visit_date
      ,max((julianday(v.visit_date) - julianday(p.dob))/365.25) as age_max  -- age at last dx
      ,count(v.visit_id)                                        as visit_count
    FROM patient as p
      left join visit as v on p.person_id = v.person_id
    WHERE 
      gender = 'female'
      and 
      visit_date is not NULL
    GROUP BY p.person_id, p.dob
  )
;
-- 74.9
  
-- Alternative Solution:
-- Q. What is the average age of female patients at visit? 
-- Version 1: using a CTE
with pt as (
  SELECT
    p.person_id
    ,p.dob
    ,v.visit_date
    ,max((julianday(v.visit_date) - julianday(p.dob))/365.25) as age_max  -- age at last dx
    ,count(v.visit_id)                                        as visit_count
  FROM patient as p
    left join visit as v on p.person_id = v.person_id
  WHERE 
    gender = 'female'
    and 
    visit_date is not NULL
  GROUP BY p.person_id, p.dob
)
SELECT 
  avg(age_max) as age_average_at_last_visit
FROM pt;


-- 7) What is the second most frequent diagnosis (icd9_description) for patients whose age at the time of diagnosis is 70+ years?
-- Hint: some patients might contribute multiple data points
-- Output dimensions: 1x3
-- Output must contain columns: `icd9_code`, `icd9_description`,`icd9_count`
-- MUST use: count(*), cast(), julianday(), LIMIT, OFFSET
SELECT
  icd9_code
  ,icd9_description
  ,count(*)           as icd9_count
  --,d.*
  --,pt.*
  --,cast((julianday(d.dx_date) - julianday(pt.dob)) / 365.25 as int) as pt_age
  --,SQL Server syntax: floor(datediff(day, pt.dob, d.dx_date) / 365.25) as pt_age
  --,(d.dx_date - pt.dob)  as pt_age -- This probably ignores the month & day entire --using only the year for arithmetic?
FROM dx d
  left  join patient pt on d.person_id = pt.person_id
WHERE 
  70 <= cast((julianday(d.dx_date) - julianday(pt.dob)) / 365.25 as int)
  --SQL Server syntax: 70 <=floor(datediff(day, pt.dob, d.dx_date) / 365.25)
GROUP BY icd9_code, icd9_description
ORDER BY count(*) desc
LIMIT 1
OFFSET 1
; --SQLite syntax
--SQL Server syntax: fetch first 42 rows only;
-- `Atrial fibrillation`

-- 8) What month of observation has the most diverse body of diagnoses? (YYYY-MM)
-- Hint: "diverse" is defined as the larget number of unique diagnoses (icd9_code)
-- Hint: a month is defined as YYYY-MM value
-- Hint: use either `strftime()` (for SQLite only) or `substr()` (for SQLite or SQL Server)
-- MUST use: substr() OR strftime()
-- Output dimensions: x2
-- Output must contain columns: `visit_month`, `icd9_count`
SELECT
 --v.*
 strftime('%Y-%m', v.visit_date)  as visit_month
 -- ,substr(v.visit_date, 1, 7)       as visit_month_alt
 ,count( distinct d.icd9_code) as icd9_count
FROM visit as v
left join dx as d
on v.person_id = d.person_id
group by strftime('%Y-%m', v.visit_date)
order by icd9_count desc
;
-- 2008-08


-- The following constraints apply to questions 9, 10, and 11: 
-- Limit to patients born before 1960 that have at least one dx that includes the term "diabetes".  
-- Exclude visits with a missing care_site_id.
-- MUST use: count(), distinct, like
-- Output Dimensions: ?x4
-- Output must include columns: `care_site_id`,`patient_count`, `visit_count`,`provider_count`

-- 9) What care_site_id has the most distinct patients?  
-- Limit to patients born before 1960 that have at least one dx that includes the term "diabetes".  
-- Exclude visits with a missing care_site_id.
-- MUST use: count(), distinct, like
-- Output Dimensions: ?x4
-- Output must include columns: `care_site_id`,`patient_count`, `visit_count`,`provider_count`
-- The answer must appear in the first row
 
SELECT
  v.care_site_id
  ,count(distinct d.person_id  )  as patient_count
  ,count(distinct v.visit_id   )  as visit_count
  ,count(distinct v.provider_id)  as provider_count
  --d.*
FROM dx as d
  left  join visit   v on d.person_id = v.person_id
  left  join patient p on d.person_id = p.person_id
WHERE 
  v.care_site_id is not null
  and
  d.icd9_description like '%diabetes%'
  and
  p.dob <= '1959-12-31' 
  --or: p.dob < '1960-01-01'
GROUP BY v.care_site_id
ORDER BY count(distinct d.person_id) desc
--ORDER BY  count(distinct v.visit_id) desc
--ORDER BY  count(distinct v.provider_id) desc
; 
-- 40

-- 10) What care_site_id has the most distinct visits? 
-- Limit to patients born before 1960 that have at least one dx that includes the term "diabetes".  
-- Exclude visits with a missing care_site_id.
-- MUST use: count(), distinct, like
-- Output Dimensions: ?x4
-- Output must include columns: `care_site_id`,`patient_count`, `visit_count`,`provider_count`
-- The answer must appear in the first row 
SELECT
  v.care_site_id
  ,count(distinct d.person_id  )  as patient_count
  ,count(distinct v.visit_id   )  as visit_count
  ,count(distinct v.provider_id)  as provider_count
  --d.*
FROM dx as d
  left  join visit   v on d.person_id = v.person_id
  left  join patient p on d.person_id = p.person_id
WHERE 
  v.care_site_id is not null
  and
  d.icd9_description like '%diabetes%'
  and
  p.dob <= '1959-12-31' 
  --or: p.dob < '1960-01-01'
GROUP BY v.care_site_id
--ORDER BY count(distinct d.person_id) desc
ORDER BY  count(distinct v.visit_id) desc
--ORDER BY  count(distinct v.provider_id) desc
; 
-- 40

-- 11) What care_site_id has the most distinct providers? 
-- Limit to patients born before 1960 that have at least one dx that includes the term "diabetes".  
-- Exclude visits with a missing care_site_id.
-- MUST use: count(), distinct, like
-- Output Dimensions: ?x4
-- Output must include columns: `care_site_id`,`patient_count`, `visit_count`,`provider_count`
-- The answer must appear in the first row 
SELECT
  v.care_site_id
  ,count(distinct d.person_id  )  as patient_count
  ,count(distinct v.visit_id   )  as visit_count
  ,count(distinct v.provider_id)  as provider_count
  --d.*
FROM dx as d
  left  join visit   v on d.person_id = v.person_id
  left  join patient p on d.person_id = p.person_id
WHERE 
  v.care_site_id is not null
  and
  d.icd9_description like '%diabetes%'
  and
  p.dob <= '1959-12-31' 
  --or: p.dob < '1960-01-01'
GROUP BY v.care_site_id
--ORDER BY count(distinct d.person_id) desc
--ORDER BY  count(distinct v.visit_id) desc
ORDER BY  count(distinct v.provider_id) desc
; 
--7090



-- 12) In care sites with 50+ visits, what is the highest average patient age at visit?
-- Hint: first compute age at visit, then compute average 
-- Hint: a patient with three visits will be counted three times; a patient with one visit will be counted only once.
-- Hint: Round `patient_age_mean` to 2 decimal places
-- MUST use: avg(), julianday(), HAVING, count(*)
-- Output dimensions: ?x3
-- Output must contain columns: `care_site_id`, `patient_age_mean`,`visit_count`
SELECT
  v.care_site_id
  ,round(avg((julianday(v.visit_date) - julianday(pt.dob))/365.25),2) as patient_age_mean
  ,count(*)                                                           as visit_count
FROM visit v
  left  join patient pt on v.person_id = pt.person_id
GROUP BY v.care_site_id
HAVING 50 <= count(*) --This syntax works for SQLite & SQL Server
ORDER BY patient_age_mean desc
;
--73.64
