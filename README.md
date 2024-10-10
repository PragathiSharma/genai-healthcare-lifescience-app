![image](/files/genAI_reference_images/DipBookCover.jpg)

## Diabetes complication classification based on patient medical history
### Chatbot
Databricks Data Intelligence Platform provides the intelligence to power the gen AI application. It is built on top of the Lakehouse architecture, so it has a strong foundation of supporting any size of workload and complex data transformation. In this chapter, we will look at the ability to create an application from ideation to creation, all within Databricks. While other platforms may come with similar tools in their ecosystem, Databricks’ tight integration allows us to stay on the same platform and collaborate closely with the team. 

![image](/files/genAI_reference_images/genAISampleArchitecture.jpg)

<b>Getting started</b>

Here are the instructions to set up this project.

Prerequisites:

Github account - sign up for a new github account if not already present.</br>
  >Generate Github token - In the Settings, Navigate to Developer Settings -> Personal access tokens -> generate new token. </br>
  You can set the expiration to 30 days or more if needed. Either Fine grained token/ tokens(classic) would work. </br>
  >>Fine grained token - Select All repositories, select access level read and write to these : Actions, Workflows, Secrets </br>
  >>Tokens(classic) - Select the repo, workflow scope while generating</br>

><b>Copy the token value and save it as it would appear only once. </b>

Databricks workspace access - Sign up for the Community edition. </br>
>Login and Generate token in the databricks to be able to deploy code from Github to the workspace.
  </br>1. Head to Settings -> Developer - Access Tokens -> Manage -> Generate new token . You can give any comment and keep Lifetime 90 which is default.
  </br><b>Copy the token value and save it as it would appear only once. </b></br>
2. In the Same Settings page, select Linked accounts - Select Git provider as Github, select Personal Access token and key in the email and token with read/write permissions generated earlier in Github. This would enable the Databricks Repos section accessible to Github.

If you have completed the prerequisites, Clone this repo into your own github account. 

Here are some commands to run from terminal
> git clone https://github.com/PragathiSharma/genai-healthcare-lifescience-app.git </br>
cd genai-healthcare-lifescience-app</br>
git remote remove origin</br>
git remote add origin https://github.com/PragathiSharma/my_genai_app.git

- The project contains configuration file databricks.yml to set up the environments. Set up the host and root_path as desired to deploy the contents of this repo into your workspace.   

    host: https://myworkspace.databricks.com - Update this to your databricks workspace url
    root_path: ~/genai_app/genai-healthcare-lifescience-app - Update this to the path where you want to deploy the project

    Based on environments, this configurations needs to be updated for each environment.

- In the .github/workflows/cicd.yml, the bundle commands are executed to create the workflow. <br>
For this, update the DATABRICKS_HOST and DATABRICKS_TOKEN to point to your workspace.


<b>Databricks Asset bundles(DAB) for Deployment</b>
</br> git commit -m "updated tokens"
</br>git push -u origin main

Committing code would get the entire project deployed and job created in the workspace.
- resources/synthea_diabetic_patient_data_ingestion.yml holds the job configuration.Ensure that the path for the notebooks are all correct.

Now that all the set up is completed, we can execute the project. 

Step 1: Data generation <br>
Follow along the steps in the notebook synthea_data_generator to set up patients data. The data generated would be under /dbfs/synthea-data/ folder. All of the different datasets such as allergies, careplans, claims, claims_transactions, conditions, devices, encounters, imaging_studies, immunizations, medications, observations, organizations, patients, payer_transitions, payers, procedures, providers, supplies are generated within the csv folder. If additional datasets needs to be added to any of these, ensure to keep the filenames unique by appending either state or timestamp to the filename so that autoloader can load incrementally. e.g., allergies_Alabama.csv and so on

Trigger the job manually. That would cover the steps 2- 4

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

<b>ML model for diabetes complication classification

Now that the training data, pipelines are all set up, next step is to build the Machine learning model for diabetes complication classification.
<br>Here you are use the AutoML to use the training dataset and choose Severity to run and create a suitable model. 
<br>Once the model is finalized, you will start to set up the chat bot using the instructions under chatbot_instructions/Step-by_Step_guide.md to deploy the Gen AI application.


Please bookmark this url, because it contains the best practices for this evolving topic for using AI Agent framework:
<br>https://ai-cookbook.io/  
