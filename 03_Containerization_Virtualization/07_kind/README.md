# Local Kubernetes Cluster Setup with Kind

This project sets up a local Kubernetes cluster using [Kind](https://kind.sigs.k8s.io/) (Kubernetes in Docker). The cluster is configured with 1 control plane node and 2 worker nodes, including specific port mappings and volume mounts for local development.

## Prerequisites

* **Docker:** Ensure Docker Desktop or the Docker engine is running.
* **Kind:** [Install Kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installation) if you haven't already.
* **Kubectl:** [Install kubectl](https://kubernetes.io/docs/tasks/tools/) to interact with the cluster.

## Cluster Configuration

The cluster is defined in `kind-config.yaml`.

**Topology:**
* 1 Control Plane Node
* 2 Worker Nodes

**Enhancements (Control Plane):**
* **Port Mapping:** Maps local port `8080` to container port `30080`. This allows you to access NodePort services exposed on port 30080 via `localhost:8080`.
* **Volume Mount:** Mounts the local directory `./cluster-data` to `/var/local-path-provisioner` inside the node. This ensures data persistence across cluster restarts.

## Quick Start

### 1. Prepare Local Storage
Create the directory for persistent storage to ensure permissions are handled correctly.

```bash
mkdir -p ./cluster-data
```

### 2. Create the Configuration File

Save the following content as `kind-config.yaml`:

```
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
    extraPortMappings:
      - containerPort: 30080
        hostPort: 8080
    extraMounts:
      - hostPath: ./cluster-data
        containerPath: /var/local-path-provisioner
  - role: worker
  - role: worker
```

### 3. Start the Cluster

Run the following command to spin up the cluster:

```
kind create cluster --config kind-config.yaml --name cluster-1
```

### 4. Verify Installation

Check that all nodes are in a `Ready` state:

```
kubectl get nodes
```

## Usage

### Accessing Services

To view a service running on the cluster:

1. Expose your deployment or pod using type: `NodePort`.

2. Set the `nodePort` specifically to `30080`.

3. Open your browser to `http://localhost:8080`.

### Data Persistence

Any data written by the control plane node to `/var/local-path-provisioner` will appear in your local `./cluster-data` directory.

## Teardown

To stop and delete the cluster (this will not delete your ./cluster-data folder):

```
kind delete cluster --name cluster-1
```

## NgINX

### How to Deploy

Apply the configuration:

```
kubectl apply -f ./manifest_files/nginx.yaml
```

Verify the pods and service:

```
kubectl get pods,svc
```

### How the Connection Works
This setup relies on a chain of port mappings that directs traffic from your browser to the Nginx pod.

Browser: Requests `http://localhost:8080`

Docker (Kind): Forwards `localhost:8080` -> Kind Node `30080` (defined in `extraPortMappings`)

Kubernetes Service: Listens on NodePort `30080` and routes to -> Service Port `80`

Nginx Pod: Receives traffic on Container Port `80`

### Test It
Open your browser to: http://localhost:8080

### Restart

```
kubectl rollout restart deployment/nginx-deployment
```

### How the ConfigMap Works

1. ConfigMap: Stores the HTML content as data in the cluster.

2. Volume: The Deployment defines a volume that acts as a bridge to that ConfigMap.

3. Mount: When the Pod starts, Kubernetes takes the data from the ConfigMap and places it at `/usr/share/nginx/html/index.html` inside the container, effectively overwriting the default Nginx file.

## IoT Stack (TIG Stack & IoT Simulator)

We've converted the Docker Compose configuration into a single unified Kubernetes manifest under `manifest_files/iot-stack.yaml`. This stack deploys InfluxDB v2, Eclipse Mosquitto (MQTT Broker), Telegraf, Grafana, and an IoT Simulator.

### How to Deploy

Apply the configuration:

```bash
kubectl apply -f ./manifest_files/iot-stack.yaml
```

Verify that all PVCs, ConfigMaps, Services, and Pods are running:

```bash
kubectl get pvc,configmap,svc,pods -l "app in (influxdb, mosquitto, telegraf, grafana, iot-simulator)"
```

### Accessing the Services in Kind (Local Development)

Because Kind only maps specific ports to your host, you can access the IoT stack services locally using `kubectl port-forward`:

* **Grafana Dashboard:**
  ```bash
  kubectl port-forward svc/grafana 3000:80
  ```
  Open [http://localhost:3000](http://localhost:3000) (Admin credentials: `admin` / `213fs32GDas`). The datasource (InfluxDB) and the "Academy IoT Simulator Dashboard" are pre-provisioned and ready to go!
  
* **IoT Simulator UI:**
  ```bash
  kubectl port-forward svc/iot-simulator 8080:8080
  ```
  Open [http://localhost:8080](http://localhost:8080) to interact with the simulated devices.

* **Mosquitto (MQTT Broker):**
  ```bash
  kubectl port-forward svc/mosquitto 1883:1883
  ```
  You can connect your local MQTT Explorer to `localhost:1883`.

### Accessing the Services in GKE (Production Cloud)

For production GKE deployments, an additional service `grafana-lb` of `type: LoadBalancer` is included. This automatically provisions a Google Cloud Load Balancer with a public external IP.

Find the external IP once GKE has provisioned it:

```bash
kubectl get svc grafana-lb
```

Open your browser to `http://<EXTERNAL_IP>` to access your Grafana dashboard securely from anywhere.

## Metrics Server

### Step 1: Install the Metrics Server

Run this standard command to apply the official manifest:

```
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

### Step 2: Patch for Kind

Now, patch the deployment to allow insecure TLS communication. Copy and run this entire block:

```
kubectl patch deployment metrics-server -n kube-system --type='json' -p='[
  {"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}
]'
```

### Step 3: Verify

Wait about 60 seconds for the metrics server to gather its first batch of data. You can check the status of the pod here:

```
kubectl get pods -n kube-system -l k8s-app=metrics-server
```

Once the pod is `Running` (and 1/1 ready), run the command you've been waiting for:

```
kubectl top nodes
```

You can also check your specific Nginx pods:

```
kubectl top pod
```

### Metrics Server: What's happening?
1. cAdvisor: Inside every node (kubelet), a tool called cAdvisor collects usage stats.

2. Collection: The Metrics Server scrapes this data every few seconds.

3. API: It exposes this data via the Kubernetes API so commands like kubectl top (and autoscalers) can read it.

Since you now have Requests/Limits configured and the Metrics Server running, you have the exact prerequisites needed for autoscaling.

