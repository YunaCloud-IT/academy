# Getting Started with Google Cloud SQL: A Hands-On Guide

This guide will walk you through creating, connecting to, and managing a relational database using Cloud SQL directly from the Google Cloud Console. We'll use **PostgreSQL** for this example, but the steps are very similar for MySQL and SQL Server. 🐘

---

## Prerequisites

Before you begin, you'll need:
1.  A **Google Cloud Platform (GCP) account** with billing enabled.
2.  A **Google Cloud project**. If you don't have one, create one from the console dashboard.

---

## Step 1: Create a Cloud SQL Instance

Your Cloud SQL instance is a fully managed virtual machine optimized to run your database.

1.  **Navigate to Cloud SQL:** In the Google Cloud Console, use the top search bar to search for "Cloud SQL" and select it.


2.  **Create Instance:** Click the **"Create Instance"** button.

3.  **Choose a Database Engine:** Select **"Choose PostgreSQL"**.

4.  **Configure the Instance:**
    * **Instance ID:** Give your instance a unique name, like `my-first-instance`.
    * **Password:** Create a strong password for the default `postgres` user. **Save this password securely!** You'll need it to connect.
    * **Database version:** Choose the latest available version.
    * **Region and Zonal availability:** Select a region close to you or your users (e.g., `europe-west3` for Frankfurt). For this demo, **"Single zone"** is fine.
    * **Customize your instance:** Expand the "Show configuration options" section. For a first test, you can leave the machine type and storage at their default settings (e.g., `db-n1-standard-1`).

5.  **Create:** Click the **"Create Instance"** button at the bottom. Provisioning will take a few minutes.

---

## Step 2: Connect to Your Instance

To run SQL commands, you need to connect to your database. We'll use the built-in **Cloud Shell**, which is the easiest and most secure way to start.

1.  **Authorize Your Connection:** Cloud SQL uses a security wall to block unauthorized connections. You must add your IP address to the authorized list.
    * In your instance's overview page, go to the **"Connections"** tab.
    * Under the **"Networking"** tab, click **"Add a network"**.
    * Your current IP address is usually auto-detected. Give it a name (e.g., "My Home IP") and click **"Done"**.
    * Click **"Save"**.

2.  **Open Cloud Shell:** Click the **"Activate Cloud Shell"** icon ( выглядит как `>_` ) in the top-right corner of the console. A terminal will open at the bottom of your screen.

3.  **Connect using gcloud:** The `gcloud` command-line tool makes connecting simple. In the Cloud Shell terminal, run the following command, replacing `my-first-instance` with your instance ID:
    ```bash
    gcloud sql connect my-first-instance --user=postgres
    ```
4.  **Enter Password:** You'll be prompted to enter the `postgres` user password you created in Step 1.

If successful, your prompt will change to `postgres=>`, indicating you are now connected to your PostgreSQL database. 🎉

---

## Step 3: Create a Database and a Table

Now that you're connected, let's perform some basic SQL operations.

1.  **Create a New Database:** It's good practice to create a separate database for your application instead of using the default `postgres` one.
    ```sql
    CREATE DATABASE my_store;
    ```

2.  **Connect to Your New Database:**
    ```sql
    \c my_store
    ```
    The prompt will change to `my_store=>`.

3.  **Create a Table:** Let's create a simple table to store product information.
    ```sql
    CREATE TABLE products (
        product_id SERIAL PRIMARY KEY,
        product_name VARCHAR(100) NOT NULL,
        price NUMERIC(10, 2)
    );
    ```

---

## Step 4: Perform Basic CRUD Operations

Let's add, view, update, and delete some data. CRUD stands for **C**reate, **R**ead, **U**pdate, **D**elete.

1.  **Create (Insert) Data:** Add a few products to your table.
    ```sql
    INSERT INTO products (product_name, price) VALUES ('Laptop', 1200.50);
    INSERT INTO products (product_name, price) VALUES ('Mouse', 25.00);
    INSERT INTO products (product_name, price) VALUES ('Keyboard', 75.99);
    ```

2.  **Read (Select) Data:** Query the table to see your products.
    ```sql
    SELECT * FROM products;
    ```
    *Output:*
    ```
     product_id | product_name |  price
    ------------+--------------+---------
              1 | Laptop       | 1200.50
              2 | Mouse        |   25.00
              3 | Keyboard     |   75.99
    (3 rows)
    ```

3.  **Update Data:** Let's say the price of the mouse increased.
    ```sql
    UPDATE products SET price = 29.99 WHERE product_name = 'Mouse';
    ```

4.  **Delete Data:** Let's remove the laptop.
    ```sql
    DELETE FROM products WHERE product_id = 1;
    ```

5.  **Verify Changes:** Run the `SELECT` query again to see the final state of your data.
    ```sql
    SELECT * FROM products;
    ```
    *Output:*
    ```
     product_id | product_name | price
    ------------+--------------+-------
              2 | Mouse        | 29.99
              3 | Keyboard     | 75.99
    (2 rows)
    ```

---

## Step 5: Clean Up

To avoid incurring ongoing charges for resources you are no longer using, it's important to delete the instance.

1.  **Navigate to your instance:** Go back to the Cloud SQL instances page in the console.
2.  **Select and Delete:** Click the three-dot menu next to your instance (`my-first-instance`) and select **"Delete"**.
3.  **Confirm:** You'll be asked to type the instance ID to confirm the deletion. Type it in and click **"Delete"**.

That's it! You've successfully created a Cloud SQL instance, connected to it, managed data, and cleaned up the resources. 👍
