-- Homework 2
-- All questions target the table `dx` in the database `synpuf_1`


--  1) How many records(rows) are in the `dx` table
-- Must use: count()
-- Output dimensions: 1x1
SELECT count(*)
FROM dx
;

-- 2) How many unique patients are in the `dx` table? 
-- Must use: count()
-- Must NOT use: (*)
-- Output dimensions: 1x1
-- Output must contain columns: n_patients
SELECT count(distinct(person_id)) as n_patients
FROM dx
;


-- 3) How many unique dates are in the `dx` table? 
-- Must use: count()
-- Must NOT use: (*)
-- Output dimensions: 1x1
-- Output must contain columns: n_unique_dates
SELECT count(distinct(dx_date)) as n_unique_dates
FROM dx
;

-- 4) How many unique ICD9 codes are in the `dx` table? 
-- Must use: count()
-- Must NOT use: (*)
-- Output dimensions: 1x1
-- Output must contain columns: n_unique_icd9
SELECT count(distinct(icd9_code)) as n_unique_icd9
FROM dx
;

-- 5) How many times either of two diagnoses 'Pain in neck' or 'Pain in limb' appear in the dx table?
-- Requirements:
-- Must use: count(), WHERE, IN
-- Output dimensions: 1x1
SELECT count(*)
FROM dx
WHERE icd9_description IN (
  'Pain in neck', 'Pain in limb'
)
;

-- 6) How many distinct ICD-9 diagnoses include the word 'pain' in their description?
-- Requirements:
-- Must use: count(), distinct(), WHERE, LIKE
-- Output dimensions: 1x1
-- Output must contain columns: n_contain_pain
SELECT count(distinct(icd9_description)) as n_contain_pain
FROM dx
WHERE icd9_description LIKE '%pain%'
;

-- 7) How many distinct ICD-9 diagnoses begin with the word 'pain' in their description?
-- Requirements:
-- Must use: count(), distinct(), WHERE, LIKE
-- Output dimensions: 1x1
-- Output must contain columns: n_starts_with_patin
SELECT count(distinct(icd9_description)) as n_starts_with_patin
FROM dx
WHERE icd9_description LIKE 'pain%'
;


-- 8) What diagnosis code is most prevalent (i.e appears in the greatest number of records)? 
-- Requirements:
-- Must use: count(), as, GROUP BY, ORDER BY, LIMIT
-- Output dimensions: 1x3
-- Output contains columns: n_dx, icd9_code, icd9_description
SELECT count(*) as n_dx, icd9_code, icd9_description
FROM dx
GROUP BY icd9_code
ORDER BY n_dx desc
LIMIT 1
;



-- 9) What is the greatest number of distinct patients with the same diagnosis? 
-- Requirements:
-- Must use: count(), distinct(), as, GROUP BY, ORDER BY, LIMIT
-- Must NOT use: WHERE
-- Output dimensions: 1x3
-- Output contains columns: n_patients, icd9_code, icd9_description
SELECT count(distinct(person_id)) as n_patients, icd9_code, icd9_description
FROM dx
GROUP BY icd9_code
ORDER BY n_patients desc
LIMIT 1
;

-- 10) What is the larger number of unique diagnoses (icd9_codes)  that can be observed in one person?
-- Requirements:
-- MUST USE: count(), DESC, LIMIT
-- Output dimensions: 1x2
-- Output must contain columns: person_id, n_unique_dx
SELECT person_id, count(distinct(icd9_code)) as n_unique_dx
FROM dx
GROUP BY person_id
ORDER BY n_unique_dx DESC
LIMIT 1
;

-- 11) What is the largest number of non-unique diagnoses (icd9_codes) that can be observed in a single person?
-- Requirements:
-- MUST USE: count(), DESC, LIMIT
-- Output dimensions: 1x2
-- Output must contain columns: person_id, n_total_dx
SELECT person_id, count(icd9_code) as n_total_dx
FROM dx
GROUP BY person_id
ORDER BY n_total_dx DESC
LIMIT 1
;

-- 12) How many diagnoses (icd9_description) start with a letter 'A' and whose forth letter is 't'?
-- Requirements:
-- MUST use: like
-- Output dimensions: 1x1
-- Output must contain columns: n_1a_4t
SELECT count(distinct(icd9_description)) as n_1a_4t
FROM dx
WHERE icd9_description like 'A__t%'
;


-- 13) What is the icd9_code of the diagnosis with the longest label (icd9_description)
-- MUST use: length()
-- Output dimensions: 1x3
-- Output must contain columns: icd9_description, icd9_code, n_char
SELECT icd9_description,icd9_code,
length(icd9_description) as n_char
FROM dx
ORDER BY n_char DESC
LIMIT 1
;














