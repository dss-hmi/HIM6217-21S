-- Homework 2
-- All questions target the table `dx` in the database `synpuf_1`


--  1) How many records(rows) are in the `dx` table
---- Must use: count()
SELECT count(*)
FROM dx
;

-- 2) How many unique patients are in the `dx` table? 
---- Must use: count()
---- Must NOT use: (*)
---- Output dimensions: 1x1
SELECT count(distinct(person_id)) 
FROM dx
;

-- 3) How many unique dates are in the `dx` table? 
---- Must use: count()
---- Must NOT use: (*)
---- Output dimensions: 1x1
SELECT count(distinct(dx_date)) as n_unique_dates
FROM dx
;

-- 4) How many unique ICD9 codes are in the `dx` table? 
---- Must use: count()
---- Must NOT use: (*)
---- Output dimensions: 1x1
SELECT count(distinct(icd9_code)) as n_unique_icd9
FROM dx
;

-- 5) How many times either of two diagnoses 'Pain in neck' or 'Pain in limb' appear in the dx table?
-- Requirements:
---- Must use: count(), WHERE, IN
---- Output dimensions: 1x1
SELECT count(*)
FROM dx
WHERE icd9_description IN (
  'Pain in neck', 'Pain in limb'
)
;

-- 6) How many distinct ICD-9 diagnoses include the word 'pain' in their description?
-- Requirements:
---- Must use: count(), distinct(), WHERE, LIKE
---- Output dimensions: 1x1
SELECT count(distinct(icd9_description))
FROM dx
WHERE icd9_description LIKE '%pain%'
;

-- 7) How many distinct ICD-9 diagnoses begin with the word 'pain' in their description?
-- Requirements:
---- Must use: count(), distinct(), WHERE, LIKE
---- Output dimensions: 1x1
SELECT count(distinct(icd9_description))
FROM dx
WHERE icd9_description LIKE 'pain%'
;


-- 8) What diagnosis code is most prevalent (i.e appears in the greatest number of records)? 
---- Requirements:
---- Must use: count(), as, GROUP BY, ORDER BY, LIMIT
---- Output dimensions: 1x3
---- Output contains columns: freq, icd9_code, icd9_description
SELECT count(*) as freq, icd9_code, icd9_description
FROM dx
GROUP BY icd9_code
ORDER BY freq desc
LIMIT 1
;



-- 9) How many patients have the most prevalent diagnosis code? 
---- Requirements:
---- Must use: count(), distinct(), as, GROUP BY, ORDER BY, LIMIT
---- Must NOT use: WHERE
---- Output dimensions: 1x3
---- Output contains columns: freq, icd9_code, icd9_description
SELECT count(distinct(person_id)) as freq, icd9_code, icd9_description
FROM dx
GROUP BY icd9_code
ORDER BY freq desc
LIMIT 1
;




















