# GCP CSV Generator (Not Working Example)

Here is a full example structured as a set of files for a Node.js application. This application will generate a CSV file, upload it to Google Cloud Storage (GCS), and then create a BigQuery table from that CSV file.

---

## Prerequisites

Before running this, make sure you have:

1. A Google Cloud project with billing enabled.

2. The Cloud Storage, BigQuery, and Cloud APIs enabled.

3. A service account key file downloaded (or use other authentication methods like Workload Identity/Application Default Credentials). For this example, we'll assume a path to a key file.

4. A GCS Bucket created.

5. Node.js installed.

---

## Allowing public access

This is the easiest way to make all objects in your bucket publicly readable.

1. Go to the Cloud Storage Buckets page in the Google Cloud Console.

2. Click the name of your bucket (e.g., your-unique-bucket-name).

3. Go to the Permissions tab.

4. If Public access prevention is enabled on the bucket, you'll need to disable it first. Click the setting and confirm the removal.

5. Click the Grant access button.

6. In the Grant access dialog:

    - In the New principals field, enter: allUsers

    - In the Select a role field, search for and select: Storage Object Viewer (roles/storage.objectViewer)

7. Click Save. A warning will appear confirming that the resource will be made public.

8. Click Allow public access.

---

## 1. Project Setup

Create a new directory for your project and initialize a Node.js project:

```Bash
mkdir gcp-csv-generator
cd gcp-csv-generator
npm init -y
```

Install the necessary Google Cloud libraries and a CSV generation utility:

```Bash
npm install @google-cloud/storage @google-cloud/bigquery csv-stringify
```

---

## 2. The Node.js Application (`index.js`)

This file contains the logic for CSV generation, GCS upload, and BigQuery dataset/table creation.

```JavaScript
// index.js

const { Storage } = require('@google-cloud/storage');
const { BigQuery } = require('@google-cloud/bigquery');
const { stringify } = require('csv-stringify');
const fs = require('fs');
const util = require('util');
const path = require('path');

// Promisify fs.writeFile for async/await usage
const writeFile = util.promisify(fs.writeFile);

// --- Configuration ---
const GCS_BUCKET_NAME = 'your-unique-bucket-name'; // ⬅️ **CHANGE THIS**
const BQ_DATASET_ID = 'csv_data_pipeline';
const BQ_TABLE_ID = 'example_transactions';
const GCS_FILE_NAME = 'transactions_' + Date.now() + '.csv';
const LOCAL_FILE_PATH = path.join(__dirname, GCS_FILE_NAME);
const PROJECT_ID = 'your-gcp-project-id'; // ⬅️ **CHANGE THIS**

// Set the path to your service account key file if not using ADC
// process.env.GOOGLE_APPLICATION_CREDENTIALS = '/path/to/your/keyfile.json'; // ⬅️ **UNCOMMENT & CHANGE THIS IF NEEDED**

// Initialize clients
const storage = new Storage({ projectId: PROJECT_ID });
const bigquery = new BigQuery({ projectId: PROJECT_ID });

/**
 * 1. Generates a CSV string with sample data.
 * @returns {Promise<string>} The CSV file content as a string.
 */
function generateCsvData() {
    const records = [
        ['transaction_id', 'amount', 'currency', 'timestamp'],
        ['T1001', 50.75, 'USD', new Date().toISOString()],
        ['T1002', 120.00, 'EUR', new Date().toISOString()],
        ['T1003', 25.50, 'USD', new Date().toISOString()],
        ['T1004', 300.99, 'JPY', new Date().toISOString()],
    ];

    return new Promise((resolve, reject) => {
        stringify(records, (err, output) => {
            if (err) return reject(err);
            resolve(output);
        });
    });
}

/**
 * 2. Uploads the local file to Google Cloud Storage.
 * @param {string} filePath - Local path to the file.
 * @param {string} bucketName - Name of the GCS bucket.
 * @param {string} destination - Destination filename in GCS.
 * @returns {Promise<void>}
 */
async function uploadFileToGCS(filePath, bucketName, destination) {
    console.log(`Uploading ${filePath} to gs://${bucketName}/${destination}...`);
    await storage.bucket(bucketName).upload(filePath, {
        destination: destination,
    });
    console.log(`✅ File uploaded successfully: gs://${bucketName}/${destination}`);
}

/**
 * 3. Ensures the BigQuery dataset exists.
 * @param {string} datasetId - The ID of the dataset.
 * @returns {Promise<void>}
 */
async function ensureBigQueryDataset(datasetId) {
    try {
        await bigquery.createDataset(datasetId);
        console.log(`Dataset ${datasetId} created.`);
    } catch (err) {
        if (err.code === 409) { // 409: Conflict (Dataset already exists)
            console.log(`Dataset ${datasetId} already exists.`);
        } else {
            throw err;
        }
    }
}

/**
 * 4. Loads the CSV data from GCS into a BigQuery table.
 * @param {string} gcsUri - URI of the CSV file in GCS.
 * @param {string} datasetId - BigQuery Dataset ID.
 * @param {string} tableId - BigQuery Table ID.
 * @returns {Promise<void>}
 */
