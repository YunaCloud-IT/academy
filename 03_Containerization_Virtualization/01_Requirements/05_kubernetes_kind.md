# Installing and Using a Local Kubernetes Cluster with kind

`kind` is a tool for running local Kubernetes clusters using Docker container "nodes". It was primarily designed for testing Kubernetes itself, but is a great and lightweight way to get a local Kubernetes cluster for development or learning purposes.

This guide will walk you through the full process of installing `kind`, creating a cluster, deploying a sample application, and installing the popular `k9s` management tool on both macOS and Windows.

Official Documentation: [Kind Website](https://kind.sigs.k8s.io/)

---

## Prerequisites

Before you can install or use `kind`, you **must** have Docker installed and running on your system. The easiest way to get it is by installing Docker Desktop.

- **Download Docker Desktop:** [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)

Make sure the Docker daemon is running before you proceed with creating a cluster.

---

## Installation on macOS

For macOS, the recommended way to install `kind` is by using the [Homebrew](https://brew.sh/) package manager.

### Using Homebrew (Recommended)

1.  Open your terminal.
2.  Run the following command to install `kind`:

    ```sh
    brew install kind
    ```

3.  Verify the installation by checking the version:

    ```sh
    kind --version
    ```
    You should see an output like `kind version v0.23.0`.

### Manual Installation (Alternative)

If you don't use Homebrew, you can install the binary directly.

1.  Open your terminal and download the latest stable binary for macOS:

    ```sh
    # For Intel Macs
    curl -Lo ./kind [https://kind.sigs.k8s.io/dl/v0.23.0/kind-darwin-amd64](https://kind.sigs.k8s.io/dl/v0.23.0/kind-darwin-amd64)

    # For Apple Silicon (M1/M2/M3) Macs
    curl -Lo ./kind [https://kind.sigs.k8s.io/dl/v0.23.0/kind-darwin-arm64](https://kind.sigs.k8s.io/dl/v0.23.0/kind-darwin-arm64)
    ```

2.  Make the binary executable:

    ```sh
    chmod +x ./kind
    ```

3.  Move the binary to a directory in your system's `PATH`:

    ```sh
    sudo mv ./kind /usr/local/bin/kind
    ```

4.  Verify the installation:
    ```sh
    kind --version
    ```

---

## Installation on Windows

For Windows, you can use package managers like [Chocolatey](https://chocolatey.org/) or [Scoop](https://scoop.sh/), or install it manually.

### Using Chocolatey (Recommended)

1.  Open PowerShell as an Administrator.
2.  Run the following command:
    ```powershell
    choco install kind
    ```
3.  Verify the installation in a new terminal window:
    ```powershell
    kind --version
    ```

### Using Scoop

1.  Open PowerShell.
2.  Run the following command:
    ```powershell
    scoop install kind
    ```
3.  Verify the installation:
    ```powershell
    kind --version
    ```

### Manual Installation (Alternative)

1.  Open PowerShell.
2.  Download the latest stable binary:
    ```powershell
    curl.exe -Lo kind-windows-amd64.exe [https://kind.sigs.k8s.io/dl/v0.23.0/kind-windows-amd64](https://kind.sigs.k8s.io/dl/v0.23.0/kind-windows-amd64)
    ```
3.  Move the file to a directory that is in your system's `PATH`. A good practice is to have a dedicated folder for binaries (e.g., `C:\bin`) and add that folder to your `PATH` environment variable.
    ```powershell
    # Example: Move and rename the file
    Move-Item .\kind-windows-amd64.exe C:\bin\kind.exe
    ```
    *Note: You may need to manually add `C:\bin` to your system's PATH variable if you haven't already.*

4.  Verify the installation in a new terminal window:
    ```powershell
    kind --version
    ```

---

## Creating and Using Your First Cluster

Once `kind` is installed, the following steps are the same for both macOS and Windows.

### 1. Create a Cluster

This command will download a node image and create a new Kubernetes cluster in a Docker container.

```sh
kind create cluster
```

### To create a cluster with a specific name

```sh
kind create cluster --name my-test-cluster
```

### Helpful commands

```sh
kubectl cluster-info

kubectl get nodes

kubectl get pods -A
```

## Running Your First Application (nginx)

### Use kubectl run to create a new pod from the nginx image

```sh
kubectl run nginx --image=nginx
```

### Check the status of your pod

```sh
kubectl get pods
```

### Access the Nginx server from your local machine

```sh
kubectl port-forward pod/nginx 8080:80
```

### Delete the pod

```sh
kubectl delete pod nginx
```

## Delete a Cluster

```sh
kind delete cluster

kind delete cluster --name my-test-cluster
```
