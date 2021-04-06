-- Homework 6
-- All questions target the database `synpuf_3`
-- All queries must be executable in SQL Server Microsoft Studio
-- You do not need to enter the answeres anywhere, you will be graded on the output of your queries

-- Homework 1;
-- 7) How many patients are in the largest race category?
-- Output dimensions: 1x2


-- 8) How many patients are in the smallest ethnicity category?
-- Output dimensions: 1x2


-- 9) How many white females are in the patient table? 
-- must include gender and race columns
-- Output dimensions: 1x3


-- 13) How many non-white females were born prior to 1945?
-- Output dimensions: 1x1


-- 14) How many white males were born after 1925?
-- output must contain fields: gender, race, patient_count



-- Homework 2

-- 8) What diagnosis code is most prevalent (i.e appears in the greatest number of records)? 
-- Output dimensions: 1x3
-- Output contains columns: n_dx, icd9_code, icd9_description



-- 9) What is the greatest number of distinct patients with the same diagnosis? 
-- Output dimensions: 1x3
-- Output contains columns: n_patients, icd9_code, icd9_description


-- 10) What is the larger number of unique diagnoses (icd9_codes)  that can be observed in one person?
-- Output dimensions: 1x2
-- Output must contain columns: person_id, n_unique_dx



-- 13) What is the icd9_code of the diagnosis with the longest label (icd9_description)
-- Output dimensions: 1x3
-- Output must contain columns: icd9_description, icd9_code, n_char



-- Homework 3

-- 12) What is the difference (in absolute value) between the number of persons in `patient` table
-- and the number of persons in the `dx` table?
-- Output dimensions: 1x3
-- Output must contain columns: `n_person_patient`, `n_person_dx`, `n_diff`



-- Homework 4

-- 4) What is the age of the oldest male patient at first diagnosis? 
-- Hint: calcualte the age of each patient at first diagnosis
-- Report age in years, rounded to two decimal places (`age_at_first_dx`)
-- Hint: divide the (difference in days between dob and date of first diagnosis) by 365.25 
-- Output dimensions: 1x5
-- Output must contain columns: `person_id`,`dob`,`age_at_first_dx`,`dx_count`


-- 5) What is the age of the youngest female patient at last visit ? 
-- Hint: calcualte the age of each patient at last visit
-- Report age in years, rounded to two decimal places (`age_at_last_visit`)
-- Hint: divide the (difference in days between dob and date of last visit) by 365.25
-- Output dimensions: 1x5
-- Output must contain columns: `person_id`,`dob`,`age_at_last_visit`,`visit_count`


-- 6) What is the average age of female patients at their last recorded visit? 
-- Hint: calcualte the age of each patient at last visit
-- Report age in years, rounded to 1 decimal place (`age_average_at_last_visit`)
-- Output dimensions: 1x1
-- Output must contain columns: `age_average_at_last_visit`
-- MUST use: WITH()
-- Round `age_average_at_last_visit` to 1 decimal place


-- 7) What is the second most frequent diagnosis (icd9_description) for patients whose age at the time of diagnosis is 70+ years?
-- Hint: some patients might contribute multiple data points
-- Output dimensions: 1x3
-- Output must contain columns: `icd9_code`, `icd9_description`,`icd9_count`


-- 8) What month of observation has the most diverse body of diagnoses? (YYYY-MM)
-- Hint: "diverse" is defined as the larget number of unique diagnoses (icd9_code)
-- Hint: a month is defined as YYYY-MM value
-- Output dimensions: x2
-- Output must contain columns: `visit_month`, `icd9_count`


-- 12) In care sites with 50+ visits, what is the highest average patient age at visit?
-- Hint: first compute age at visit, then compute average 
-- Hint: a patient with three visits will be counted three times; a patient with one visit will be counted only once.
-- Hint: Round `patient_age_mean` to 2 decimal places
-- Output dimensions: ?x3
-- Output must contain columns: `care_site_id`, `patient_age_mean`,`visit_count`
