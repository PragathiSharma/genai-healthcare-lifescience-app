-- Databricks notebook source
use unitygo.diabetes_cure

-- COMMAND ----------

CREATE OR REPLACE TABLE diabetes_training_prag
COMMENT "The diabetes training dataset created combining all the patient tables together."
AS
SELECT 
  a.patient,
  a.date,
  a.description,
  a.current_value,
  a.previous_value,
  a.rn,
  a.avg_a1c,
  a.std_a1c,
  c.Severity,
  m.* EXCEPT (patient)
FROM patient_a1c a
LEFT JOIN patient_complication c
  ON a.patient = c.patient
LEFT JOIN patient_medication m
  ON a.patient = m.patient
