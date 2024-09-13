-- Databricks notebook source
use unitygo.diabetes_cure

-- COMMAND ----------

CREATE VIEW patient_report 
AS
WITH encounter_latest AS 
( 
    SELECT  
        *, 
        ROW_NUMBER() OVER (PARTITION BY patient ORDER BY start DESC) AS rn 
    FROM encounters e  
), 
observations_new AS 
( 
    SELECT 
        DISTINCT 
        patient, 
        encounter, 
        category, 
        (CASE  
            WHEN LOWER(description) LIKE '%cholesterol%' THEN 'cholesterol' 
            WHEN LOWER(description) LIKE '%blood%pressure%' THEN 'BP' 
            ELSE description END) AS description_aliAS 
    FROM 
        observations 
) 
SELECT o.Name AS OrganizationName, o.City AS OrganizationCity, 
    COUNT(DISTINCT e.patient) AS Count_of_Patients,  
    COUNT(DISTINCT encounter) AS Count_of_Encounters, 
    SUM( CASE WHEN category = 'laboratory' AND LOWER(s.description_aliAS) LIKE '%albumin%' THEN 1 ELSE 0 END ) AS Count_of_Albumin, 
    SUM( CASE WHEN category = 'vital-signs' AND LOWER(s.description_aliAS) LIKE '%bmi%' THEN 1 ELSE 0 END ) AS Count_of_BMI, 
    SUM( CASE WHEN category = 'vital-signs' AND LOWER(s.description_aliAS) LIKE '%blood%pressure%' THEN 1 ELSE 0 END ) AS Count_of_BP, 
    SUM( CASE WHEN category = 'laboratory' AND LOWER(s.description_aliAS) LIKE '%cholesterol%' THEN 1 ELSE 0 END ) AS Count_of_Cholesterol, 
    SUM( CASE WHEN LOWER(s.description_aliAS) LIKE '%foot%' THEN 1 ELSE 0 END ) AS Count_of_Foot_exam, 
    SUM( CASE WHEN category = 'laboratory' AND LOWER(s.description_aliAS) LIKE '%a1c%' THEN 1 ELSE 0 END ) AS Count_of_HbA1C, 
    SUM( CASE WHEN category = 'social-history' AND LOWER(s.description_aliAS) LIKE '%smoking%' THEN 1 ELSE 0 END ) AS Count_of_Smoking 
FROM encounter_latest e  
JOIN observations_new s ON e.id = s.encounter 
JOIN organizations o ON e.organization = o.id 
WHERE e.patient IN (SELECT patient FROM diabetes_training_prag) AND e.rn = 1 
GROUP BY o.Name, o.City 

-- COMMAND ----------


