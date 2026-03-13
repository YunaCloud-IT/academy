# Cloud Monitoring

This lab teaches you how to monitor a Compute Engine virtual machine (VM) using Cloud Monitoring. Cloud Monitoring provides visibility into the performance, uptime, and overall health of cloud-powered applications by collecting metrics, events, and metadata from various sources. It ingests this data to generate insights through dashboards, charts, and alerting systems.

## Preparation

Certain Compute Engine resources live in regions and zones. A region is a specific geographical location where you can run your resources. Each region has one or more zones.

Run the following gcloud commands in Cloud Shell to set the default region and zone for your lab:

```
geloud config set compute/zone "europe-west4-a* 
export ZONE=$(gcloud config get compute/zone)

gcloud config set compute/region "europe-west4" 
export REGION=S(gcloud config get compute/region)
```

## 1. Create a Compute Engine Instance

The first step is to provision the virtual machine that you will monitor.

- Navigate to **Compute Engine** > **VM Instances** and create a new instance
- Name the instance `lamp-1-vm`
- Set the Region to `europe-west4` and the Zone to `europe-west4-a`
- Set the Series to `E2` and select `e2-medium` for the Machine type
- Click **OS and storage** on the sidebar
- Configure the Boot Disk to use Debian GNU/Linux 12 (bookworm)
- Under **Networking**, select "Allow HTTP traffic" for the Firewall
- Create the instance

## 2. Add Apache2 HTTP Server and Agents

Next, you will configure the VM as a web server and install the necessary monitoring agents.

- Open an SSH terminal to your `lamp-1-vm` instance
- Install the Apache2 HTTP server by running `sudo apt-get update` followed by `sudo apt-get install apache2 php7.0`
- Restart the service using `sudo service apache2 restart`
- Verify the setup by checking the External IP of the VM in your browser to see the default Apache2 page
- In the SSH terminal download the script to install the Cloud Monitoring agent:

```
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
```

- Run the provided curl and bash scripts with `sudo bash add-google-cloud-ops-agent-repo.sh --also-install`
- If asked if you want to continue, press **Y**
- Run the Logging agent install script command in the SSH terminal of your VM instance to install the Cloud Logging agent:

```
sudo systemctl status google-cloud-ops-agent"*"
```

- Press **q** to exit the status
- Update the system with `sudo apt-get update`

## 3. Create an Uptime Check

Uptime checks verify that your resource remains consistently accessible.

- In the Cloud Console, in the left menu, navigate to **Uptime checks** and click **Create Uptime Check**
- Select **HTTP** for **Protocol** and **URL** for **Resource Type**
- Use the **External IP** of your VM as the **Hostname**
- Set the **Check Frequency** to **1 minute**
- Click **Continue** until you reach the last page
- Name the check "Lamp Uptime Check" and click **Create**

## 4. Create an Alerting Policy

Alerting policies notify you when specific metric thresholds are crossed

- Navigate to **Alerting** and select **Create Policy**
- Click on **Select a metric** dropdown. Uncheck the **Active**
- Filter by resource and metric name to select **VM instance** > **Interface** > **Network traffic**
- Set the **Threshold position** to `Above threshold`, the **Theshold value** to `500`, and the **Retest window** to `1 minute`
- Click on **Manage Notification Channels** in the drop down **Notification Channels** to add a new Email channel with your personal email address
- On the last page name the alert "Inbound Traffic Alert" and create the policy

## 5. Create a Dashboard and Chart

You can visualize your collected metrics using custom dashboards

- Navigate to **Dashboards** (shown in the sidebar) and select **+Create Custom Dashboard**
- Name the dashboard "Cloud Monitoring LAMP Qwik Start Dashboard"
- Add a Line chart widget titled "CPU Load" tracking the metric **VM instance** > **Cpu** > `CPU load (1m)`
- Add a second Line chart widget titled "Received Packets" tracking the metric **VM instance** > **Instance** > `Received packets`

## 6. View Your Logs

Cloud Logging integrates with Monitoring to track system events

- Navigate to Logging > Logs Explorer
- Filter the resources to select your lamp-1-vm instance
- To see the logs in action, go to the Compute Engine page, stop your VM instance, and watch the corresponding log entries generate in the Logs Explorer
- Restart the instance and monitor the startup logs.

## 7. Check Results and Alerts

Review the tools you set up once they have had time to collect data

- Navigate back to **Monitoring** > **Uptime checks** to view the status of the "Lamp Uptime Check"
- Go to **Alerting** to check for any listed incidents or events
- Check your personal email inbox for any triggered Cloud Monitoring Alerts

