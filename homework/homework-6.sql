-- Homework 6
-- All questions target the database `synpuf_3`
-- All queries must be executable in SQL Server Microsoft Studio
-- You do not need to enter the answeres anywhere, you will be graded on the output of your queries

-- Homework 1;
-- 7) How many patients are in the largest race category?
-- Output dimensions: 1x2
SELECT 
DISTINCT TOP 1 p.race
,COUNT(*) AS person_count
FROM patient AS P
GROUP BY P.race
ORDER BY count(*) desc
;


-- 8) How many patients are in the smallest ethnicity category?
-- Output dimensions: 1x2
SELECT  distinct top  1 ethnicity, count(*) as n_patients
FROM patient
GROUP BY ethnicity
ORDER BY n_patients asc
;


-- 9) How many white females are in the patient table? 
-- must include gender and race columns
-- Output dimensions: 1x3
SELECT 
gender, race
, count(*) as n_patients
FROM patient
WHERE (gender = 'female') AND (race = 'white')
group by gender, race
;



-- 13) How many non-white females were born prior to 1945?
-- Output dimensions: 1x1
SELECT count(*) AS patient_count
FROM patient
WHERE
  (gender = 'female' AND race != 'white')
  AND
  (dob < '1945-01-01')
;

-- 14) How many white males were born after 1925?
-- output must contain fields: gender, race, patient_count
SELECT 
gender
,race
,count(*) as patient_count
FROM patient
WHERE dob > '1925-12-31' 
GROUP BY gender, race
;



-- Homework 2

-- 8) What diagnosis code is most prevalent (i.e appears in the greatest number of records)? 
-- Output dimensions: 1x3
-- Output contains columns: n_dx, icd9_code, icd9_description
SELECT top 1 count(*) as n_dx, icd9_code, icd9_description
FROM dx
GROUP BY icd9_code, icd9_description
ORDER BY n_dx desc
;


-- 9) What is the greatest number of distinct patients with the same diagnosis? 
-- Output dimensions: 1x3
-- Output contains columns: n_patients, icd9_code, icd9_description
SELECT top 1 count(distinct(person_id)) as n_patients, icd9_code, icd9_description
FROM dx
GROUP BY icd9_code, icd9_description
ORDER BY n_patients desc
;


-- 10) What is the larger number of unique diagnoses (icd9_codes)  that can be observed in one person?
-- Output dimensions: 1x2
-- Output must contain columns: person_id, n_unique_dx
SELECT top 1 person_id, count(distinct(icd9_code)) as n_unique_dx
FROM dx
GROUP BY person_id
ORDER BY n_unique_dx DESC
;


-- 13) What is the icd9_code of the diagnosis with the longest label (icd9_description)
-- Output dimensions: 1x3
-- Output must contain columns: icd9_description, icd9_code, n_char
SELECT top 1 icd9_description,icd9_code,
len(icd9_description) as n_char
FROM dx
ORDER BY n_char DESC
;



-- Homework 3

-- 12) What is the difference (in absolute value) between the number of persons in `patient` table
-- and the number of persons in the `dx` table?
-- Output dimensions: 1x3
-- Output must contain columns: `n_person_patient`, `n_person_dx`, `n_diff`
SELECT 
count(distinct(a.person_id)) as person_count_patient
,count(distinct(b.person_id)) as person_count_dx
,abs(count(distinct(b.person_id)) - count(distinct(a.person_id))) as difference_count
FROM patient as a
LEFT join dx as b on a.person_id = b.person_id
;



-- Homework 4

-- 4) What is the age of the oldest male patient at first diagnosis? 
-- Hint: calcualte the age of each patient at first diagnosis
-- Report age in years, rounded to two decimal places (`age_at_first_dx`)
-- Hint: divide the (difference in days between dob and date of first diagnosis) by 365.25 
-- Output dimensions: 1x5
-- Output must contain columns: `person_id`,`dob`,`age_at_first_dx`,`dx_count`
SELECT
  p.person_id
  ,p.dob
  ,min(round((datediff(day, p.dob,d.dx_date) )/365.25, 2)) as age_at_first_dx -- age at first dx
  ,count(d.dx_id)                                           as dx_count
