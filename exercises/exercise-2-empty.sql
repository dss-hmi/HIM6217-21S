-- Exercise 2
-- All questions target the table `dx` in the database `./data-public/exercises/synpuf-1.sqlite3`
-- Please use SQLiteStudio to develop and test the queries.


--  How many records(rows) are in the `dx` table
---- Must use: count()


-- How many unique patients are in the `dx` table? 
---- Must use: count()
---- Must NOT use: (*)
---- Output dimensions: 1x1


-- How many unique dates are in the `dx` table? 
---- Must use: count()
---- Must NOT use: (*)
---- Output dimensions: 1x1


-- How many unique ICD9 codes are in the `dx` table? 
---- Must use: count()
---- Must NOT use: (*)
---- Output dimensions: 1x1


-- What is the difference between the number of unique ICD-9 codes 
-- and the number of unique ICD-9 descriptions?
-- Requirements:
---- Must use: count(), distinct(), AS
---- Must NOT use: (*)
---- Output dimensions: 1x3
---- Output must contain three computed fields: `n_unique_codes`, `n_unique_descriptions`, `difference`


-- Among ICD-9 descriptions that have more than one unique ICD-9 code associated with them
-- what ICD-9 description appears in the first row when sorted in reverse alphabetical order?
-- Requirements:
---- Must use: count(), distinct(), AS, GROUP BY, HAVING, ORDER BY
---- Must NOT use: (*)
---- Output dimensions: ?x3
---- Output contains columns: icd9_codes, icd9_description, n_unique_codes



-- How many times either of two diagnoses 'Pain in neck' or 'Pain in limb' appear in the dx table?
-- Requirements:
---- Must use: count(), WHERE, IN
---- Output dimensions: 1x1


-- How many distinct ICD-9 diagnoses include the word 'pain' in their description?
-- Requirements:
---- Must use: count(), distinct(), WHERE, LIKE
---- Output dimensions: 1x1

-- How many distinct ICD-9 diagnoses begin with the word 'pain' in their description?
-- Requirements:
---- Must use: count(), distinct(), WHERE, LIKE
---- Output dimensions: 1x1


-- What diagnosis code is most prevalent (i.e appears in the greatest number of records)? 
---- Requirements:
---- Must use: count(), as, GROUP BY, ORDER BY, LIMIT
---- Output dimensions: 1x3
---- Output contains columns: freq, icd9_code, icd9_description



-- How many patients have the most prevalent diagnosis code? 
---- Requirements:
---- Must use: count(), distinct(), as, GROUP BY, ORDER BY, LIMIT
---- Must NOT use: WHERE
---- Output dimensions: 1x3
---- Output contains columns: freq, icd9_code, icd9_description




















