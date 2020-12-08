-- Exercise 1

SELECT 
  gender
  ,count (*) as patient_count
FROM patient
GROUP BY gender
ORDER BY gender; 