-- Homework 3
-- All questions target the database `synpuf_2`
-- Note 1: all patients found in `dx` and `visit` can be found in `patient`
-- Note 2: Some patients from `patient` are missing from `dx`, `visit`, or both  
-- Note 3: When asking about the "number of patients" it is implied that patients are unique
-- Note 4: the "MUST use" requirement may not contain ALL the necessary keywords to complete the task
-- Note 5: If not explicitly forbidden in "must NOT use" requirement, any keywords can be used
-- Note 5: The uniqueness of the diagnosis is defined by its icd9_code, not icd9_description (e.g. 234.9 and 234.99 are not the same)

-- PART I

-- 1) How many patients can be observed in the `patient` table? 
-- Output dimensions: 1x1
-- Output must contain columns: `person_count`


-- 2) How many patients present in `dx` table are missing from `visit` table?
-- MUST use: IS NULL
-- Output dimensions: 1x1
-- Output must contain columns: `person_count`


-- 3) How many patients present in both `patient` and `dx` tables are missing from `visit` table?
-- MUST use: WHERE, LEFT JOIN, INNER JOIN
-- Output dimensions: 1x1
-- Output must contain columns: `person_count`


-- 4) How many patients present in `visit` table are missing from `dx` table?
-- Output dimensions: 1x1
-- Output must contain columns: `person_count`


-- 5) How many unique patients present in both `patient` and `visit` tables are missing from `dx` table?
-- Output dimensions: 1x1
-- Output must contain columns: `person_count`


-- 6) How many patients are present in all three tables?
-- MUST use: LEFT JOIN
-- must NOT use: INNER JOIN
-- Output dimensions: 1x1
-- Output must contain columns: `person_count`


-- 7) How many persons in `patient` table are missing from both `dx` and `visit` tables? 
-- MUST use: LEFT JOIN
-- must NOT use: INNER JOIN
-- Output dimensions: 1x1
-- Output must contain columns: `person_count`


-- PART II

-- 8) Among  patients in `dx` table who are missing from `visit` table, what `person_id` number is the smallest?
-- Write the query that lists patients present in `dx` but NOT in `visit` table
-- Sort by `person_id` found in the `visit` table
-- Output dimensions: ?x2
-- Output must include columns named: `person_id_dx`, `person_id_visit`


-- 9) Among patients in `visit` table who are missing from `dx` table, what `person_id` number is the smallest?
-- Hint 1: Write the query that lists patients present in `visit` but NOT in `dx` table
-- Hint 2: Sort by person_id found in the `dx` table
-- Output dimensions: ?x2
-- Output must include columns named: `person_id_visit`, `person_id_dx`


-- 10) Among patients missing from both `dx` and `visit` tables, what person_id number is the smallest?
-- Output dimensions: ?x3
-- Output must include columns named: `person_id_patient`, `dx_id`, `visit_id`


-- 11) Among patients present in all three tables, what person_id number is the smallest?
-- Output dimensions: ?x3
-- Output must include columns named: `person_id_patient`, `person_id_dx`, `person_id_visit`


-- PART III

-- 12) What is the difference (in absolute value) between the number of persons in `patient` table
-- and the number of persons in the `dx` table?
-- Output dimensions: 1x3
-- Output must contain columns: `n_person_patient`, `n_person_dx`, `n_diff`


-- 13) Speaking of patients observed in the `visit` table, 
-- What is the average number of visits per person? (rounded down to the nearest integer)
-- Output dimensions: 1x3
-- Output must include columns named `person_count`, `visit_count`, `visit_mean`


-- 14) What visit category has the highest average number of visits per patient? 
-- Hint: NULL is not a category
-- Output dimensions: 2x4
-- Output must contain columns:  `visit_category`, `person_count`, `visit_count`, `mean_visit_count`


-- 15) How many unique diagnosis codes can be observed in the `dx` table? 
-- Write the query that returns counts of unique values for each column
-- Output dimensions: 1x6
-- Output must contain columns: 
-- `dx_count`, `person_count`, `date_count`, `dx_code_count`, `dx_label_count`, `ipv_count`


-- 16) Write the query that returns unique `icd9_description`s that have multiple `icd9_code`s. 
-- What value of `icd9_description` appears in the first row when sorted alphabetically?
-- MUST use: HAVING
-- must NOT use: WHERE, LEFT JOIN, INNER JOIN
-- Output dimensions: ?x3
-- Output must include columns named `icd9_description`, `icd9_code`, `icd9_code_count`


-- 17) What is the average number of unique diagnoses (icd9_code) per patient in the `dx` table
-- (rounded down to the nearest integer)
-- Helper questions:
-- How many unique patients are in the `dx` table? 
-- How many unique diagnoses (codes) are in the `dx` table?
-- Output dimensions: 1x3
-- Output must contain columns:  `dx_count`,`person_count`, `mean_unique_dx`


-- 18) What is the average number of non-unique diagnoses (icd9_code) per patient in the `dx` table
-- (rounded down to the nearest integer)
-- Transitional questions (ones you must answer en route):
-- How many unique patients are in the `dx` table? 
-- How many non-unique diagnoses (icd9_code) are in the `dx` table?
-- Output dimensions: 1x3
-- Output must contain columns:   `dx_count`,`person_count`, `mean_dx`



-- PART IV

-- 19) How many NULL values does the column `race` contain? 
-- Write the query that counts the number of NULL values  in each column of the `patient` table
-- Must use: SUM, CASE WHEN, NULL
-- Must NOT use: COUNT, 
-- Output dimensions: 1x5
-- Output must contain columns:
-- `person_id_null_count`,`dob_null_count`,`gender_null_count`,`race_null_count`,`ethnicity_null_count`



-- 20) How many NULL values does the column `visit_category` contain? 
-- Write the query that counts the number of NULL values in each column of the `visit` table
-- Must use: COUNT
-- Must NOT use: SUM, CASE WHEN, NULL
-- Output dimensions: 1x6
-- Output must contain columns:
-- `visit_id_null_count`,`person_id_null_count`,`visit_category_null_count`,`visit_date_null_count`,`provider_id_null_count`,`care_site_id_null_count`


