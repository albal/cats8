# 🐱 Cats Service - Random Cat Image Display

A simple Kubernetes deployment that serves a web application displaying random cat images from [cataas.com](https://cataas.com). This application is built using NGINX to serve a static HTML page with JavaScript that fetches and displays random cat images.

## 📋 What This Deployment Does

This Kubernetes deployment creates a web service that:

- Displays random cat images from the Cat as a Service (cataas.com) API
- Automatically refreshes with new cat images every 60 seconds
- Allows manual refresh with a "Get New Cat!" button
- Provides a responsive, mobile-friendly interface with a gradient background
- Includes error handling for failed image loads
- Offers a health check endpoint at `/health`

## 🏗️ Architecture

The deployment consists of the following Kubernetes resources:

### 1. **Deployment** (`cats-deployment.yaml`)
- **Image**: `nginx:alpine` - Lightweight NGINX web server
- **Replicas**: 1 instance
- **Resources**: 
  - CPU: 100m request, 250m limit
  - Memory: 128Mi request, 256Mi limit
- **Port**: Exposes port 80 for HTTP traffic
- **Volumes**: Mounts ConfigMaps for HTML content and NGINX configuration

### 2. **Service** (`cats-service.yaml`)
- **Type**: ClusterIP (default)
- **Port**: 80 (HTTP)
- Provides network access to the cats application within the cluster

### 3. **ConfigMaps**
#### HTML Content (`cats-configmap.yaml`)
- Contains the complete HTML page with embedded CSS and JavaScript
- Features responsive design with gradient background
- Includes cat image display, loading states, and error handling
- Auto-refresh functionality every 60 seconds

#### NGINX Configuration (`cats-nginx-config.yaml`)
- Custom NGINX server configuration
- Disables caching for dynamic content
- Provides `/health` endpoint for health checks
- Serves static content from `/usr/share/nginx/html`

## 🚀 Deployment Instructions

### Prerequisites
- Kubernetes cluster access
- `kubectl` configured to communicate with your cluster

### Deploy the Application

1. **Create the namespace** (if it doesn't exist):
   ```bash
   kubectl create namespace cats
   ```

2. **Apply all Kubernetes manifests**:
   ```bash
   kubectl apply -f cats-configmap.yaml
   kubectl apply -f cats-nginx-config.yaml
   kubectl apply -f cats-deployment.yaml
   kubectl apply -f cats-service.yaml
   ```

   Or deploy everything at once:
   ```bash
   kubectl apply -f .
   ```

3. **Verify the deployment**:
   ```bash
   kubectl get pods -n cats
   kubectl get services -n cats
   ```

## 🔍 Accessing the Application

### Port Forward (for testing)
```bash
kubectl port-forward -n cats service/cats-service 8080:80
```
Then visit: http://localhost:8080

### Ingress (for production)
To expose the service externally, you'll need to create an Ingress resource or change the service type to `LoadBalancer` or `NodePort`.

Example Ingress:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: cats-ingress
  namespace: cats
spec:
  rules:
  - host: cats.yourdomain.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: cats-service
            port:
              number: 80
```

## 🔧 Customization

### Modify the HTML Content
Edit the `cats-configmap.yaml` file to change:
- Page title and styling
- Auto-refresh interval (currently 60 seconds)
- Cat image source or API endpoints
- Add new features or functionality

After making changes, apply the updated ConfigMap:
```bash
kubectl apply -f cats-configmap.yaml
kubectl rollout restart deployment/cats-deployment -n cats
```

### Scaling
To increase the number of replicas:
```bash
kubectl scale deployment cats-deployment --replicas=3 -n cats
```

### Resource Limits
Modify the resource requests and limits in `cats-deployment.yaml` based on your cluster's capacity and requirements.

## 🩺 Health Checks

The application provides a health check endpoint:
```bash
curl http://<service-ip>/health
```
Returns: `healthy` (HTTP 200)

## 🧹 Cleanup

To remove all resources:
```bash
kubectl delete -f .
```

Or delete individual resources:
```bash
kubectl delete deployment cats-deployment -n cats
kubectl delete service cats-service -n cats
kubectl delete configmap cats-html cats-nginx-config -n cats
```

## 🛠️ Troubleshooting

### Check Pod Status
```bash
kubectl get pods -n cats
kubectl describe pod <pod-name> -n cats
```

### View Logs
```bash
kubectl logs -n cats deployment/cats-deployment
```

### Check ConfigMaps
```bash
kubectl get configmap -n cats
kubectl describe configmap cats-html -n cats
```

## 📝 Features

- ✅ Responsive web design
- ✅ Automatic image refresh every 60 seconds
- ✅ Manual refresh button
- ✅ Loading states and error handling
- ✅ Health check endpoint
- ✅ Lightweight NGINX-based serving
- ✅ Kubernetes-native configuration via ConfigMaps
- ✅ Resource limits for cluster efficiency

---

*This deployment demonstrates a simple but complete web application running on Kubernetes, showcasing ConfigMaps, Deployments, Services, and basic web development practices.*