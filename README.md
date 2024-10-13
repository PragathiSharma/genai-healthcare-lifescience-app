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
  >>Fine grained token - Select All repositories, Read and Write access to actions, code, commit statuses, deployments, secrets, and workflows </br>
  >>Tokens(classic) - Select the repo, workflow scope while generating</br>

><b>Copy the token value and save it as it would appear only once. </b>

Databricks workspace access - Sign up for the Community edition. </br>
>Login and Generate token in the databricks to be able to deploy code from Github to the workspace.
  </br>1. Head to Settings -> Developer - Access Tokens -> Manage -> Generate new token . You can give any comment and keep Lifetime 90 which is default.
  </br><b>Copy the token value and save it as it would appear only once. </b></br>
2. In the Same Settings page, select Linked accounts - Select Git provider as Github, select Personal Access token and key in the email and token with read/write permissions generated earlier in Github. This would enable the Databricks Repos section accessible to Github.

In the Github Repo Settings, Add the Repository Tokens to save the databricks host and token as shown 
> DATABRICKS_HOST - url for the datarbricks workspace </br>
> DATABRICKS_TOKEN - token generated in the databricks workspace 

![image](/files/genAI_reference_images/githubSecrets.jpg )

If you have completed the prerequisites, Clone this repo into your own github account. 

Here are some commands to run from terminal
> git clone https://github.com/PragathiSharma/genai-healthcare-lifescience-app.git </br>
cd genai-healthcare-lifescience-app</br>
git remote set-url origin http://github.com/YOU/YOUR_REPO  

<br>/YOU/YOUR_REPO - Create a new empty repo in Github and provide the username and repo name here.

- The project contains configuration file databricks.yml to set up the environments. Set up the host and root_path as desired to deploy the contents of this repo into your workspace.   

    host: https://myworkspace.databricks.com - Update this to your databricks workspace url </br>
    root_path: ~/genai_app/genai-healthcare-lifescience-app - Update this to the path where you want to deploy the project <br>

    Based on environments, this configurations can be updated for each environment.

    resources/synthea_diabetic_patient_data_ingestion.yml holds the job configuration which is pipeline for data ingestion and model training.
    Ensure that the path for the notebooks are all correct. 
    <br>Replace your_email_id with your email id on the databricks workspace so the path would be picked up correctly.

    The job would work with notebook paths as /Workspace/Users/your_email_id/genai_app/genai-healthcare-lifescience-app 

- In the .github/workflows/cicd.yml, the bundle commands are executed to create the workflow. <br>
For this, DATABRICKS_HOST and DATABRICKS_TOKEN configs are picked up from the github actions secrets saved in the prerequisites


<b>Databricks Asset bundles(DAB) for Deployment</b>

Once you commit the configuration updates into your repo, You can manually go and trigger github Actions workflow to deploy the project and job to databricks workspace.

</br> git commit -m "updated tokens"
</br>git push -u origin main

Trigger Github Actions
![image](/files/genAI_reference_images/githubActions.jpg)


Now that all the set up is completed, we can execute the project. 

Step 1: Data generation <br>
For this Step 1, you could use the data already present in the repo or generate new data for larger datasets.

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
<br>Once the model is finalized, you will start to set up the chat bot using below instructions which are also placed under chatbot_instructions/Step-by_Step_guide.md to deploy the Gen AI application.

Upload the relevant pdfs to a volume in Unity Catalog. This step can be done easily via the user interface.

![image](/files/genAI_reference_images/pdfs.jpg)

The below are the prerequisites we need to leverage AI Agent framework, which can be setup via the user interface:
- 	Unity Catalog and Schema : for storing the parsed / chucked documents
- 	Vector Search Endpoint :either a new endpoint or an existing
- 	UC Volume:  a volume must be created using command and then the documents can be uploaded
- 	Foundation Model API is accessible for embedding calculation
- 	MLflow experiment is accessible for model and metric logging

1. Verify all the permissions above, and deploy something if you are not sure

2.	Clone the below repo from Databricks into repo:
https://github.com/databricks/genai-cookbook/

3.	Fill in the config in rag_app_sample_code/00_global_config. If you have followed the above prerequisites, you should not have any problems filling in the details, but a couple of details that are extremely important not to miss and can be found in the user interface, including:

a.	VECTOR_SEARCH_ENDPOINT, which can be found from the Compute tab:

![image](/files/genAI_reference_images/vector_search_endpoint.jpg)

b.	Volume can be found under the database of a Catalog

![image](/files/genAI_reference_images/volume.jpg)

4.	To verify everything is set up correctly, run 01_validate_config in the corresponding folder of the file type of your choice. For example, for pdf files,they can be found at the following location: 
/genai-cookbook/rag_app_sample_code/A_POC_app/pdf_uc_volume/01_validate_config

If everything passes, you will see a print message at the end of each cell:

![image](/files/genAI_reference_images/successful.jpg)

5.	Run 02_poc_data_pipeline, and the result is the experiment being logged in the Experiments tab.

![image](/files/genAI_reference_images/experiment.jpg)

6.	Run 03_deploy_poc_to_review_ap. It will deploy an application for you, and you can ask questions about your use case. You will notice the relevant document is being referenced in the chat, as we can see below:

![image](/files/genAI_reference_images/chatbot.jpg)

7.	Congratulations, you have successfully deployed a chatbot, but the story does not end here.

- 	04_create_evaluation_set, allows you to create an evaluation dataset. If you know some of the answers that might come from the pdf that you uploaded, you can setup this evaluation dataset so AI Agent framework can evaluate the accuracy of the output

- 	05_evaluate_poc_quality, run this notebook to evaluate the application

8.	Databricks has made the process very easy. Please head over to “RAG quality knobs” section of the GenAI cookbook: https://ai-cookbook.io/nbs/3-deep-dive.html, that’s where you will learn more about the underlying process of building a RAG application so your application will be future-proof.

Please bookmark this url, because it contains the best practices for this evolving topic for using AI Agent framework:
<br>https://ai-cookbook.io/  