async function loadGcsToBigQuery(gcsUri, datasetId, tableId) {
    const dataset = bigquery.dataset(datasetId);

    // Define the schema for the BigQuery table
    const schema = [
        { name: 'transaction_id', type: 'STRING' },
        { name: 'amount', type: 'NUMERIC' },
        { name: 'currency', type: 'STRING' },
        { name: 'timestamp', type: 'TIMESTAMP' },
    ];

    const metadata = {
        sourceFormat: 'CSV',
        schema: schema,
        skipLeadingRows: 1, // Skip the header row
        autodetect: false,
        writeDisposition: 'WRITE_TRUNCATE', // Overwrite table if it exists (use 'WRITE_APPEND' to add data)
    };

    console.log(`Loading data from ${gcsUri} into ${datasetId}.${tableId}...`);

    // Load data from a Google Cloud Storage file into the table
    const [job] = await dataset.table(tableId).load(gcsUri, metadata);

    // Wait for the job to complete
    const [response] = await job.getQueryResults();

    if (response && response.status && response.status.errorResult) {
        throw new Error(response.status.errorResult.message);
    }

    console.log(`✅ Job ${job.id} completed. Data loaded into ${datasetId}.${tableId}`);
}

// --- Main Execution ---
async function main() {
    try {
        console.log('--- Start CSV Generation and BigQuery Pipeline ---');

        // 1. Generate CSV data and save locally
        const csvContent = await generateCsvData();
        await writeFile(LOCAL_FILE_PATH, csvContent);
        console.log(`✅ CSV file created locally: ${LOCAL_FILE_PATH}`);

        // 2. Upload to Google Cloud Storage
        await uploadFileToGCS(LOCAL_FILE_PATH, GCS_BUCKET_NAME, GCS_FILE_NAME);
        const gcsUri = `gs://${GCS_BUCKET_NAME}/${GCS_FILE_NAME}`;

        // 3. Ensure BigQuery Dataset Exists
        await ensureBigQueryDataset(BQ_DATASET_ID);

        // 4. Load GCS data into BigQuery Table
        await loadGcsToBigQuery(gcsUri, BQ_DATASET_ID, BQ_TABLE_ID);

    } catch (error) {
        console.error('❌ An error occurred:', error.message);
        process.exit(1);
    } finally {
        // Clean up the local file
        if (fs.existsSync(LOCAL_FILE_PATH)) {
            fs.unlinkSync(LOCAL_FILE_PATH);
            console.log(`Cleaned up local file: ${LOCAL_FILE_PATH}`);
        }
        console.log('--- Pipeline Finished ---');
    }
}

main();
```

---

## 3. How to Run the Application

Update the variables in `index.js`:

- `GCS_BUCKET_NAME`

- `PROJECT_ID`

- (Optional) `process.env.GOOGLE_APPLICATION_CREDENTIALS` if using a service account key file.

Run the application from your terminal:

```Bash
node index.js
``

### Expected Output (Example)

``
--- Start CSV Generation and BigQuery Pipeline ---
✅ CSV file created locally: /path/to/gcp-csv-generator/transactions_1634988000000.csv
Uploading /path/to/gcp-csv-generator/transactions_1634988000000.csv to gs://your-unique-bucket-name/transactions_1634988000000.csv...
✅ File uploaded successfully: gs://your-unique-bucket-name/transactions_1634988000000.csv
Dataset csv_data_pipeline already exists. (or Dataset csv_data_pipeline created.)
Loading data from gs://your-unique-bucket-name/transactions_1634988000000.csv into csv_data_pipeline.example_transactions...
✅ Job BQ_JOB_ID_... completed. Data loaded into csv_data_pipeline.example_transactions
Cleaned up local file: /path/to/gcp-csv-generator/transactions_1634988000000.csv
--- Pipeline Finished ---
```

## Explanation of Key Steps

### 1. CSV Generation (`generateCsvData`)

- Uses the `csv-stringify` library to easily convert an array of arrays (data records) into a standard CSV string format.

- The first array is the header row that defines the column names.

### 2. Google Cloud Storage Upload (`uploadFileToGCS`)

-  The `@google-cloud/storage` library is used.

- `storage.bucket(bucketName).upload(filePath, { destination: fileName })` handles streaming the local file content to the specified GCS location.

### 3. BigQuery Dataset and Table (`ensureBigQueryDataset` and `loadGcsToBigQuery`)

- The `@google-cloud/bigquery` library is used for data ingestion.

- `ensureBigQueryDataset`: Checks if the target dataset exists and creates it if it doesn't, allowing subsequent operations to proceed.

- `loadGcsToBigQuery`: This is the critical step for consuming the CSV.

    - It defines a schema to tell BigQuery the data types of each column, which is essential for structured querying.

    - The `metadata` object specifies:

      - `sourceFormat: 'CSV'`

      - `skipLeadingRows`: 1 to ignore the header row in the CSV file.

      - `writeDisposition`: 'WRITE_TRUNCATE' to create the table and overwrite any previous data if the table already exists.

    - `dataset.table(tableId).load(gcsUri, metadata) submits an asynchronous BigQuery Load Job to ingest the data directly from GCS.
