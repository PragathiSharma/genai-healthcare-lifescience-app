# Databricks notebook source
# MAGIC %md
# MAGIC ## Step 0 - Setup environment variable
# MAGIC ###Important
# MAGIC
# MAGIC Set the environment variable `JNAME=zulu11-ca-amd64` and restart the cluster. For details on where to put this setting, please refer to the Databricks documentation.
# MAGIC
# MAGIC https://docs.databricks.com/en/compute/configure.html#environment-variables

# COMMAND ----------

# MAGIC %md
# MAGIC This notebook is ran using a single node cluster on Azure Databricks with VM Standard_D16ads_v5 to speed up the data generation process. While most examples provide static data, we provide the flexibility to dervie data of your own.
# MAGIC
# MAGIC First we will download the necessary software to build the Synthea Health application, it will generate the data in the Databricks file system for consumption.

# COMMAND ----------

# MAGIC %md
# MAGIC ## Step 1 - download the required files

# COMMAND ----------

# MAGIC %sh
# MAGIC cd
# MAGIC wget https://services.gradle.org/distributions/gradle-8.9-bin.zip
# MAGIC unzip gradle-8.9-bin.zip -d /opt/gradle
# MAGIC export PATH=$PATH:/opt/gradle/gradle-8.9/bin
# MAGIC rm -r ~/synthea
# MAGIC git clone https://github.com/synthetichealth/synthea.git

# COMMAND ----------

# MAGIC %md
# MAGIC Next, we build the Synthea program so we can generate the data, depending on the configuration of your VM, it can take up to 10 minutes for 1000 patients, the time will go up as the number of patients increase. That is only necessary if you want to try out more sample records.
# MAGIC
# MAGIC If you are facing errors in this step, please refer to step 0 and ensure the environment variable `JNAME=zulu11-ca-amd64` is configured.

# COMMAND ----------

# MAGIC %sh
# MAGIC cd ~/synthea
# MAGIC ./gradlew build

# COMMAND ----------

# MAGIC %md
# MAGIC ## Step 2 - Build the program and generate relevant data
# MAGIC The Synthea program by default generates data in the state of Massachusetts. We can use a shell script to generate data in different states.
# MAGIC
# MAGIC Furthermore, we are interested in the diabetes related records, that's why we are using the provided file `keep_diabetes.json`. If you want to customize yourself for other conditions, you can use the following tool and generate a new json file:
# MAGIC
# MAGIC https://synthetichealth.github.io/spt/#/customizer

# COMMAND ----------

# MAGIC %sh
# MAGIC cd ~/synthea
# MAGIC ./run_synthea -p 5000 -k src/main/resources/keep_modules/keep_diabetes.json --exporter.fhir.export=false --exporter.csv.export=true --exporter.baseDirectory=/dbfs/synthea-data/

# COMMAND ----------

# %sh
# cd ~/synthea

# states=(
#     "Alabama" "Alaska" "Arizona" "Arkansas" "California" "Colorado" "Connecticut" "Delaware"
#     "Florida" "Georgia" "Hawaii" "Idaho" "Illinois" "Indiana" "Iowa" "Kansas" "Kentucky"
#     "Louisiana" "Maine" "Maryland" "Massachusetts" "Michigan" "Minnesota" "Mississippi"
#     "Missouri" "Montana" "Nebraska" "Nevada" "New Hampshire" "New Jersey" "New Mexico"
#     "New York" "North Carolina" "North Dakota" "Ohio" "Oklahoma" "Oregon" "Pennsylvania"
#     "Rhode Island" "South Carolina" "South Dakota" "Tennessee" "Texas" "Utah" "Vermont"
#     "Virginia" "Washington" "West Virginia" "Wisconsin" "Wyoming"
# )

# # Change this number to increase or decrease the number of patients
# total_population=1000

# # Generate random distribution of population
# population_distribution=()
# remaining_population=$total_population
# num_states=${#states[@]}

# for (( i=0; i<$num_states-1; i++ )); do
#     # Randomly assign a population to each state, ensuring the remaining population is enough for the rest
#     population=$(( RANDOM % remaining_population + 1 ))
#     population_distribution+=($population)
#     remaining_population=$(( remaining_population - population ))
# done

# # Assign the remaining population to the last state
# population_distribution+=($remaining_population)

# # Generate the commands
# for (( i=0; i<$num_states; i++ )); do
#     state=${states[$i]}
#     population=${population_distribution[$i]}
#     ./run_synthea $state -p $population -k src/main/resources/keep_modules/keep_diabetes.json --exporter.fhir.export=false --exporter.csv.export=true --exporter.baseDirectory=/dbfs/${state}/synthea-data/
# done

# COMMAND ----------

 
#  ./run_synthea -p 1000 -k src/main/resources/keep_modules/keep_diabetes.json
