# Databricks notebook source
# Table names is parametrized in the pipeline
# allergies
# careplans
# claims
# claims_transactions
# conditions
# devices
# encounters
# imaging_studies
# immunizations
# medications
# observations
# organizations
# patients
# payer_transitions
# payers
# procedures
# providers
# supplies

# COMMAND ----------

table_name = dbutils.widgets.get("table_name")

# COMMAND ----------


source_data_path = "dbfs:/synthea-data/csv/"
target_table = "unitygo.diabetes_cure."+table_name
schema_location = "dbfs:/synthea-data/schemaLocation/"+table_name
checkpoint_location = "dbfs:/synthea-data/checkpoints/bronze_checkpoint_"+table_name
path_filter = table_name+".csv"

# COMMAND ----------


bronzeDF = spark.readStream.format("cloudFiles") \
    .option("cloudFiles.format", "csv") \
    .option("header", "true") \
    .option("pathGlobfilter", path_filter) \
    .option("cloudFiles.schemaLocation", schema_location) \
    .load(source_data_path)

# COMMAND ----------

(bronzeDF.writeStream
   .trigger(availableNow=True)
   .outputMode("append")
   .option("checkpointLocation", checkpoint_location)
   .toTable(target_table)
)
