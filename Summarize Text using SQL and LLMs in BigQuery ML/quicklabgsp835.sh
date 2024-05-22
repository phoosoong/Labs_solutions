

bq mk bq_llm

bq mk --connection --location=us --project_id=$DEVSHELL_PROJECT_ID \
    --connection_type=CLOUD_RESOURCE llm-connection

CONNECTION_NAME="$DEVSHELL_PROJECT_ID.us.llm-connection"
bq show --connection $CONNECTION_NAME > connection_details.json


SERVICE_ACCOUNT_ID=$(bq show --connection $CONNECTION_NAME | grep 'serviceAccountId' | awk -F\" '{print $4}')
export SERVICE_ACCOUNT_ID
echo "Service Account ID: $SERVICE_ACCOUNT_ID"

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_ID" \
  --role="roles/aiplatform.user"



bq query --use_legacy_sql=false \
"
CREATE OR REPLACE MODEL bq_llm.llm_model
  REMOTE WITH CONNECTION \`us.llm-connection\`
  OPTIONS (remote_service_type = 'CLOUD_AI_LARGE_LANGUAGE_MODEL_V1');
"



bq query --use_legacy_sql=false \
"
SELECT
  ml_generate_text_result['predictions'][0]['content'] AS generated_text,
  ml_generate_text_result['predictions'][0]['safetyAttributes']
    AS safety_attributes,
  * EXCEPT (ml_generate_text_result)
FROM
  ML.GENERATE_TEXT(
    MODEL \`bq_llm.llm_model\`,
    (
  SELECT
        CONCAT('Can you read the code in the following text and generate a summary for what the code is doing and what language it is written in:', content)
        AS prompt from \`bigquery-public-data.github_repos.sample_contents\`
          limit 5
    ),
    STRUCT(
      0.2 AS temperature,
      100 AS max_output_tokens));
"

