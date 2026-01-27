# Intro to Google Cloud Functions
## Serverless Computing on GCP

---

# What is a Cloud Function?

* **Serverless:** No servers to manage, update, or restart.
* **Event-Driven:** It sleeps until you "poke" it (e.g., with an HTTP request).
* **Pay-per-Use:** If no one uses it, it costs $0.

**Today's Goal:** Deploy a Python function that greets the world.

---

# Step 1: The Python Code

Create a file named `main.py` and paste this code:

```python
def hello_students(request):
    """
    Responds to any HTTP request.
    """
    return 'Hello, Future Cloud Architects!'
```

# Step 2: The Deploy Command

Run this command in your terminal (make sure you are in the same folder as your file):

```
gcloud functions deploy student-hello-cli \
--gen2 \
--region=europe-west10 \
--runtime=python310 \
--source=. \
--entry-point=hello_students \
--trigger-http \
--allow-unauthenticated
```

# Understanding the Flags

- `--gen2`: Uses the modern Cloud Run infrastructure.

- `--source=.`: Tells GCP the code is in the current folder.

- `--entry-point=hello_students`: Tells GCP which function in the code to run.

- `--allow-unauthenticated`: Makes the function public (so we can test it easily).

# Step 3: Test Your Function

Once the deployment finishes (1-2 mins), find your URL:

```
gcloud functions describe student-hello-cli \
--gen2 \
--region=europe-west10 \
--format="value(serviceConfig.uri)"
```

Action: Copy the URL and paste it into your browser.

Result: You should see: `Hello, Future Cloud Architects!`
