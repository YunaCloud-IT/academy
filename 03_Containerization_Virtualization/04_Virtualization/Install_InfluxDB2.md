# How to Install InfluxDB 2 on Ubuntu

This guide will walk you through the process of installing InfluxDB 2 on an Ubuntu server using the official InfluxData repository. 📈

---

## Prerequisites

Before you begin, you'll need:
* An Ubuntu server (20.04, 22.04, or newer is recommended).
* A user account with `sudo` privileges.
* Access to a terminal or command-line interface.

---

## Step 1: Install InfluxDB 2

Official Documentation: [InfluxData Installation Instructions](https://docs.influxdata.com/influxdb/v2/install/?t=Linux&dl=oss&code_lang=bash&code_lines=12&code_type=code&section=Install%2520InfluxDB%2520as%2520a%2520service%2520with%2520systemd&first_line=%2523%2520Ubuntu%2520and%2520Debian)

With the repository configured, update your local package index and then install the influxdb2 package.

```
# Ubuntu and Debian
# Add the InfluxData key to verify downloads and add the repository
curl --silent --location -O https://repos.influxdata.com/influxdata-archive.key
```

```
gpg --show-keys --with-fingerprint --with-colons ./influxdata-archive.key 2>&1 \
| grep -q '^fpr:\+24C975CBA61A024EE1B631787C3D57159FC2F927:$' \
&& cat influxdata-archive.key \
| gpg --dearmor \
| sudo tee /etc/apt/keyrings/influxdata-archive.gpg > /dev/null \
&& echo 'deb [signed-by=/etc/apt/keyrings/influxdata-archive.gpg] https://repos.influxdata.com/debian stable main' \
| sudo tee /etc/apt/sources.list.d/influxdata.list
```

```
# Install influxdb
sudo apt-get update && sudo apt-get install influxdb2 -y
```

## Step 2: Start and Enable the InfluxDB Service
After the installation is complete, start the InfluxDB service and enable it to run automatically on system boot using systemctl.

```
# Start the service now
sudo systemctl start influxdb

# Enable the service to start automatically on boot
sudo systemctl enable influxdb
```

You can verify that the service is running correctly with the following command:

```
sudo systemctl status influxdb
```

You should see an active (running) status in the output, indicating success.

## Step 5: Perform Initial Setup

InfluxDB is now running, but it requires a one-time setup to create your primary user, organization, bucket, and authentication token. This can be done through the web interface or the command-line interface (CLI).

The default port for InfluxDB is 8086.

Option A: Setup via Web UI (Recommended)

Open a web browser and navigate to `http://<your-server-ip>:8086`

Click Get Started.

Fill out the setup form to create your initial:

- Username: The name for your primary admin user.

- Password: A strong password for this user.

- Organization Name: A name for your organization (e.g., "My Company").

- Bucket Name: The name for your first data bucket (e.g., "iot-sensors").

## Step 6: Configure Firewall (Optional but Recommended)

If you're using a firewall like UFW (Uncomplicated Firewall), you must allow traffic on port 8086 to access the InfluxDB web UI and API from other machines.

```
# Allow incoming traffic on port 8086
sudo ufw allow 8086/tcp

# Reload the firewall to apply the new rule
sudo ufw reload
```

Congratulations! 🎉 InfluxDB 2 is now successfully installed and configured on your Ubuntu system. You can now start sending data to your first bucket.
