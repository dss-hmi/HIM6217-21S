-- Exercise 1
-- All questions target the table `patient` in the database `synpuf-1`

-- 1.1 How many men are in the patient table?
-- Requirements:
---- Must use: count(), WHERE
---- Output dimensions: 1x1
SELECT count(*) 
FROM patient
WHERE gender = 'male'
;

-- 1.1 How many women are in the patient table? 
-- Requirements:
---- Must use: count(), WHERE
---- name the calculated field 'n_women'
---- Output dimensions: 1x1
SELECT count(*) as n_women
FROM patient
WHERE gender = 'female'
;

-- 1.1 Are there more men or women in the patient table?
-- Requirements:
---- Must use: count(), GROUP BY, ORDER BY
---- Must NOT use: WHERE
---- calculated field must be named 'n_patients'
---- Output dimensions: 2x2
---- The answer must be stored in the first row
SELECT  gender, count (*) as n_patients
FROM patient
GROUP BY gender
ORDER BY n_patients desc
;

-- 1.1 How many race categories are present in the patient table?
-- Requirements:
---- Must use: count(), distinct()
---- Output dimensions: 1x1
SELECT count(distinct(race))
FROM patient
;

-- 1.1 How many patients are in the largest race category?
-- Requirements:
---- Must use: distinct(), count(), GROUP BY, ORDER BY, LIMIT
---- Must NOT use: AS
---- Output dimensions: 1x2
SELECT  distinct(race), count(*)
FROM patient
GROUP BY race
ORDER BY count(*) desc
LIMIT 1
;

-- 1.1 How many patients are in the smallest ethnicity category?
-- Requirements:
---- Must use: distinct(), count(), GROUP BY, ORDER BY, LIMIT
---- calculated field must be named 'n_patients'
---- must return a single row
---- Output dimensions: 1x2
SELECT  distinct(ethnicity), count(*) as n_patients
FROM patient
GROUP BY ethnicity
ORDER BY n_patients asc
LIMIT 1
;


-- 1.1. How many white females are in the patient table? 
-- Requirements: 
---- MUST use: count(), WHERE 
---- calculated field must be named `n_patients`
---- include gender and race columns
---- Output dimensions: 1x3
SELECT gender, race, count(*) as n_patients
FROM patient
WHERE (gender = 'female') AND (race = 'white')
;


-- 1.1 How many non-white males are in the patient table?
-- Requirements: 
---- MUST use: count(), WHERE, != 
---- Output dimensions: 1x1
SELECT count(*) 
FROM patient
WHERE (gender = 'male') AND (race != 'white')
;

-- How many patients were born before 1936? 
-- Requirements:
---- Must use: count(), WHERE
---- Output dimensions: 1x1
SELECT count(*)
FROM patient
where dob < '1936-01-01'
;

-- 1.1 How many patients were born between 1930 and 1940 ? 
-- Requirements:
---- Must use: count(), WHERE, BETWEEN
---- Output dimensions: 1x1
SELECT count(*)
FROM patient
where dob BETWEEN '1930-01-01' AND '1939-12-31'
;

-- 1.1. How many non-white females were born prior to 1925?
-- Requirements:
---- Must use: count(), WHERE
---- Output dimensions: 1x1
SELECT count(*)
FROM patient
WHERE
  (gender = 'female' AND race != 'white')
  &
  (dob < '1925-01-01')
;
  
-- 1.1. How many white males were born after 1925?
-- Requirements:
---- Must use: count(), GROUP BY, AS
---- Must NOT use: WHERE
---- create a Boolean field named 'born_after_1925'
---- output must contain fields: gender, race, born_after_1925, n_patients
SELECT gender, race, dob > '1925-12-31' as born_after_1925, count(*) as n_patients
FROM patient
GROUP BY gender, born_after_1925
;










