# Cats8 Helm Chart

This Helm chart deploys the Cats Service application - a simple web application that displays random cat images from [cataas.com](https://cataas.com).

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+

## Installing the Chart

To install the chart with the release name `my-cats`:

```bash
helm install my-cats oci://ghcr.io/albal/cats8/charts/cats8
```

Or from a local chart:

```bash
helm install my-cats ./charts/cats8
```

The command deploys the cats8 application on the Kubernetes cluster with default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-cats` deployment:

```bash
helm uninstall my-cats
```

This command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global Parameters

| Name                      | Description                                     | Value                    |
| ------------------------- | ----------------------------------------------- | ------------------------ |
| `replicaCount`            | Number of replicas for the deployment           | `1`                      |
| `namespace`               | Kubernetes namespace to deploy into             | `cats`                   |

### Image Parameters

| Name                      | Description                                     | Value                    |
| ------------------------- | ----------------------------------------------- | ------------------------ |
| `image.repository`        | Container image repository                      | `ghcr.io/albal/cats8`    |
| `image.pullPolicy`        | Image pull policy                               | `IfNotPresent`           |
| `image.tag`               | Overrides the image tag (default is appVersion) | `latest`                 |
| `imagePullSecrets`        | Image pull secrets for private registries       | `[]`                     |

### Service Parameters

| Name                      | Description                                     | Value                    |
| ------------------------- | ----------------------------------------------- | ------------------------ |
| `service.type`            | Kubernetes Service type                         | `ClusterIP`              |
| `service.port`            | Service port                                    | `80`                     |
| `service.targetPort`      | Target container port                           | `80`                     |

### Ingress Parameters

| Name                      | Description                                     | Value                    |
| ------------------------- | ----------------------------------------------- | ------------------------ |
| `ingress.enabled`         | Enable ingress resource creation                | `false`                  |
| `ingress.className`       | Ingress class name (e.g., nginx, traefik)       | `""`                     |
| `ingress.annotations`     | Annotations for the ingress resource            | `{}`                     |
| `ingress.hostname`        | Hostname for the ingress resource               | `chart-example.local`    |
| `ingress.path`            | Path for the ingress rule                       | `/`                      |
| `ingress.pathType`        | Path type (Prefix, Exact, ImplementationSpecific) | `Prefix`               |
| `ingress.tls.enabled`     | Enable TLS/HTTPS for ingress                    | `false`                  |
| `ingress.tls.secretName`  | Secret name for TLS certificate                 | `""`                     |

### Resource Parameters

| Name                      | Description                                     | Value                    |
| ------------------------- | ----------------------------------------------- | ------------------------ |
| `resources.limits.cpu`    | CPU limit                                       | `250m`                   |
| `resources.limits.memory` | Memory limit                                    | `256Mi`                  |
| `resources.requests.cpu`  | CPU request                                     | `100m`                   |
| `resources.requests.memory` | Memory request                                | `128Mi`                  |

### Probe Parameters

| Name                              | Description                           | Value                    |
| --------------------------------- | ------------------------------------- | ------------------------ |
| `livenessProbe.enabled`           | Enable liveness probe                 | `true`                   |
| `livenessProbe.httpGet.path`      | Liveness probe HTTP path              | `/health`                |
| `livenessProbe.initialDelaySeconds` | Initial delay for liveness probe    | `30`                     |
| `readinessProbe.enabled`          | Enable readiness probe                | `true`                   |
| `readinessProbe.httpGet.path`     | Readiness probe HTTP path             | `/health`                |
| `readinessProbe.initialDelaySeconds` | Initial delay for readiness probe  | `5`                      |

### Other Parameters

| Name                      | Description                                     | Value                    |
| ------------------------- | ----------------------------------------------- | ------------------------ |
| `nameOverride`            | Override the chart name                         | `""`                     |
| `fullnameOverride`        | Override the full name                          | `""`                     |
| `nodeSelector`            | Node labels for pod assignment                  | `{}`                     |
| `tolerations`             | Tolerations for pod assignment                  | `[]`                     |
| `affinity`                | Affinity rules for pod assignment               | `{}`                     |
| `podAnnotations`          | Annotations for pods                            | `{}`                     |
| `podLabels`               | Labels for pods                                 | `{app: cats}`            |

## Configuration and Installation Details

### Customizing the HTML Content

You can customize the HTML content served by the application by setting the `htmlContent` value:

```bash
helm install my-cats ./charts/cats8 --set-file htmlContent=./my-custom-content.html
```

Or create a `custom-values.yaml` file:

```yaml
htmlContent: |
  <!DOCTYPE html>
  <html>
  <head><title>My Custom Page</title></head>
  <body><h1>Custom Content</h1></body>
  </html>
```

And install with:

```bash
helm install my-cats ./charts/cats8 -f custom-values.yaml
```

### Exposing the Service

By default, the service is created as `ClusterIP`. To expose it externally:

**Using LoadBalancer:**

```bash
helm install my-cats ./charts/cats8 --set service.type=LoadBalancer
```

**Using NodePort:**

```bash
helm install my-cats ./charts/cats8 --set service.type=NodePort
```

**Using Ingress (recommended for production):**

Basic Ingress with nginx ingress controller:

```bash
helm install my-cats ./charts/cats8 \
  --set ingress.enabled=true \
  --set ingress.className=nginx \
  --set ingress.hostname=cats.example.com
```

Ingress with TLS and cert-manager:

```bash
helm install my-cats ./charts/cats8 \
  --set ingress.enabled=true \
  --set ingress.className=nginx \
  --set ingress.hostname=cats.example.com \
  --set ingress.tls.enabled=true \
  --set ingress.tls.secretName=cats-tls \
  --set ingress.annotations."cert-manager\.io/cluster-issuer"=letsencrypt-prod
```

Or using a values file:

```yaml
ingress:
  enabled: true
  className: nginx
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
  hostname: cats.example.com
  path: /
  pathType: Prefix
  tls:
    enabled: true
    secretName: cats-tls
```

### Scaling

To scale the deployment:

```bash
helm upgrade my-cats ./charts/cats8 --set replicaCount=3
```

Or scale using kubectl:

```bash
kubectl scale deployment my-cats-cats8 --replicas=3 -n cats
```

## Health Checks

The application provides a health check endpoint at `/health` that returns HTTP 200 with "healthy" text.

Test the health endpoint:

```bash
kubectl port-forward -n cats service/my-cats-cats8 8080:80
curl http://localhost:8080/health
```

## Troubleshooting

### Check pod status

```bash
kubectl get pods -n cats
kubectl describe pod <pod-name> -n cats
```

### View logs

```bash
kubectl logs -n cats deployment/my-cats-cats8
```

### Check service

```bash
kubectl get service -n cats
kubectl describe service my-cats-cats8 -n cats
```

### Test connectivity

```bash
kubectl port-forward -n cats service/my-cats-cats8 8080:80
# Then visit http://localhost:8080 in your browser
```

## Upgrading

To upgrade the release with new values:

```bash
helm upgrade my-cats ./charts/cats8 -f custom-values.yaml
```

## Values File Example

Here's a complete example of a custom values file:

```yaml
replicaCount: 2
namespace: production

image:
  repository: ghcr.io/albal/cats8
  tag: "v1.0.0"
  pullPolicy: Always

service:
  type: LoadBalancer
  port: 80

resources:
  limits:
    cpu: 500m
    memory: 512Mi
  requests:
    cpu: 200m
    memory: 256Mi

nodeSelector:
  disktype: ssd

podAnnotations:
  prometheus.io/scrape: "true"
  prometheus.io/port: "80"
```

## Contributing

To contribute to this chart, please submit a pull request to the [repository](https://github.com/albal/cats8).

## License

This chart is licensed under the same license as the cats8 application. See the [LICENSE](../../LICENSE) file for details.
