
# set up
gcloud config set compute/region us-east4

# Task 1: enable the api
gcloud services enable texttospeech.googleapis.com --project=$DEVSHELL_PROJECT_ID

# Task 2: Create a virtual environment
sudo apt-get install -y virtualenv

python3 -m venv venv

source venv/bin/activate

# Task 3. Create a service account
gcloud iam service-accounts create tts-qwiklab

export PROJECT_ID=$(gcloud config get-value project)

gcloud iam service-accounts keys create tts-qwiklab.json --iam-account tts-qwiklab@$PROJECT_ID.iam.gserviceaccount.com

export GOOGLE_APPLICATION_CREDENTIALS=tts-qwiklab.json

# Below task are not required to Pass the lab
# Task 4. Get a list of available voices
curl -H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
    -H "Content-Type: application/json; charset=utf-8" \
    "https://texttospeech.googleapis.com/v1/voices"

    
