-- hmo-1 exercise

-- Step 1: create empty tables to hold patient & visit information
DROP TABLE if exists patient;
CREATE TABLE patient (
    patient_id INTEGER      PRIMARY KEY,
    name_first VARCHAR (25),
    name_last  VARCHAR (25),
    sex        VARCHAR (1),
    dob        DATE
);


DROP TABLE if exists visit;
CREATE TABLE visit (
  visit_id integer primary key,
  patient_id integer not null,
  visit_date date not null
);

-- Step 2: populate the tables from CSVs
--   Use the "Import Data" wizard build into SQLiteStudio
--   Point the wizard to these two csv files
--     1. "data-public/raw/hmo-1/hmo-1-patient.csv"
--     2. "data-public/raw/hmo-1/hmo-1-visit.csv"

-- Step 3: Query the database to answer each question.  Start a new sql script  by clicking "Open SQL editor" (alt + e)
-- 1. How many rows are in the visit table? (hint, execute `SELECT count(*) from visit`)
-- 2. How many patients are female? (hint, execute `SELECT count(*) FROM patient WHERE sex = 'F'`)
