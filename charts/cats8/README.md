# cats8 Helm Chart

A Helm chart for deploying the cats8 service - a simple web application that displays random cat images.

## Installation

### Add the Helm repository

```bash
helm repo add cats8 https://albal.github.io/cats8
helm repo update
```

### Install the chart

```bash
helm install my-cats8 cats8/cats8
```

Or install from the local chart:

```bash
helm install my-cats8 ./charts/cats8
```

## Configuration

The following table lists the configurable parameters of the cats8 chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas | `1` |
| `image.repository` | Image repository | `ghcr.io/albal/cats8` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `image.tag` | Image tag | `latest` |
| `service.type` | Kubernetes service type | `ClusterIP` |
| `service.port` | Service port | `80` |
| `resources.limits.cpu` | CPU limit | `250m` |
| `resources.limits.memory` | Memory limit | `256Mi` |
| `resources.requests.cpu` | CPU request | `100m` |
| `resources.requests.memory` | Memory request | `128Mi` |
| `html.title` | Page title | `Random Cat Service` |
| `html.refreshInterval` | Auto-refresh interval (ms) | `60000` |
| `html.catApiUrl` | Cat API URL | `https://cataas.com/cat` |
| `nginx.config.serverName` | NGINX server name | `localhost` |
| `nginx.config.healthCheck.enabled` | Enable health check | `true` |
| `nginx.config.healthCheck.path` | Health check path | `/health` |

### Example: Custom values

Create a `my-values.yaml` file:

```yaml
replicaCount: 2

image:
  tag: "v1.0.0"

resources:
  limits:
    cpu: 500m
    memory: 512Mi
  requests:
    cpu: 200m
    memory: 256Mi

html:
  title: "My Custom Cat Service"
  refreshInterval: 30000
```

Install with custom values:

```bash
helm install my-cats8 cats8/cats8 -f my-values.yaml
```

## Uninstallation

```bash
helm uninstall my-cats8
```

## Accessing the Application

After installation, you can access the application by port-forwarding:

```bash
kubectl port-forward service/my-cats8 8080:80
```

Then visit http://localhost:8080 in your browser.

## Features

- Random cat images from cataas.com
- Auto-refresh functionality
- Health check endpoint at `/health`
- Configurable refresh interval
- Lightweight NGINX-based deployment
- Full Kubernetes best practices support
