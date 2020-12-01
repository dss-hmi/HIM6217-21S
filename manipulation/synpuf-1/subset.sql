-- use omop_synpuf;
SELECT
  TOP (20)
  p.person_id
  ,datefromparts(p.year_of_birth, p.month_of_birth, p.day_of_birth) as dob
  ,lower(c_gender.concept_name)                                     as gender
  ,case
    when p.race_concept_id = 0 then null
    else lower(c_race.concept_name  )
  end                                                               as race
  ,case
    when p.ethnicity_concept_id = 0 then null
    else lower(c_ethnicity.concept_name  )
  end                                                               as ethnicity
FROM v5_2.person as p
  left  join v5_2.concept as c_gender    on p.gender_concept_id      = c_gender.concept_id
  left  join v5_2.concept as c_race      on p.race_concept_id        = c_race.concept_id
  left  join v5_2.concept as c_ethnicity on p.ethnicity_concept_id   = c_ethnicity.concept_id
ORDER BY person_id
