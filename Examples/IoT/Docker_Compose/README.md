# IoT Stack Training: Docker Compose Overview

Welcome to the IoT Stack training! This project sets up a complete IoT data pipeline using Docker Compose. You will see how data flows from a simulator through a messaging broker into a database, and finally into a visualization dashboard.

## 🚀 Getting Started

To get the stack up and running, follow these steps:

1.  **Open your terminal** in this directory.
2.  **Start the containers**:
    ```bash
    docker-compose up -d
    ```
    *(Note: Depending on your OS and Docker version, you may need to use `docker compose` without the hyphen instead of `docker-compose`).*

3.  **Check if everything is running**:
    ```bash
    docker-compose ps
    ```

To stop the stack, use:
```bash
docker-compose down
```

---

## 🏗️ The IoT Stack Architecture

The "IoT Stack" refers to the layers of technology required to move data from a device to a user. In this setup, we use a classic **TIG Stack** (Telegraf, InfluxDB, Grafana) with an **MQTT Broker** (Mosquitto) as the ingestion layer.

**The Data Flow:**
1.  **Simulator** generates JSON data (e.g., temperature, location, status).
2.  **Simulator** publishes this data to **Mosquitto** via the **MQTT protocol**.
3.  **Telegraf** subscribes to the MQTT topics, "listens" for new messages, and parses the JSON.
4.  **Telegraf** writes the parsed data into **InfluxDB**.
5.  **Grafana** queries **InfluxDB** to display the data on charts and gauges.

---

## 📦 Container Breakdown

### 1. `iot-simulator` (The Producer)
This container simulates various IoT scenarios like smart cities (traffic sensors), logistics (truck tracking), health (patient vitals), and agriculture (soil moisture). It sends messages every few seconds to the `academy/#` MQTT topic.

*   **Repository**: [YunaCloud-IT/academy-iot-simulator](https://github.com/YunaCloud-IT/academy-iot-simulator)

### 2. `mosquitto` (The MQTT Broker)
Think of Mosquitto as the **Post Office**. It doesn't store data permanently; it just receives messages from "publishers" (the simulator) and delivers them to "subscribers" (Telegraf). It uses the lightweight MQTT protocol, which is the industry standard for IoT.

### 3. `telegraf` (The Data Bridge)
Telegraf is an agent that collects, processes, and aggregates metrics. In this stack, it acts as the bridge between the real-time MQTT world and the storage world. It converts the JSON messages into a format InfluxDB understands.

### 4. `influxdb` (The Database)
InfluxDB is a **Time-Series Database (TSDB)**. Unlike a traditional database (like MySQL), it is optimized for high-speed storage of data points over time. Every piece of data here has a timestamp.

### 5. `grafana` (The Visualization)
Grafana is where you see the results. It connects to InfluxDB and provides a web interface to build and view dashboards.

---

## 📊 Accessing the Dashboard

Once the stack is running, you can view the data live:

1.  **Open your browser** and go to: [http://localhost](http://localhost)
    *   *Note: Anonymous access is enabled. You can view dashboards immediately without logging in.*
2.  **Login (Optional - for editing)**:
    *   **User**: `admin`
    *   **Password**: `213fs32GDas`
3.  **Find the Dashboard**:
    *   Go to **Dashboards** in the left sidebar.
    *   Open the folder (usually "General" or "Provisioned") and look for **"IoT Simulator Dashboard"**.

### What are you seeing?
- **Real-time Gauges**: Current values for things like temperature, heart rate, or battery levels.
- **Time-Series Graphs**: How values have changed over the last few minutes.
- **Alerts**: You might see indicators changing color if the simulator generates an "anomaly" (e.g., a sensor reading going too high).

---

## ☁️ Running on Google Cloud (GCP)

If you want to run this stack in the cloud, follow these steps to set up a Virtual Machine:

### 1. Create a VM Instance
1.  Go to the **Google Cloud Console** > **Compute Engine** > **VM Instances**.
2.  Click **Create Instance**.
3.  **Machine Type**: `e2-micro` or `e2-small` is more than enough for this stack.
4.  **Boot Disk**: Use a standard image like **Ubuntu** or **Debian**.
5.  **Firewall (CRITICAL)**: Check the box **"Allow HTTP traffic"**. This opens port 80, allowing you to access the Grafana dashboard from your browser.
6.  Click **Create**.

### 2. Install Docker
Once your VM is running, click the **SSH** button to open a terminal and run the following commands:

```bash
# Download and run the Docker installation script
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add your user to the docker group to run commands without sudo
sudo usermod -aG docker $USER
# IMPORTANT: Log out of the SSH session and log back in for this to take effect!
```

### 3. Deploy the Stack
1.  **Copy your files** to the VM (using `git clone` or the GCP file upload tool).
2.  Navigate to the folder containing `docker-compose.yml`.
3.  Start the stack:
    ```bash
    docker compose up -d
    ```
4.  **Access the Dashboard**: In the GCP Console, find the **External IP** of your VM. Open that IP address in your browser (e.g., `http://35.200.10.20`).

---

## 🛠️ Handy Commands for Students

**View logs for a specific service (e.g., the simulator):**
```bash
docker-compose logs -f simulator
```

**Restart the stack if something feels stuck:**
```bash
docker-compose restart
```

**Reset everything (deletes all stored data):**
```bash
docker-compose down -v
```
