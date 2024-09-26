-- Databricks notebook source
use unitygo.diabetes_cure

-- COMMAND ----------

CREATE OR REPLACE TABLE medication_mapping as
(
    SELECT DISTINCT description as Prescription, 
    regexp_replace(regexp_replace(AI_EXTRACT(description, ARRAY('medication name without dosage')).`medication name without dosage`, '[^a-zA-Z0-9]', '_'),'_+', '_') AS Active_Ingredients
    FROM 
    ( 
        SELECT DISTINCT description FROM medications 
    )
)
