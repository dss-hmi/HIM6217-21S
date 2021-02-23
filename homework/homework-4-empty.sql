-- Homework 4
-- All questions target the database `synpuf_2`
-- Note 1: all patients found in `dx` and `visit` can be found in `patient`
-- Note 2: Some patients from `patient` are missing from `dx`, `visit`, or both  
-- Note 3: When asking about the "number of patients" it is implied that patients are unique
-- Note 4: the "MUST use" requirement may not contain ALL the necessary keywords to complete the task
-- Note 5: If not explicitly forbidden in "must NOT use" requirement, any keywords can be used
-- Note 5: The uniqueness of the diagnosis is defined by its icd9_code, not icd9_description (e.g. 234.9 and 234.99 are not the same)


-- 1) How many visits are observed in the care site with the most providers?
-- MUST use: count(), distinct, count(*)
-- Output dimensions: ?x3
-- Output must contain columns: `care_site_id`,'provider_id_count','visit_count'



-- 2) How many care sites does the busiest provider (physician) practice at? 
-- Hint: "busiest" defined as one with the most visits
-- MUST use: count(), distinct, count(*)
-- Output dimensions: ?x3
-- Output must contain columns: `provider_id`,'care_site_id_count','visit_count'


-- 3) How many providers practice at more than 1 care site?
-- MUST Use: subquery
-- MUST use: count(*), count, distinct, HAVING
-- Output dimensions: 1x1
-- Output must contain columns: `provider_count`


-- 4) What is the age of the oldest male patient at first diagnosis? 
-- Hint: calcualte the age of each patient at first diagnosis
-- Report age in years, rounded to two decimal places (`age_at_first_dx`)
-- Hint: divide the (difference in days between dob and date of first diagnosis) by 365.25 
-- Output dimensions: 1x5
-- Output must contain columns: `person_id`,`dob`,`dx_date`,`age_at_first_dx`,`dx_count`
-- MUST use: julianday(), min(), round()




-- 5) What is the age of the youngest female patient at last visit ? 
-- Hint: calcualte the age of each patient at last visit
-- Report age in years, rounded to two decimal places (`age_at_last_visit`)
-- Hint: divide the (difference in days between dob and date of last visit) by 365.25
-- Output dimensions: 1x5
-- Output must contain columns: `person_id`,`dob`,`visit_date`,`age_at_last_visit`,`visit_count`
-- MUST use: julianday(), max(), round()




-- 6) What is the average age of female patients at their last recorded visit? 
-- Hint: calcualte the age of each patient at last visit
-- Report age in years, rounded to 1 decimal place (`age_average_at_last_visit`)
-- Output dimensions: 1x1
-- Output must contain columns: `age_average_at_last_visit`
-- MUST use: subquery
-- MUST use: julianday(), max(), round(), avg()
-- Round `age_average_at_last_visit` to 1 decimal place

  


-- 7) What is the second most frequent diagnosis (icd9_description) for patients whose age at the time of diagnosis is 70+ years?
-- Hint: some patients might contribute multiple data points
-- Output dimensions: 1x3
-- Output must contain columns: `icd9_code`, `icd9_description`,`icd9_count`
-- MUST use: count(*), cast(), julianday(), LIMIT, OFFSET


-- 8) What month of observation has the most diverse body of diagnoses? (YYYY-MM)
-- Hint: "diverse" is defined as the larget number of unique diagnoses (icd9_code)
-- Hint: a month is defined as YYYY-MM value
-- Hint: use either `strftime()` (for SQLite only) or `substr()` (for SQLite or SQL Server)
-- MUST use: substr() OR strftime()
-- Output dimensions: x2
-- Output must contain columns: `visit_month`, `icd9_count`



-- 9) What care_site_id has the most distinct patients?  
-- Limit to patients born before 1960 that have at least one dx that includes the term "diabetes".  
-- Exclude visits with a missing care_site_id.
-- MUST use: count(), distinct, like
-- Output Dimensions: ?x4
-- Output must include columns: `care_site_id`,`patient_count`, `visit_count`,`provider_count`
-- The answer must appear in the first row


-- 10) What care_site_id has the most distinct visits? 
-- Limit to patients born before 1960 that have at least one dx that includes the term "diabetes".  
-- Exclude visits with a missing care_site_id.
-- MUST use: count(), distinct, like
-- Output Dimensions: ?x4
-- Output must include columns: `care_site_id`,`patient_count`, `visit_count`,`provider_count`
-- The answer must appear in the first row 


-- 11) What care_site_id has the most distinct providers? 
-- Limit to patients born before 1960 that have at least one dx that includes the term "diabetes".  
-- Exclude visits with a missing care_site_id.
-- MUST use: count(), distinct, like
-- Output Dimensions: ?x4
-- Output must include columns: `care_site_id`,`patient_count`, `visit_count`,`provider_count`
-- The answer must appear in the first row 



-- 12) In care sites with 50+ visits, what is the highest average patient age at visit?
-- Hint: first compute age at visit, then compute average 
-- Hint: a patient with three visits will be counted three times; a patient with one visit will be counted only once.
-- Hint: Round `patient_age_mean` to 2 decimal places
-- MUST use: avg(), julianday(), HAVING, count(*)
-- Output dimensions: ?x3
-- Output must contain columns: `care_site_id`, `patient_age_mean`,`visit_count`
