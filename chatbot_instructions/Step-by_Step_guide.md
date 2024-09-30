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

