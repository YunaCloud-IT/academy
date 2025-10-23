# A Beginner's Guide to Google BigQuery 🚀

This guide provides a step-by-step introduction to using Google BigQuery directly from the Google Cloud Console. We'll cover exploring the interface, running a basic query on a public dataset, and then uploading your own CSV file to create and query a new table.

## Prerequisites

1.  A **Google Cloud Project** with the BigQuery API enabled. (This is usually enabled by default when you create a new project).
2.  A sample **CSV file** on your local machine. Let's assume you have a file named `products.csv` with the following content:
    ```csv
    product_id,product_name,category,price
    101,Laptop,Electronics,1200.50
    102,Mouse,Electronics,25.00
    201,T-Shirt,Apparel,15.99
    202,Jeans,Apparel,75.00
    301,Coffee Mug,Kitchen,8.99
    ```

---

## 1. Exploring the BigQuery UI

First, let's get familiar with the BigQuery console.

1.  In the Google Cloud Console, use the navigation menu (☰) to go to **Analytics** > **BigQuery**.
2.  The BigQuery UI has three main sections:
    * **Explorer (Left):** This panel lists your projects, datasets, and tables. You can also explore public datasets available for querying.
    * **Query Editor (Center):** This is where you write and run your SQL queries.
    * **Query Results & Job Information (Bottom):** After running a query, the results and performance details (like time elapsed and data processed) appear here.



### Run a Sample Query

Let's run a quick query on a public dataset to see it in action.

1.  In the **Query Editor**, copy and paste the following SQL code:

    ```sql
    SELECT
      name,
      gender,
      SUM(number) AS total_births
    FROM
      `bigquery-public-data.usa_names.usa_1910_current`
    WHERE
      name = 'Olivia'
    GROUP BY
      name,
      gender;
    ```

2.  Click the **RUN** button.

In a few moments, the results will appear below the editor, showing the total number of people named Olivia in the dataset, grouped by gender. You just queried millions of rows!

---

## 2. Uploading Your CSV and Creating a Table

Now, let's use your own `products.csv` file to create a new table.

### Step 1: Create a Dataset

A dataset is a container for your tables, similar to a schema in a traditional database.

1.  In the **Explorer** panel, click the three-dot menu (⋮) next to your project ID and select **Create dataset**.
2.  For **Dataset ID**, enter a unique name like `my_store`.
3.  Leave the other options at their default values and click **CREATE DATASET**. Your new dataset will now appear in the Explorer panel under your project.

### Step 2: Create a Table from the CSV

1.  Click the three-dot menu (⋮) next to the `my_store` dataset you just created and select **Create table**.
2.  This will open the "Create table" configuration page. Fill it out as follows:
    * **Source**:
        * Create table from: **Upload**
        * Select file: Browse and select your `products.csv` file from your computer.
        * File format: **CSV**
    * **Destination**:
        * Project: Your project ID should be pre-filled.
        * Dataset: `my_store` should be pre-filled.
        * Table name: Enter a name for your table, like `products`.
    * **Schema**:
        * Select **Autodetect schema and input parameters**. BigQuery will intelligently inspect your CSV file to determine the column names (`product_id`, `product_name`, etc.) and their data types (`INTEGER`, `STRING`, `FLOAT`).
    * **Advanced options**:
        * In the **Header rows to skip** field, enter `1`. This tells BigQuery to ignore the first row of your CSV because it contains the column headers, not actual data.

3.  Click the **CREATE TABLE** button at the bottom.

After a few seconds, your new `products` table will appear under the `my_store` dataset in the Explorer panel. Click on it to view its schema.

---

## 3. Querying Your Uploaded Data

You are now ready to query your own data just like you did with the public dataset.

1.  Click the **QUERY** button on the `products` table details screen, or simply open a new editor tab.
2.  Enter a query to explore your data. For example, let's select all products in the 'Electronics' category.

    ```sql
    SELECT
      product_name,
      price
    FROM
      `your-project-id.my_store.products` -- IMPORTANT: Replace 'your-project-id' with your actual project ID!
    WHERE
      category = 'Electronics'
    ORDER BY
      price DESC;
    ```

3.  Click **RUN**.

The results will show the Laptop and Mouse products, sorted by price. You have successfully uploaded, configured, and queried your own data in BigQuery. Congratulations! 🎉
