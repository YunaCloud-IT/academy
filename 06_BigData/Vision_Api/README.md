# Analyzing Images with Google Cloud Vision API and GCS

This guide explains how to upload an image to Google Cloud Storage and use the `gcloud` CLI to perform image analysis via the Cloud Vision API.

## General Model Overview

https://cloud.google.com/model-garden?hl=en

## Prerequisites

* **Google Cloud Project:** Ensure you have a project selected.
* **gcloud SDK:** The `gcloud` command-line tool must be installed and authenticated (`gcloud auth login`).
* **Billing:** Ensure billing is enabled for your project.

---

## Step 1: Enable the Vision API

Before you can use the service, you must enable the API within your project.

```bash
gcloud services enable vision.googleapis.com
```

## Step 2: Prepare the Storage Bucket

You need a bucket to host your image. Replace `[BUCKET_NAME]` with a unique name.

```
# Create a new bucket
gcloud storage buckets create gs://[BUCKET_NAME] --location=europe-west10
```

## Step 3: Upload the Image

Upload your image (e.g., `image_4430d4.jpg`) to the bucket you just created.

```
gcloud storage cp image_4430d4.jpg gs://[BUCKET_NAME]/image_4430d4.jpg
```

## Step 4: Analyze the Image

The Vision API supports various detection types (`LABEL_DETECTION`, `LANDMARK_DETECTION`, `LOGO_DETECTION`, etc.). You can run a command to detect labels and landmarks, which is ideal for a landscape image like yours.

### Option A: Label Detection (General Objects)

This will identify the mountains, buildings, and clouds.

```
gcloud ml vision detect-labels gs://[BUCKET_NAME]/image_4430d4.jpg
```

### Option B: Landmark Detection

Since this image features a prominent mountain peak (likely in the Dolomites), landmark detection can help identify the specific location.

```
gcloud ml vision detect-landmarks gs://[BUCKET_NAME]/image_4430d4.jpg
```

## Understanding the Output

The command will return a JSON response containing:

- Description: The name of the entity detected.

- Mid: A machine-readable ID for the entity.

- Score: A confidence score (0 to 1) of the detection.

- Topicality: How central the entity is to the image.

### Example Response Snippet

```
{
  "responses": [
    {
      "labelAnnotations": [
        {
          "description": "Mountain",
          "mid": "/m/09jsg",
          "score": 0.9821,
          "topicality": 0.9821
        },
        {
          "description": "Alps",
          "mid": "/m/089_7",
          "score": 0.92,
          "topicality": 0.92
        }
      ]
    }
  ]
}
```

## Summary of Commands

- Enable API: `gcloud services enable vision.googleapis.com`

- Upload: `gcloud storage cp [FILE] gs://[BUCKET]/`

- Analyze: `gcloud ml vision detect-labels gs://[BUCKET]/[FILE]`
