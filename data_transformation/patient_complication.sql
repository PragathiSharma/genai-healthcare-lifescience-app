-- Databricks notebook source
use unitygo.diabetes_cure

-- COMMAND ----------

CREATE OR REPLACE TABLE patient_complication AS 
SELECT  
    patient, 
    CASE 
        WHEN description = 'Kidney Disease' THEN 'Sev 0' 
        WHEN description = 'Amputation' THEN 'Sev 1'
        WHEN description = 'Retinopathy' THEN 'Sev 2' 
        WHEN description = 'Neuropathy' THEN 'Sev 3' 
        WHEN description = 'Hyperglycemia' THEN 'Sev 4' 
        WHEN description = 'Proteinuria' THEN 'Sev 5' 
        WHEN description = 'Diabetes' THEN 'Sev 6' 
        WHEN description = 'Pre-Diabetes' THEN 'Sev 7' 
        ELSE description 
    END AS Severity FROM 
( 
SELECT  
    patient, 
    CASE  
        WHEN LOWER(description) LIKE '%neuropathy%' THEN 'Neuropathy' 
        WHEN LOWER(description) LIKE '%retinopathy%' THEN 'Retinopathy' 
        WHEN LOWER(description) LIKE '%nephropathy%' THEN 'Nephropathy' 
        WHEN LOWER(description) LIKE '%blindness%' THEN 'Blindness' 
        WHEN LOWER(description) LIKE '%photocoagulation%' THEN 'Photocoagulation' 
        WHEN LOWER(description) LIKE '%amputation%' THEN 'Amputation' 
        WHEN LOWER(description) LIKE '%ulcer%' THEN 'Diabetic Foot Ulcer' 
        WHEN LOWER(description) LIKE '%hyperglycemia%' THEN 'Hyperglycemia' 
        WHEN LOWER(description) LIKE '%microalbuminuria%' THEN 'Microalbuminuria' 
        WHEN LOWER(description) LIKE '%kidney%' THEN 'Kidney Disease' 
        WHEN LOWER(description) LIKE '%proteinuria%' THEN 'Proteinuria' 
        WHEN LOWER(description) LIKE '%prediabetes%' THEN 'Pre-Diabetes' 
        ELSE 'Diabetes' 
    END AS description, 
    ROW_NUMBER() OVER (PARTITION BY patient ORDER BY start DESC) AS rn 
FROM  
    patients 
JOIN  
    conditions ON patients.id = conditions.patient 
WHERE  
    LOWER(conditions.description) LIKE '%diabetes%' 
    OR LOWER(conditions.description) LIKE '%Diabetic%' 
    OR LOWER(conditions.description) LIKE '%Hyperglycemia%' 
    OR LOWER(conditions.description) LIKE '%Hypoglycemia%' 
    OR LOWER(conditions.description) LIKE '%neuropathy%' 
    OR LOWER(conditions.description) LIKE '%retinopathy%' 
    OR LOWER(conditions.description) LIKE '%nephropathy%' 
    OR LOWER(conditions.description) LIKE '%blindness%' 
    OR LOWER(conditions.description) LIKE '%photocoagulation%' 
    OR LOWER(conditions.description) LIKE '%amputation%' 
    OR LOWER(conditions.description) LIKE '%ulcer%' 
    OR LOWER(conditions.description) LIKE '%hyperglycemia%' 
    OR LOWER(conditions.description) LIKE '%microalbuminuria%' 
    OR LOWER(conditions.description) LIKE '%kidney%' 
    OR LOWER(conditions.description) LIKE '%proteinuria%' 
ORDER BY 
    patients.id, conditions.start 
) WHERE rn = 1 
