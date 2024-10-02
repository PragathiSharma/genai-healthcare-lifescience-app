![image](/files/genAI_reference_images/DipBookCover.jpg)

## Diabetes complication classification based on patient medical history
### Chatbot
Databricks Data Intelligence Platform provides the intelligence to power the gen AI application. It is built on top of the Lakehouse architecture, so it has a strong foundation of supporting any size of workload and complex data transformation. In this chapter, we will look at the ability to create an application from ideation to creation, all within Databricks. While other platforms may come with similar tools in their ecosystem, Databricks’ tight integration allows us to stay on the same platform and collaborate closely with the team. 

![image](/files/genAI_reference_images/genAISampleArchitecture.jpg)

<b>Getting started</b>

Step 1: Data generation <br>
Follow along the steps in the notebook synthea_data_generator to set up patients data. The data generated would be under /dbfs/synthea-data/ folder. All of the different datasets such as allergies, careplans, claims, claims_transactions, conditions, devices, encounters, imaging_studies, immunizations, medications, observations, organizations, patients, payer_transitions, payers, procedures, providers, supplies are generated within the csv folder. If additional datasets needs to be added to any of these, ensure to keep the filenames unique by appending either state or timestamp to the filename so that autoloader can load incrementally. e.g., allergies_Alabama.csv and so on

Step 2: Data Ingestion <br>
Autoloader Set up - data_ingestion/autoloader_synthea_diabetic_data notebook can be used to ingest the data incrementally whenever there is a new data set. Later in the job, autoloader notebook is used for every dataset and that would help the data to be upto date.

Step 3: Data Transformation
These SQL statements are defined under data_transformation folder. The job is also configured to execute these notebooks once the ingestion is completed
- patient_a1c
- patient_complication
- medication_name_extraction
- patient_medication

Step 4: Above datasets combined to prepare training data using the notebook training-pipeline/diabetic-training-pipeline-notebook
Lineage of the training dataset can be view as below


![image](/files/genAI_reference_images/lineage.jpg)

<b>Databricks Asset bundles(DAB) for Deployment<b>

Step 2 through to Step 4 is automated to support continuous data ingestion using a workflow which can be deployed using Databricks DAB. 
Here are the instructions to set up.
- In the .github/workflows/cicd.yml, the bundle commands are executed to create the workflow. <br>
For this, when you clone the github repo, update the branch name , DATABRICKS_HOST and DATABRICKS_TOKEN to point to your workspace.
- The project contains configuration file databricks.yml to set up the environments. Set up the host and root_path as desired to deploy the contents of this repo into your workspace.   
- resources/synthea_diabetic_patient_data_ingestion.yml holds the job configuration.Ensure that the path for the notebooks are all correct.

<b>ML model for diabetes complication classification

Now that the training data, pipelines are all set up, next step is to build the Machine learning model for diabetes complication classification.
<br>Here you are use the AutoML to use the training dataset and choose Severity to run and create a suitable model. 
<br>Once the model is finalized, you will start to set up the chat bot using the instructions under chatbot_instructions/Step-by_Step_guide.md to deploy the Gen AI application.


Please bookmark this url, because it contains the best practices for this evolving topic for using AI Agent framework:
<br>https://ai-cookbook.io/  
