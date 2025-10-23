# Getting Started with Cloud Firestore in the Google Cloud Console

This guide provides a hands-on walkthrough to help you understand the basics of Google Cloud Firestore, its data model, and how to perform fundamental operations directly within the Google Cloud Console. It's the perfect starting point before you dive into code.

---

##  Prerequisites

Before you begin, you need two things:

1.  A **Google Cloud Project**. If you don't have one, you can create one for free.
2.  The **Cloud Firestore API** must be enabled for your project.

---

## Step 1: Navigate to Firestore & Create Your Database

First, you need to open Firestore in your project and create your database instance.

1.  Open the [Google Cloud Console](https://console.cloud.google.com/).
2.  In the main navigation menu (the "hamburger" menu ☰), scroll down to the **Databases** section and select **Firestore**.
3.  Click **Create Database**.
4.  You will be prompted to choose a mode. For most new projects, you should select **Native Mode**.
    * **Native Mode**: The standard Firestore interface with real-time updates. **(Choose this)**
    * **Datastore Mode**: A legacy mode for projects already using Cloud Datastore.
5.  Select a **location** for your database. Choose a location close to your users for lower latency. **This cannot be changed later!**
6.  Click **Create Database**.



---

## Step 2: Understanding the Firestore Data Model

Firestore is a NoSQL, document-oriented database. Think of it like a set of digital filing cabinets. 🗄️

* **Collection**: This is like a folder or a drawer in the filing cabinet (e.g., `users`, `products`). Collections only contain documents.
* **Document**: This is like a single file or sheet of paper within a folder (e.g., a specific user's profile). Each document has a unique ID.
* **Fields**: These are the key-value pairs of data inside a document, like `firstName: "Ada"` or `born: 1815`. The values can be various data types like strings, numbers, booleans, arrays, or even nested objects (called maps).

The structure is always **Collection -> Document -> Collection -> Document ...** and so on. You cannot have a document directly inside another document without a subcollection in between.

---

## Step 3: Create Your First Collection & Document

Let's create a collection to store user profiles.

1.  In the main Firestore data view, click **+ Start collection**.
2.  For the **Collection ID**, type `users`.
3.  Now, you'll create the first document in this collection. You can either provide a specific **Document ID** or click **Auto-ID** to have Firestore generate a unique one for you. Let's use **Auto-ID** for this example.
4.  Next, add the **fields** for this document.
    * Field: `firstName`, Type: `string`, Value: `Ada`
    * Click **+ Add field**.
    * Field: `lastName`, Type: `string`, Value: `Lovelace`
    * Click **+ Add field**.
    * Field: `born`, Type: `number`, Value: `1815`
5.  Click **Save**.

You have now created your first collection (`users`) and your first document within it! You'll see the data displayed in the console.



---

## Step 4: Add and Query Your Data

A database isn't very useful with only one entry. Let's add another user and then query the collection.

### Add a Second Document

1.  At the top of the middle pane, click **+ Add document**.
2.  This time, let's give it a custom **Document ID**. Type `aturing`.
3.  Add the following fields:
    * `firstName`: (string) `Alan`
    * `lastName`: (string) `Turing`
    * `born`: (number) `1912`
4.  Click **Save**.

You now have two documents in your `users` collection.

### Query Data in the Console

The console has a powerful query builder. Let's find all users born before 1900.

1.  In the `users` collection view, click on the **Filter** icon or the **Add to query** button.
2.  In the query builder, enter the following:
    * Field: `born`
    * Operator: `<` (less than)
    * Value: `1900`
3.  Click **Apply**.

The console will now filter the list to show only the document for Ada Lovelace. To clear the filter, just click the 'x' on the filter condition.

---

## Step 5: Update and Delete a Document

You can easily manage your data directly from the console.

### Update a Document

1.  Click on the document for **Ada Lovelace** to select it.
2.  In the right-hand pane showing her data, hover over the `born` field.
3.  Click the pencil icon (✏️) to edit the value.
4.  Change the value to `1816` and click the checkmark or press Enter to save. The value is now updated.

### Delete a Document

1.  With the Ada Lovelace document still selected, click the three-dot menu (⋮) at the top of the right-hand pane.
2.  Select **Delete document**.
3.  A confirmation dialog will appear. Click **Delete** to permanently remove the document.

Congratulations! You have successfully created, read, updated, and deleted data in Cloud Firestore using the Google Cloud Console.
