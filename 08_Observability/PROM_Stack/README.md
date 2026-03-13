# ShopWorld Observability Stack Documentation

This documentation outlines the deployment of the `shopworld-backend` service alongside a complete monitoring stack using **Prometheus** (metrics collection) and **Grafana** (visualization).

## Prerequisites
* Docker installed
* Docker Compose (optional, but recommended)

---

## Approach 1: Docker Compose (Recommended)
The most robust way to run this stack is using Docker Compose. This ensures all containers share a network and restart automatically.

### 1. Create `docker-compose.yml`
Save the following content into a file named `docker-compose.yml`.

```yaml
services:
  # The Application
  shopworld-backend:
    image: itchimonji/shopworld-backend:v12-3d97ebf
    container_name: shopworld-backend
    ports:
      - "3000:3000"
    networks:
      - monitoring-net
    restart: unless-stopped

  # Metrics Database
  prometheus:
    image: prom/prometheus
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/usr/share/prometheus/console_libraries'
      - '--web.console.templates=/usr/share/prometheus/consoles'
    networks:
      - monitoring-net
    depends_on:
      - shopworld-backend

  # Visualization
  grafana:
    image: grafana/grafana-oss
    container_name: grafana
    ports:
      - "3001:3000" # Mapped to 3001 to avoid conflict with backend
    volumes:
      - grafana_data:/var/lib/grafana
    networks:
      - monitoring-net
    depends_on:
      - prometheus

networks:
  monitoring-net:
    driver: bridge

volumes:
  prometheus_data:
  grafana_data:
```

### 2. Create prometheus.yml

In the same directory, create your config file. Note: We use the container name `shopworld-backend` as the target, not `host.docker.internal`.

```
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'shop-world'
    metrics_path: '/api/metrics'
    static_configs:
      - targets: ['shopworld-backend:3000']
```
### 3. Start the Stack

```Bash
docker-compose up -d
```

------------------------------

## Approach 2: Manual Docker CLI

If you prefer running individual commands, follow these steps. We will create a dedicated network to allow the containers to communicate securely.

### 1. Create a Network

```
docker network create shop-net
```

### 2. Run the Backend

```
docker run -d \
  --name shopworld-backend \
  --network shop-net \
  -p 3000:3000 \
  itchimonji/shopworld-backend:v12-3d97ebf
```

### 3. Configure and Run Prometheus

Create a `prometheus.yml` file in your current directory with the following content (using the container name as the host):

```
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'shop-world'
    metrics_path: '/api/metrics'
    static_configs:
      - targets: ['shopworld-backend:3000']
```

Run the container:

```
docker run -d \
  --name prometheus \
  --network shop-net \
  -p 9090:9090 \
  -v $(pwd)/prometheus.yml:/etc/prometheus/prometheus.yml \
  -v prometheus_data:/prometheus \
  prom/prometheus
```

### 4. Run Grafana

```
docker run -d \
  --name=grafana \
  --network shop-net \
  -p 3001:3000 \
  grafana/grafana-oss
```

------------------------------

## Grafana Configuration Steps

Once the containers are running, follow these steps to visualize the data.

1. Access Grafana: Open http://localhost:3001 in your browser.

2. Login: Default credentials are `admin` / `admin`. You will be asked to change the password.

3. Add Data Source:

    - Go to Connections > Data Sources > Add data source.

    - Select Prometheus.

    - Connection URL: * If using the Docker Network methods above: `http://prometheus:9090`

    - *Note: Do not use localhost here, as Grafana is running inside a container.*

    - Click Save & Test.

4. Import Dashboard:

    - Go to Dashboards > New > Import.

   - Enter ID: `11159` (NodeJS Application Dashboard).

   - Click Load.

   - Select your Prometheus data source from the dropdown.

   - Click Import.

## Troubleshooting

- Endpoint Missing: Ensure your backend actually exposes metrics at `/api/metrics`. Standard Prometheus libraries often default to `/metrics`.

- Host Docker Internal: If you must use `host.docker.internal` (e.g., if running the backend natively on your Mac but Prometheus in Docker), you must add `--add-host host.docker.internal:host-gateway` to your `docker run` command on Linux. The network approach used above is cleaner.
