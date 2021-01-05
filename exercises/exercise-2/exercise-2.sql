-- Exercise 2
-- All questions target the table `dx` in the database `synpuf-1`


-- 1.1 How many records(rows) are in the `dx` table
---- Must use: count()
SELECT count(*)
FROM dx
;

-- 1.1 How many unique patients are in the `dx` table? 
---- Must use: count()
---- Must NOT use: (*)
---- Output dimensions: 1x1
SELECT count(distinct(person_id)) 
FROM dx
;

-- 1.1 How many unique dates are in the `dx` table? 
---- Must use: count()
---- Must NOT use: (*)
---- Output dimensions: 1x1
SELECT count(distinct(dx_date)) 
FROM dx
;

-- 1.1 How many unique ICD9 codes are in the `dx` table? 
---- Must use: count()
---- Must NOT use: (*)
---- Output dimensions: 1x1
SELECT count(distinct(icd9_code)) 
FROM dx
;

-- 1.1 What is the difference between the number of unique ICD-9 codes 
-- and the number of unique ICD-9 descriptions?
-- Requirements:
---- Must use: count(), distinct(), AS
---- Must NOT use: (*)
---- Output dimensions: 1x3
---- Output must contain three computed fields: `n_unique_codes`, `n_unique_descriptions`, `difference`
SELECT 
  count(distinct(icd9_code)) as n_unique_codes,
  count(distinct(icd9_description)) as n_unique_descriptions,
  count(distinct(icd9_code)) - count(distinct(icd9_description)) as difference
 FROM dx
;

-- Among ICD-9 descriptions that have more than one unique ICD-9 code associated with them
-- what ICD-9 description is the first when sorted in reverse alphabetical order?
-- Requirements:
---- Must use: count(), distinct(), AS, GROUP BY, HAVING, ORDER BY
---- Must NOT use: (*)
---- Output dimensions: ?x3
---- Output contains columns: icd9_codes, icd9_description, n_unique_codes
SELECT icd9_code, icd9_description, count(distinct(icd9_code)) as n_unique_codes
FROM dx
GROUP BY icd9_description
HAVING n_unique_codes > 1
ORDER BY icd9_description DESC
;


-- How many times either of two diagnoses 'Pain in neck' or 'Pain in limb' appear in the dx table?
-- Requirements:
---- Must use: count(), WHERE, IN
---- Output dimensions: 1x1
SELECT count(*)
FROM dx
WHERE icd9_description IN (
  'Pain in neck', 'Pain in limb'
)
;

-- How many distinct ICD-9 diagnoses include the word 'pain' in their description?
-- Requirements:
---- Must use: count(), distinct(), WHERE, LIKE
---- Output dimensions: 1x1
SELECT count(distinct(icd9_description))
FROM dx
WHERE icd9_description LIKE '%pain%'
;

-- How many distinct ICD-9 diagnoses begin with the word 'pain' in their description?
-- Requirements:
---- Must use: count(), distinct(), WHERE, LIKE
---- Output dimensions: 1x1
SELECT count(distinct(icd9_description))
FROM dx
WHERE icd9_description LIKE 'pain%'
;



