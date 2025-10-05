# Deploying a Prebuilt Hello World Container

1. Open `init.sh` and analyze the script
2. Change values like `region`, or `service_name`
3. Run the script to deploy a Cloud Run Service in GCP
4. Run the following command to check access, change the url:

```
curl -H "Authorization: Bearer $(gcloud auth print-identity-token)" {{url-provided-by-the-script}}
```
