-- Group 1: pt is in dx & visit
SELECT
  distinct
  p.person_id
  -- count(distinct p.person_id) as person_count
FROM patient p
  inner join dx    as d on p.person_id = d.person_id
  inner join visit as v on p.person_id = v.person_id;
  
-- Group 1 --alternate method
SELECT
  distinct
  p.person_id
  -- count(distinct p.person_id) as person_count
FROM patient p
  left  join dx    as d on p.person_id = d.person_id
  left  join visit as v on p.person_id = v.person_id
WHERE 
  d.dx_id   is not null
  and
  v.visit_id is not null

-- Group 2: pt is in dx but not visit
SELECT
  distinct
  p.person_id
FROM patient p
  inner join dx    as d on p.person_id = d.person_id
  left  join visit as v on p.person_id = v.person_id
WHERE v.visit_id is null;
  
-- Group 3: pt is in visit but not dx
SELECT
  --distinct
  --p.person_id
  *
FROM patient p
  left  join dx    as d on p.person_id = d.person_id
  inner join visit as v on p.person_id = v.person_id
WHERE d.dx_id is null;
  
-- Group 4: pt is missing from both dx & visit
SELECT
  distinct
  p.person_id
  -- count(distinct p.person_id) as person_count
FROM patient p
  left  join dx    as d on p.person_id = d.person_id
  left  join visit as v on p.person_id = v.person_id
WHERE 
  d.dx_id   is null
  and
  v.visit_id is null;
