-- Databricks notebook source
use unitygo.diabetes_cure

-- COMMAND ----------

CREATE OR REPLACE TABLE patient_a1c AS 
WITH agg_observations AS ( 

   SELECT  
    patient, 
    max(value) max_a1c, 
    avg(value) avg_a1c, 
    stddev(value) std_a1c     
  FROM  
    observations 
  WHERE  
    category = 'laboratory' 
    AND LOWER(description) LIKE '%a1c%' 
  group by patient 
) 
,filtered_observations AS ( 
  SELECT  
    patient, 
    date, 
    description, 
    value as current_value, 
    LEAD(value) OVER (ORDER BY date desc) AS previous_value, 
    ROW_NUMBER() OVER (PARTITION BY patient ORDER BY date DESC) AS rn 
  FROM  
    observations 
  WHERE  
    category = 'laboratory' 
    AND LOWER(description) LIKE '%a1c%'   
) 

SELECT  
  latest.*, 
  avg_a1c, 
  std_a1c, 
  max_a1c 
FROM  
  filtered_observations latest 
  JOIN agg_observations a ON latest.patient = a.patient 
WHERE rn = 1 

 
