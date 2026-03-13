# Google Cloud Sample Repositories & Quickstarts

This document provides a consolidated list of command-line instructions for fetching official Google Cloud Platform (GCP) code samples and lab environments across various programming languages and services.

## Prerequisites

Before fetching these repositories, ensure your local development environment or Cloud Shell has the following tools installed and configured:

- **Git**: Required for cloning GitHub repositories
- **Google Cloud CLI (`gcloud`)**: Required for copying files directly from Google Cloud Storage buckets

## Language Samples

### Golang

The `golang-samples` repository contains the official, up-to-date Go code samples used in Google Cloud documentation. This includes examples for App Engine, Cloud Run, Cloud Functions, and various GCP APIs.

To fetch the repository:

```
git clone https://github.com/GoogleCloudPlatform/golang-samples.git
```

### PHP

The `php-docs-samples` repository hosts the official PHP sample applications and code snippets for Google Cloud services, providing a great starting point for building PHP applications on GCP.

To fetch the repository:

```
git clone https://github.com/GoogleCloudPlatform/php-docs-samples.git
```

### Java (App Engine)

Unlike the standard GitHub repositories, this specific Java sample is hosted in a Google Cloud Storage bucket. This command copies the App Engine Java 21 starter files directly into your current directory.

```
gcloud storage cp -r gs://spls/gsp068/appengine-java21/appengine-java21/* .
```

**Note**: Ensure you include the `.` at the end of the command to download the files to your current working directory

---------------------------

## Data & Database Services

### Cloud SQL / Data Science on GCP

The `ata-science-on-gcp` repository contains the code for the "Data Science on Google Cloud Platform" book and associated training labs. While it covers a broad range of data tools (like BigQuery, Dataproc, and Pub/Sub), it is an excellent resource for learning how to integrate Cloud SQL into larger data engineering and machine learning pipelines.

To fetch the repository:

```
git clone https://github.com/GoogleCloudPlatform/data-science-on-gcp/
```
