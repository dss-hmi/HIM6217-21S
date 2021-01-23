-- Homework 2
-- All questions target the table `dx` in the database `synpuf_1`


--  1) How many records(rows) are in the `dx` table
-- Must use: count()
-- Output dimensions: 1x1



-- 2) How many unique patients are in the `dx` table? 
-- Must use: count()
-- Must NOT use: (*)
-- Output dimensions: 1x1
-- Output must contain columns: n_patients



-- 3) How many unique dates are in the `dx` table? 
-- Must use: count()
-- Must NOT use: (*)
-- Output dimensions: 1x1
-- Output must contain columns: n_unique_dates



-- 4) How many unique ICD9 codes are in the `dx` table? 
-- Must use: count()
-- Must NOT use: (*)
-- Output dimensions: 1x1
-- Output must contain columns: n_unique_icd9



-- 5) How many times either of two diagnoses 'Pain in neck' or 'Pain in limb' appear in the dx table?
-- Requirements:
-- Must use: count(), WHERE, IN
-- Output dimensions: 1x1




-- 6) How many distinct ICD-9 diagnoses include the word 'pain' in their description?
-- Requirements:
-- Must use: count(), distinct(), WHERE, LIKE
-- Output dimensions: 1x1
-- Output must contain columns: n_contain_pain



-- 7) How many distinct ICD-9 diagnoses begin with the word 'pain' in their description?
-- Requirements:
-- Must use: count(), distinct(), WHERE, LIKE
-- Output dimensions: 1x1
-- Output must contain columns: n_starts_with_patin




-- 8) What diagnosis code is most prevalent (i.e appears in the greatest number of records)? 
-- Requirements:
-- Must use: count(), as, GROUP BY, ORDER BY, LIMIT
-- Output dimensions: 1x3
-- Output contains columns: n_dx, icd9_code, icd9_description





-- 9) What is the greatest number of distinct patients with the same diagnosis? 
-- Requirements:
-- Must use: count(), distinct(), as, GROUP BY, ORDER BY, LIMIT
-- Must NOT use: WHERE
-- Output dimensions: 1x3
-- Output contains columns: n_patients, icd9_code, icd9_description



-- 10) What is the larger number of unique diagnoses (icd9_codes)  that can be observed in one person?
-- Requirements:
-- MUST USE: count(), DESC, LIMIT
-- Output dimensions: 1x2
-- Output must contain columns: person_id, n_unique_dx




-- 11) What is the largest number of non-unique diagnoses (icd9_codes) that can be observed in a single person?
-- Requirements:
-- MUST USE: count(), DESC, LIMIT
-- Output dimensions: 1x2
-- Output must contain columns: person_id, n_total_dx




-- 12) How many diagnoses (icd9_description) start with a letter 'A' and whose forth letter is 't'?
-- Requirements:
-- MUST use: like
-- Output dimensions: 1x1
-- Output must contain columns: n_1a_4t





-- 13) What is the icd9_code of the diagnosis with the longest label (icd9_description)
-- MUST use: length()
-- Output dimensions: 1x3
-- Output must contain columns: icd9_description, icd9_code, n_char
















