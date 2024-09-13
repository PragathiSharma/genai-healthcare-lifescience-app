# Databricks notebook source
# MAGIC %sql
# MAGIC use unitygo.diabetes_cure

# COMMAND ----------

descriptions = [row['desc'] for row in spark.sql("SELECT DISTINCT LOWER(Active_Ingredients) as desc FROM medications m join medication_mapping mm on m.description = mm.Prescription").collect()] 

# COMMAND ----------

# Constructing the dynamic part of the pivot query 
pivot_clause = ", ".join([f"'{desc}'" for desc in descriptions]) 

# Constructing the full query 

query = f""" 
SELECT * 
FROM ( 
  SELECT  
    m.patient, 
    INLINE( 
      COLLECT_LIST( 
        NAMED_STRUCT( 
          'description', LOWER(Active_Ingredients), 
          'stop', CASE 
                    WHEN m.STOP IS NULL THEN '1' 
                    ELSE '0' END 
        ) 
      ) 
    ) AS (description, stop)  
  FROM  
    medications m  
    JOIN medication_mapping mm on m.description = mm.Prescription 
  GROUP BY  
    m.PATIENT 
    ) AS subquery 
PIVOT ( 
  MAX(stop) 
  FOR description IN ({pivot_clause}) 
) 
""" 

spark.sql(f"""Create or replace table patient_medication as {query}""")

