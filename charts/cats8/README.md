# Cats8 Helm Chart

A Helm chart for deploying the Cats8 application - a simple web service that displays random cat images from [cataas.com](https://cataas.com).

## TL;DR

```bash
helm repo add cats8 https://albal.github.io/cats8
helm install my-cats8 cats8/cats8
```

## Introduction

This chart bootstraps a Cats8 deployment on a Kubernetes cluster using the Helm package manager. The application serves a responsive web interface that displays random cat images with automatic refresh functionality.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+

## Installing the Chart

To install the chart with the release name `my-cats8`:

```bash
helm install my-cats8 cats8/cats8
```

The command deploys Cats8 on the Kubernetes cluster with default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

### Installing from source

To install directly from the source repository:

```bash
git clone https://github.com/albal/cats8.git
cd cats8
helm install my-cats8 ./charts/cats8
```

## Uninstalling the Chart

To uninstall/delete the `my-cats8` deployment:

```bash
helm uninstall my-cats8
```

## Parameters

### Common parameters

| Name                      | Description                                          | Default Value      |
|---------------------------|------------------------------------------------------|--------------------|
| `replicaCount`            | Number of replicas                                   | `1`                |
| `image.repository`        | Image repository                                     | `nginx`            |
| `image.pullPolicy`        | Image pull policy                                    | `IfNotPresent`     |
| `image.tag`               | Image tag (defaults to chart appVersion)             | `alpine`           |
| `imagePullSecrets`        | Docker registry secret names as an array             | `[]`               |
| `nameOverride`            | String to partially override chart name              | `""`               |
| `fullnameOverride`        | String to fully override release name                | `""`               |

### Service parameters

| Name                      | Description                                          | Default Value      |
|---------------------------|------------------------------------------------------|--------------------|
| `service.type`            | Kubernetes service type                              | `ClusterIP`        |
| `service.port`            | Service port                                         | `80`               |
| `service.targetPort`      | Target port on the container                         | `80`               |

### Resource parameters

| Name                      | Description                                          | Default Value      |
|---------------------------|------------------------------------------------------|--------------------|
| `resources.limits.cpu`    | CPU resource limits                                  | `250m`             |
| `resources.limits.memory` | Memory resource limits                               | `256Mi`            |
| `resources.requests.cpu`  | CPU resource requests                                | `100m`             |
| `resources.requests.memory`| Memory resource requests                            | `128Mi`            |

### Other parameters

| Name                      | Description                                          | Default Value      |
|---------------------------|------------------------------------------------------|--------------------|
| `namespace`               | Namespace to deploy into                             | `cats`             |
| `nodeSelector`            | Node labels for pod assignment                       | `{}`               |
| `tolerations`             | Tolerations for pod assignment                       | `[]`               |
| `affinity`                | Affinity rules for pod assignment                    | `{}`               |
| `labels`                  | Additional labels to apply to all resources          | `{}`               |
| `annotations`             | Additional annotations to apply to all resources     | `{}`               |

## Configuration Examples

### Using a custom image

```bash
helm install my-cats8 cats8/cats8 \
  --set image.repository=ghcr.io/albal/cats8 \
  --set image.tag=v1.0.0
```

### Scaling the deployment

```bash
helm install my-cats8 cats8/cats8 --set replicaCount=3
```

### Using LoadBalancer service

```bash
helm install my-cats8 cats8/cats8 --set service.type=LoadBalancer
```

### Custom resource limits

```bash
helm install my-cats8 cats8/cats8 \
  --set resources.limits.cpu=500m \
  --set resources.limits.memory=512Mi
```

## Accessing the Application

After installation, you can access the application using port-forward:

```bash
kubectl port-forward -n cats service/my-cats8 8080:80
```

Then visit http://localhost:8080 in your browser.

For production deployments, consider:
- Setting `service.type=LoadBalancer` to get an external IP
- Creating an Ingress resource to expose the application
- Using NodePort if you want to access via node IP

## Features

- ✅ Simple one-command deployment
- ✅ Configurable via Helm values
- ✅ Resource limits for cluster efficiency
- ✅ Health check endpoint at `/health`
- ✅ Auto-refresh functionality (every 60 seconds)
- ✅ Responsive, mobile-friendly interface
- ✅ Lightweight NGINX-based serving

## Troubleshooting

### Check pod status

```bash
kubectl get pods -n cats
kubectl describe pod <pod-name> -n cats
```

### View logs

```bash
kubectl logs -n cats deployment/my-cats8
```

### Test the health endpoint

```bash
kubectl exec -n cats deployment/my-cats8 -- curl http://localhost/health
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

See the [LICENSE](../../LICENSE) file for details.
