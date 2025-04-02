# Cloud Translation API
## setup
```
export REGION=us-west1
gcloud config set compute/region $REGION
```
## Task 1. Create an API key
1. To create an API key, in the Navigation menu (Navigation menu icon), click APIs & services > Credentials.

2. Click +CREATE CREDENTIALS.

3. In the drop down menu, select API key.

4. Copy the key you just generated.
``` export API_KEY= YOUR_API_KEY ```

## further task are not require to pass
## Task 2
```
TEXT="My%20name%20is%20Steve"
curl "https://translation.googleapis.com/language/translate/v2?target=es&key=${API_KEY}&q=${TEXT}"
```
