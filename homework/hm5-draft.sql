


-- What is the average height of males at the their last visit? (Note that heigh may not have been recorded at their last visit.)

-- Verion 1: assuming a larger visit_id indicates a later visit (so we can ignore visit_date)
with person_visit_last as (
  SELECT
    p.person_id
    ,max(v.visit_id) as visit_id_last
  FROM patient p
    inner join visit v on p.person_id = v.person_id
  WHERE p.gender = 'male'
  GROUP BY p.person_id
)
,height as (
SELECT
  o.person_id
  ,round(o.value, 1)      as height_cm
  --,o.observation_id
  --,o.visit_id
FROM observation o
  inner join person_visit_last p on 
    o.person_id = p.person_id
    and
    o.visit_id = p.visit_id_last
WHERE key = 'height_cm'
GROUP BY o.person_id
)
,weight as (
SELECT
  o.person_id
  ,round(o.value, 1)      as weight_kg
  --,o.observation_id
  --,o.visit_id
FROM observation o
  inner join person_visit_last p on 
    o.person_id = p.person_id
    and
    o.visit_id = p.visit_id_last
WHERE key = 'weight_kg'
GROUP BY o.person_id
)
SELECT
  p.person_id
  ,p.visit_id_last
  ,h.height_cm
  ,w.weight_kg
FROM person_visit_last p
  left  join height h on p.person_id = h.person_id
  left  join weight w on p.person_id = w.person_id

;
-- What is the average height of males at the their known height observation? 
with person_visit_height_last as (
SELECT
  p.person_id
  ,max(v.visit_date) as visit_date_last
  --,*
  --,row_number() over (partition by p.person_id order by visit_date desc) as height_index
FROM patient p
  left  join visit       v on p.person_id = v.person_id
  left  join observation o on v.visit_id  = o.visit_id
WHERE 
  p.gender = 'male'
  and 
  key = 'height_cm'
  and
  value is not null
GROUP BY p.person_id
)


SELECT
  v.person_id
  ,v.visit_id
  ,round(avg(o.value), 1) as height_cm_mean --in case a visit has multiple height values
  --,row_number() over (partition by p.person_id order by visit_date desc) as height_index
FROM visit       v 
  inner join observation o on v.visit_id  = o.visit_id
  inner join person_visit_height_last pvh on
    v.person_id = pvh.person_id
    and
    v.visit_date = pvh.visit_date_last
WHERE 
  key = 'height_cm'
GROUP BY v.visit_id
-- What state has the oldest body of patients?
-- What provider works in the most states? 