FROM patient as p
  left join dx as d on p.person_id = d.person_id
  WHERE gender = 'male'
GROUP BY p.person_id, p.dob
ORDER BY age_at_first_dx desc
;

-- 5) What is the age of the youngest female patient at last visit ? 
-- Hint: calcualte the age of each patient at last visit
-- Report age in years, rounded to two decimal places (`age_at_last_visit`)
-- Hint: divide the (difference in days between dob and date of last visit) by 365.25
-- Output dimensions: 1x5
-- Output must contain columns: `person_id`,`dob`,`age_at_last_visit`,`visit_count`
SELECT
  p.person_id
  ,p.dob
  --,v.visit_date
  ,max(round((datediff(day, p.dob,v.visit_date))/365.25, 2)) as age_at_last_visit  -- age at last dx
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

-- 6) What is the average age of female patients at their last recorded visit? 
-- Hint: calcualte the age of each patient at last visit
-- Report age in years, rounded to 1 decimal place (`age_average_at_last_visit`)
-- Output dimensions: 1x1
-- Output must contain columns: `age_average_at_last_visit`
-- MUST use: WITH()
-- Round `age_average_at_last_visit` to 1 decimal place
with cte as (
   SELECT
      p.person_id
      ,p.dob
      --,v.visit_date
      ,max(( datediff(day, p.dob,v.visit_date) )/365.25) as age_max  -- age at last dx
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
  round(avg(age_max),1) as age_average_at_last_visit
FROM cte

-- 7) What is the second most frequent diagnosis (icd9_description) for patients whose age at the time of diagnosis is 70+ years?
-- Hint: some patients might contribute multiple data points
-- Output dimensions: 1x3
-- Output must contain columns: `icd9_code`, `icd9_description`,`icd9_count`
SELECT
  icd9_code
  ,icd9_description
  ,count(*)           as icd9_count
FROM dx d
  left  join patient pt on d.person_id = pt.person_id
WHERE 
  --70 <= cast(datediff(day, pt.dob,d.dx_date) / 365.25 as int)
   70 <= floor(datediff(day, pt.dob, d.dx_date) / 365.25)
GROUP BY icd9_code, icd9_description
ORDER BY count(*) desc
offset 1 rows
Fetch first 1 rows only;

- 8) What month of observation has the most diverse body of diagnoses? (YYYY-MM)
-- Hint: "diverse" is defined as the larget number of unique diagnoses (icd9_code)
-- Hint: a month is defined as YYYY-MM value
-- Output dimensions: x2
-- Output must contain columns: `visit_month`, `icd9_count`
SELECT
  substring(v.visit_date, 1, 7)       as visit_month_alt 
 ,count( distinct d.icd9_code) as icd9_count
FROM visit as v
left join dx as d
on v.person_id = d.person_id
group by substring(v.visit_date, 1, 7) 
order by icd9_count desc
;

-- 12) In care sites with 50+ visits, what is the highest average patient age at visit?
-- Hint: first compute age at visit, then compute average 
-- Hint: a patient with three visits will be counted three times; a patient with one visit will be counted only once.
-- Hint: Round `patient_age_mean` to 2 decimal places
-- Output dimensions: ?x3
-- Output must contain columns: `care_site_id`, `patient_age_mean`,`visit_count`
SELECT
  v.care_site_id
  ,round(avg(datediff(day, pt.dob, v.visit_date) /365.25),2) as patient_age_mean
  ,count(*)                                                           as visit_count
FROM visit v
  left  join patient pt on v.person_id = pt.person_id
GROUP BY v.care_site_id
HAVING 50 <= count(*) 
ORDER BY patient_age_mean desc
;
