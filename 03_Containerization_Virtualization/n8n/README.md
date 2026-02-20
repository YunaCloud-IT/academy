# n8n & PostgreSQL Docker Deployment

This repository contains the Docker Compose configuration to deploy [n8n](https://n8n.io/) (a powerful workflow automation tool) backed by a PostgreSQL database for robust, production-ready data persistence.



## 📋 Prerequisites

Before you begin, ensure you have the following installed on your host machine:
* **Docker**: [Installation Guide](https://docs.docker.com/get-docker/)
* **Docker Compose**: Included with Docker Desktop, or [install separately](https://docs.docker.com/compose/install/) for Linux servers.

## 📂 Project Structure

Your project directory should look like this:

```text
my-n8n-project/
├── .env                 # Environment variables and secrets (Do not commit to version control)
├── docker-compose.yml   # The container configuration
└── README.md            # This documentation file
```

## 🚀 Getting Started

Follow these steps to configure and start your n8n instance.

### 1. Configure the Environment (`.env`)

Create a `.env` file in the root directory and populate it with your secure credentials.

```
# Database Configuration
DB_USER=n8n_user
DB_PASSWORD=your_secure_db_password_here
DB_NAME=n8n

# Core n8n Security
# CRITICAL: Generate a random string. If lost, you lose access to connected accounts!
N8N_ENCRYPTION_KEY=generate_a_very_secure_random_string_here

# Timezone (Required for accurate cron/schedule triggers)
GENERIC_TIMEZONE=Europe/Berlin
```

### 2. Start the Stack

Open your terminal, navigate to the project directory, and run the following command to download the images and start the containers in the background:

```
docker compose up -d
```

**Note:** On the very first startup, it might take a minute or two for the PostgreSQL database to initialize. n8n is configured to wait automatically until the database is healthy before starting.

### 3. Access n8n

Once the containers are running, open your web browser and navigate to:

- URL: `http://localhost:5678` (or `http://<your-server-ip>:5678`)

## 🛠️ Management & Maintenance

Here are some helpful commands for managing your n8n stack. Run these from the same directory as your `docker-compose.yml` file.

### View Logs

If you need to troubleshoot workflows or check the container status:

```
# View all logs
docker compose logs -f

# View logs for n8n only
docker compose logs -f n8n

# View logs for the database only
docker compose logs -f postgres
```

### Stop the Stack

To stop the containers without deleting your data:

```
docker compose stop
```

### Shut Down and Remove Containers

To completely remove the containers and the default network (your data will be preserved in the Docker volumes):

```
docker compose down
```

### Update n8n to the Latest Version

To pull the latest n8n image and restart the container with minimal downtime:

```
docker compose pull n8n
docker compose up -d
```

## ⚠️ Important Backup Warning

Your workflows, executions, and user data are stored in the PostgreSQL database and the `n8n_data` volume. However, your **authenticated credentials** (API keys, OAuth tokens) are encrypted using the `N8N_ENCRYPTION_KEY` located in your `.env` file.

If you lose your `.env` file and the `N8N_ENCRYPTION_KEY`, **you will not be able to decrypt your stored credentials, even if you have a perfect backup of the database**. Always back up your `.env` file securely!

## 💡 Backup

There is a file named backup.sh in your project directory (the same folder as your docker-compose.yml).

### 1. Make it Executable

Before you can run the script, you need to give it execute permissions. Run this command in your terminal:

```
chmod +x backup.sh
```

### 2. Run the Backup

To create a backup, simply execute the script:

```
./backup.sh
```

You will see a new `backups` folder appear in your directory containing a compressed archive (e.g., `n8n_backup_20260220_095618.tar.gz`). Inside that archive is your `.env.backup` and your `database_dump.sql`.
