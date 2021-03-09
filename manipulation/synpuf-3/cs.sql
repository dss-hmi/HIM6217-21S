-- use omop_synpuf;
SELECT
   a.care_site_id
  ,b.concept_name  as place_of_service
FROM v5_2.care_site as a
left join v5_2.concept as b
on a.place_of_service_concept_id = b.concept_id
ORDER BY a.care_site_id


