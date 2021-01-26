-- Group 1: pt is in dx & visit
SELECT
  *
FROM patient
WHERE
  person_id in (SELECT distinct person_id FROM dx)
  and 
  person_id in (SELECT distinct person_id FROM visit);

-- Group 2: pt is in dx but not visit
SELECT
  *
FROM patient
WHERE
  person_id in (SELECT distinct person_id FROM dx)
  and 
  not person_id in (SELECT distinct person_id FROM visit);
  
-- Group 3: pt is in visit but not dx
SELECT
  *
FROM patient
WHERE
  not person_id in (SELECT distinct person_id FROM dx)
  and 
  person_id in (SELECT distinct person_id FROM visit);
  
-- Group 4: pt is missing from both dx & visit
SELECT
  *
FROM patient
WHERE
  not person_id in (SELECT distinct person_id FROM dx)
  and 
  not person_id in (SELECT distinct person_id FROM visit);
