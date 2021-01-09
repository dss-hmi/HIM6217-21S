-- Exercise 1
-- All questions target the table `patient` in the database `./data-public/exercises/synpuf_1.sqlite3`
-- Please use SQLiteStudio to develop and test the queries.


-- How many rows are in the `patient` table
-- Requirements:
---- Must use: count()
---- Output dimensions: 1x1


-- How many unique patients are in the `patient` table? 
---- Must use: count()
---- Must NOT use: (*)
---- Output dimensions: 1x1


-- How many men are in the patient table?
-- Requirements:
---- Must use: count(), WHERE
---- Output dimensions: 1x1


-- How many women are in the patient table? 
-- Requirements:
---- Must use: count(), WHERE
---- name the calculated field 'n_women'
---- Output dimensions: 1x1

-- What value of gender is more prevalent in the patient table?
-- Requirements:
---- Must use: count(), GROUP BY, ORDER BY
---- Must NOT use: WHERE
---- calculated field must be named 'n_patients'
---- Output dimensions: 2x2
---- The answer must be stored in the first row


-- How many race categories are present in the patient table?
-- Requirements:
---- Must use: count(), distinct()
---- Output dimensions: 1x1

-- How many patients are in the largest race category?
-- Requirements:
---- Must use: distinct(), count(), GROUP BY, ORDER BY, LIMIT
---- Must NOT use: AS
---- Output dimensions: 1x2


-- How many patients are in the smallest ethnicity category?
-- Requirements:
---- Must use: distinct(), count(), GROUP BY, ORDER BY, LIMIT
---- calculated field must be named 'n_patients'
---- must return a single row
---- Output dimensions: 1x2



-- How many white females are in the patient table? 
-- Requirements: 
---- MUST use: count(), WHERE 
---- calculated field must be named `n_patients`
---- must include gender and race columns
---- Output dimensions: 1x3


-- How many non-white males are in the patient table?
-- Requirements: 
---- MUST use: count(), WHERE, != 
---- Output dimensions: 1x1

-- How many patients were born before 1946? 
-- Requirements:
---- Must use: count(), WHERE
---- Output dimensions: 1x1


-- How many patients were born between 1930 and 1940 ? 
-- Requirements:
---- Must use: count(), WHERE, BETWEEN
---- Output dimensions: 1x1


-- How many non-white females were born prior to 1945?
-- Requirements:
---- Must use: count(), WHERE
---- Output dimensions: 1x1

  
-- How many white males were born after 1925?
-- Requirements:
---- Must use: count(), GROUP BY, AS
---- Must NOT use: WHERE
---- create a Boolean field named 'born_after_1925'
---- output must contain fields: gender, race, born_after_1925, n_patients










