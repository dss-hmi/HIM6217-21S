-- Homework 4
-- All questions target the database `synpuf_2`
-- Note 1: all patients found in `dx` and `visit` can be found in `patient`
-- Note 2: Some patients from `patient` are missing from `dx`, `visit`, or both  
-- Note 3: When asking about the "number of patients" it is implied that patients are unique
-- Note 4: the "MUST use" requirement may not contain ALL the necessary keywords to complete the task
-- Note 5: If not explicitly forbidden in "must NOT use" requirement, any keywords can be used
-- Note 5: The uniqueness of the diagnosis is defined by its icd9_code, not icd9_description (e.g. 234.9 and 234.99 are not the same)

-- PART I




-- Visit
-- Q. What care site has the most providers?
-- Q. How many visits are observed in the care site with the most providers?
SELECT 
  care_site_id
  ,count(distinct provider_id) as provider_id_count
  ,count(*)                    as visit_count
FROM visit
GROUP BY care_site_id
ORDER BY provider_id_count desc
;

-- Q. How many care sites does the busines provier practice at? 
-- hint: busiest = most visits
SELECT
  provider_id
  ,count(distinct care_site_id) as care_site_id_count
  ,count(*)                     as visit_count
FROM visit
GROUP BY provider_id
ORDER BY visit_count desc
;

-- Q. How many providers practice at more than 1 care site?
SELECT
  provider_id
  ,count(distinct care_site_id) as care_site_id_count
FROM visit
WHERE provider_id is not NULL
GROUP BY provider_id
HAVING care_site_id_count > 1
ORDER BY care_site_id_count desc
;

-- Diagnosis
-- Who was the oldest male patient at first diagnosis? 
-- Q. What is the average age of male patients at first diagnosis (recorded in the system)? 
-- Note: where a simple summary/aggregation is aligned with the questions
SELECT
  p.person_id
  ,p.dob
  ,d.dx_date
  --,(julianday(d.dx_date) - julianday(p.dob)) as date_diff -- diff in days
  --,(julianday(d.dx_date) - julianday(p.dob))/365.25 as date_diff -- diff in years
  --,round((julianday(d.dx_date) - julianday(p.dob))/365.25, 2) as date_diff -- diff in years
  ,min(round((julianday(d.dx_date) - julianday(p.dob))/365.25, 2)) as age_min -- age at first dx
  --,avg(round((julianday(d.dx_date) - julianday(p.dob))/365.25, 2)) as age_mean
  --,max(round((julianday(d.dx_date) - julianday(p.dob))/365.25, 2)) as age_max  -- age at last dx
  ,count(d.dx_id)                                                  as dx_count
FROM patient as p
  left join dx as d on p.person_id = d.person_id
  WHERE gender = 'male'
GROUP BY p.person_id, p.dob
ORDER BY age_min desc
;

-- Q. what the patient's first diagnosis? 

-- Who was the youngest female patient at last visit (recorded in the system)? 
-- Q. What is the average age of female patients at vist? 
SELECT
  p.person_id
  ,p.dob
  ,v.visit_date
  --,(julianday(d.dx_date) - julianday(p.dob)) as date_diff -- diff in days
  --,(julianday(d.dx_date) - julianday(p.dob))/365.25 as date_diff -- diff in years
  --,round((julianday(d.dx_date) - julianday(p.dob))/365.25, 2) as date_diff -- diff in years
  --,min(round((julianday(d.dx_date) - julianday(p.dob))/365.25, 2)) as age_min -- age at first dx
  --,avg(round((julianday(d.dx_date) - julianday(p.dob))/365.25, 2)) as age_mean
  ,max(round((julianday(v.visit_date) - julianday(p.dob))/365.25, 2)) as age_max  -- age at last dx
  ,count(v.visit_id)                                                  as visit_count
FROM patient as p
  left join visit as v on p.person_id = v.person_id
  WHERE gender = 'female'
  and 
  visit_date is not NULL
GROUP BY p.person_id, p.dob
ORDER BY age_max asc
;




-- Patient + Diagnoses
-- Q. What diagnosis appears to affect the oldest population (age at the time of diagnosis)
-- Q. What 

-- Patient + Visit
-- Q. What demographic group (sex, race, ethnicity) is the oldest at visit? 
-- Q. What provider serves the most diverse population in term of gender?
-- Q. What provider has the highest percent of non-white patients? 
-- Q. What is the id of the oldest patient in January of 2010? 

-- Three tables
-- Q. During what month of 2009 the most diagnoses where issued? 
-- Q. What month of observation has the most diverse body of diagnoses? (YYYY-MM)
-- Q. What provider sees patients with the highest number of diagnoses? 
-- Q. What care site sees the most patients who have diabetes? 
-- Q. What care site processes the most inpatient clients? 
-- Q. In what year there was the highest number of outpatient visits? 
-- Q. What is the most prevalent diagnosis (most unique patients)  of 2009? 




