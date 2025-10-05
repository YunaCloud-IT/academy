# Creating a Public HTTP Google Cloud Function

1. Create a temporary folder on your local workstation to hold the files (in this hands-on `code`)
2. In your terminal, run the following command inside the folder:

```
npm init
```

3. Accept the defaults
4. In your favorite IDE, create an `index.js` file in the root of the directory
5. Copy the following code to the file:

```
exports.helloHttp = (req, res) => {
  res.send("Hello World!");
}
```

6. Login into Google Cloud and configure project:

```
gcloud auth application-default login
PROJECT_ID={{insert-your-project-id}}
gcloud config set project $PROJECT_ID     
```

7. Run the `init.sh` script to enable the default Compute Engine service account
7. To deploy the cloud function, run the following command in the folder:

```
gcloud functions deploy hello-http-function --entry-point helloHttp --runtime nodejs24 --trigger-http --service-account {{insert-your-sa-created-with-init-script}}
```

8. Allow the function to be unauthenticated: [y]
9. In the Google Cloud Console, choose Cloud Run and then Services from the navigation menu
10. Locate the deployed cloud function and select it
11. Select "Triggers" tab
12. Click the trigger URL to test the function
