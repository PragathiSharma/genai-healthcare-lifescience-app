-- Databricks notebook source
-- MAGIC %sh cp /Workspace/Users/your_email_id/genai_app/genai-healthcare-lifescience-app/files/files/genAI_reference_images /dbfs/FileStore/

-- COMMAND ----------

-- MAGIC %sh 
-- MAGIC cp /Workspace/Users/your_email_id/genai_app/genai-healthcare-lifescience-app/files/synthea_sample_data/csv/ /dbfs/synthea-data/csv

-- COMMAND ----------


create catalog if not exists unitygo

-- COMMAND ----------


create schema if not exists diabetes_cure
