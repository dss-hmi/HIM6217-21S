-- Homework 3
-- All questions target the database `synpuf_2`

-- Requirements:
-- Must use: count(), distinct(), WHERE, LIKE
-- Must NOT use: 
-- Output dimensions: 1x1
-- Output must contain columns: n_contain_pain


--  1)

SELECT count(*) as n_row
FROM patient
INNER JOIN dx
on patient.person_id = dx.person_id
;

-- 1) How many more patients in `dx` than in `patient` table?
-- Requirements:
-- Must use: count(), distinct()
-- Output dimensions: 1x3
-- Output must contain columns: n_person_patient, n_person_dx, n_diff
SELECT 
count(distinct(a.person_id)) as n_person_patient,
count(distinct(b.person_id)) as n_person_dx,
count(distinct(a.person_id)) - count(distinct(b.person_id)) as n_diff
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



SELECT 
   distinct(patient.person_id) as person_id_patient
   , dx.person_id as person_id_dx
   ,visit.person_id as person_id_visit
FROM patient
left join dx ON patient.person_id = dx.person_id
left join visit on patient.person_id = visit.person_id
ORDER BY person_id_patient desc
;


-- Create a table listing the 
SELECT 
     distinct(dx.person_id) as person_id_dx
    ,patient.person_id as person_id_patient
FROM dx
left join patient
ON patient.person_id = dx.person_id
ORDER BY person_id_patient desc
;

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

SELECT distinct(dx.person_id) as person_id, patient.gender
FROM dx
LEFT JOIN patient
ON dx.person_id = patient.person_id
WHERE dx.inpatient_visit = 1 and patient.gender is null
ORDER BY person_id DESC
;
