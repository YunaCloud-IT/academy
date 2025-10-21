# Deploy a Node.js Web App to Google App Engine 🚀

This guide provides the essential steps to deploy a simple Node.js application (index.js) to the App Engine standard environment.

---

## 1. Prerequisites
   
Before you begin, make sure you have the following set up:

- A Google Cloud Project: Create one in the [Google Cloud Console](https://console.cloud.google.com/).

- Google Cloud CLI: Install and initialize the [gcloud CLI](https://cloud.google.com/sdk/docs/install). This is how you'll interact with your project from the command line.

- Node.js and npm: Install them if you don't [have them](https://nodejs.org/en) on your local machine.

Run this command to log in and set your project context:

```Bash
gcloud init
```

## 2. Prepare Your Application Files
   
For a basic deployment, you'll need three files in your project's root directory:

- app.yaml

- package.json

- index.js

### app.yaml (App Engine Configuration)

This file tells App Engine how to run your application. Create a file named `app.yaml` and add the following content. This configuration specifies the Node.js runtime.

```YAML
# app.yaml
# Specifies the runtime environment for your app.
# App Engine will use the latest supported Node.js version.
runtime: nodejs22
```

### package.json (Dependencies and Start Script)

This file manages your app's dependencies and defines the command to start it. Create a `package.json` file. The `start` script is crucial, as App Engine uses it to run your app.

```JSON
{
  "name": "app-engine-demo",
  "version": "1.0.0",
  "description": "A simple Node.js app for App Engine.",
  "main": "index.js",
  "scripts": {
    "start": "node index.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
```

After creating this file, run `npm install` to get the Express.js dependency.

### index.js (Your Application Code)

This is your main application logic. Create an `index.js` file with a simple Express server. App Engine provides the `PORT` environment variable, which your app must listen on.

```JavaScript
// index.js
const express = require('express');
const app = express();

app.get('/', (req, res) => {
  res.send('Hello from Google App Engine! 👋');
});

// Listen to the App Engine-specified port, or 8080 otherwise
const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}...`);
});
```

At this point, your project directory should look like this:

```
/my-app
├── app.yaml
├── index.js
├── package.json
└── /node_modules
```

## 3. Deploy to App Engine
   
Now you're ready to deploy! ☁️

### Step 1: Create the App Engine Application

This is a one-time command for each project. You'll be prompted to choose a region where you want your app to be hosted.

```Bash
gcloud app create
```

### Step 2: Deploy Your Code

Navigate to your project's root directory (where `app.yaml` is located) in your terminal and run:

```Bash
gcloud app deploy
```

Confirm the deployment by typing Y when prompted. The gcloud CLI will then package your files, upload them, and launch your application. This may take a few minutes.

### Step 3: View Your Live App

Once the deployment is complete, you can view your application in a web browser by running:

```Bash
gcloud app browse
```

This command will automatically open your app's default URL (`https://<project-id>.appspot.com`). You should see the message "Hello from Google App Engine! 👋".

Congratulations, your app is now live!

## Error Hanfdling

### Failed to create cloud build: com.google.net.rpc3.client.RpcClientException

This error appears when your default service account has a lack of permission. You can fix this with the following example. Please change the service account with the one from the error message and also your project id.

```
gcloud projects add-iam-policy-binding YOUR-PROJECT-NAME \
    --member="serviceAccount:YOUR-SERVICE-ACCOUNT-NAME" \
    --role="roles/storage.objectAdmin"
```
