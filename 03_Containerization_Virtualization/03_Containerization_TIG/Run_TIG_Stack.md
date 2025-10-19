# How to Run a TIG Stack (Telegraf, InfluxDB, Grafana) with Docker Compose

This guide explains how to use the `jersonmartinez/docker-compose-influxdb-telegraf-grafana` repository to quickly deploy a full TIG stack. Additionally, it includes instructions on how to modify the Telegraf configuration to subscribe to an MQTT broker on `localhost:1883`.

---

## Overview of the Stack

This Docker Compose setup launches three key services for monitoring and data visualization:

* **InfluxDB**: A time-series database used to store metrics and events.
* **Telegraf**: A server agent for collecting and reporting metrics. We will configure it to collect data from an MQTT broker.
* **Grafana**: A visualization tool for creating dashboards from data stored in InfluxDB.


---

## Prerequisites

Before starting, ensure you have **Docker** and **Docker Compose** installed on your system. The Docker engine must be running.

---

## 1. Get the Repository

First, clone the project files from GitHub to your local machine.

* **Open your terminal** or command prompt.
* **Run the following command:**

    ```bash
    git clone [https://github.com/jersonmartinez/docker-compose-influxdb-telegraf-grafana.git](https://github.com/jersonmartinez/docker-compose-influxdb-telegraf-grafana.git)
    ```

---

## 2. Configure Telegraf for MQTT

Next, we need to edit the Telegraf configuration file to tell it where to get data. We will add a new input to subscribe to all topics (`#`) from an MQTT broker running on your local machine.

1.  **Navigate into the repository folder:**
    ```bash
    cd docker-compose-influxdb-telegraf-grafana
    ```

2.  **Open the Telegraf configuration file:**
    The file is located at `telegraf/telegraf.conf`. Open it with your favorite text editor.

3.  **Add the MQTT input configuration:**
    Scroll to the end of the `[[inputs.cpu]]` section (or anywhere under the `INPUT PLUGINS` section) and **add the following block of code**. This configures Telegraf to listen to an MQTT broker.

    ```toml
    # ###############################################################################
    # #                           INPUT PLUGINS                                     #
    # ###############################################################################

    # Read metrics from MQTT topic(s)
    [[inputs.mqtt_consumer]]
      ## Broker URLs
      servers = ["tcp://host.docker.internal:1883"]

      ## Topics to subscribe to
      topics = [
        "#"
      ]

      ## Data format to consume.
      ## Each data format has its own unique set of configuration options, please
      ## see the README for details.
      data_format = "json"

      ## Optional credentials
      # username = "user"
      # password = "password"

    # Read metrics about cpu usage
    [[inputs.cpu]]
      ## Whether to report per-cpu stats or not
      percpu = true
    ```
    > **Important Note:** We use `host.docker.internal` instead of `localhost`. This is a special DNS name that allows the Telegraf container to connect to a service running on your host machine (the machine running Docker).

4.  **Save and close** the `telegraf/telegraf.conf` file.

---

## 3. Launch the Stack

Now you are ready to start all the services.

1.  **Make sure you are in the root directory** of the cloned repository.
2.  **Run Docker Compose:**
    The `-d` flag starts the containers in detached mode (in the background).

    ```bash
    docker-compose up -d
    ```
    Docker will now download the necessary images and start the InfluxDB, Telegraf, and Grafana containers.

---

## 4. Access the Services

The services are exposed on the following default ports:

* **Grafana**: `http://localhost:3000`
    * Default login: **user:** `admin`, **password:** `admin`
* **InfluxDB API**: `http://localhost:8086`

You can now log into Grafana, add InfluxDB as a data source, and start building dashboards to visualize the data collected by Telegraf from your MQTT broker.

---

## 5. Stop the Stack

When you are finished, you can stop and remove all the containers and networks.

1.  **Make sure you are in the repository's root directory.**
2.  **Run the down command:**
    ```bash
    docker-compose down
    ```
This will cleanly shut down the entire stack.

---

# Troubleshooting

## ARM Chips

For ARM Chips (e.g., MacOS) you can use [Docker Compose](docker-compose.yml)

## Networks

If `docker compose up -d` is not working, remove the network stack like in [Docker Compose](docker-compose.yml)
