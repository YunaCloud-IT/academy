# How to Start the iot-simulator with Docker Compose

This guide explains how to run the `iot-simulator` project from the `massimocallisto/iot-simulator` GitHub repository using Docker Compose. This will start the necessary services as defined in the project's configuration.

---

## Prerequisites

Before you begin, you must have the following software installed on your system:

1.  **Git:** To clone the repository.
2.  **Docker and Docker Compose:** To run the containerized application. Make sure the Docker engine is running before you start.
3.  **MQTT Explorer:** To visualize the data being sent by the simulator.

---

## 1. Get the Project Files

Official Git Repository: [Git Repository for IoT Simulator](https://github.com/massimocallisto/iot-simulator)

First, you need to download the repository from GitHub.

* **Open your terminal** or command prompt.
* **Clone the repository** using the following command:

    ```bash
    git clone [https://github.com/massimocallisto/iot-simulator.git](https://github.com/massimocallisto/iot-simulator.git)
    ```

---

## 2. Start the Application

The repository contains a specific folder for the Docker Compose configuration. All commands should be run from that directory.

1.  **Navigate into the correct directory:**
    Change your current directory to the `docker-compose` folder inside the cloned repository.

    ```bash
    cd iot-simulator/docker-compose
    ```

2.  **Run Docker Compose:**
    Use the `docker compose up` command to build the images (if they don't exist) and start all the services. Adding the `-d` (detached) flag is recommended to run the containers in the background.

    ```bash
    docker compose up -d
    ```



    This command will start the IoT simulator. The default configuration in this repository is set to connect to the public Mosquitto MQTT broker (`test.mosquitto.org`), but this guide will show you how to connect to a local instance for verification.

---

## 3. Verify the Services are Running

You can check that the containers have started successfully.

* **List running containers:**
  This command will show you the active containers managed by Docker Compose.

    ```bash
    docker compose ps
    ```

  You should see the `iot-simulator` container in a "running" or "up" state.

* **(Optional) Check the Logs:**
  To see the real-time output from the simulator and ensure it's publishing messages, you can view its logs:

    ```bash
    docker compose logs -f
    ```

  Press `Ctrl + C` to stop viewing the logs.

---

## 4. Connect with MQTT Explorer

Now, let's visualize the data being published by the simulator.

1.  **Start MQTT Explorer.**

2.  **Create a New Connection:**
    In the "Connections" pop-up window, fill in the details for your local MQTT broker. The `docker-compose.yml` in this repository also starts a Mosquitto broker that is accessible from your host machine.
    * **Name:** `Local Docker Broker` (or any name you like)
    * **Host:** `localhost`
    * **Port:** `1883`

3.  **Click Connect.**



4.  **View the MQTT Topics:**
    Once connected, you will see a stream of topics appearing on the left-hand side under `/sample.it/jz/device/`. Clicking on these topics will show you the JSON data payload being sent by the simulator, which updates in real-time.

---

## 5. Stop the Application

When you are finished, you should stop and remove the containers to free up system resources.

1.  **Make sure you are in the `iot-simulator/docker-compose` directory.**

2.  **Run the down command:**
    This command will stop and remove the containers, networks, and volumes created by `docker compose up`.

    ```bash
    docker compose down
    ```

That's it! The simulator and its related services are now stopped. 🚀
