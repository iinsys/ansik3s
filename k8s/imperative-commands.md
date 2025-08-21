# Imperative kubectl Commands Reference

This file contains common imperative kubectl commands for testing and managing the k3s cluster.

## Namespace Management

```bash
# Create namespace
kubectl create namespace my-namespace

# Delete namespace (and all resources)
kubectl delete namespace my-namespace

# List namespaces
kubectl get namespaces
```

## Pod Management

```bash
# Create a simple pod
kubectl run my-pod --image=nginx:alpine

# Create pod with specific namespace
kubectl run my-pod --image=nginx:alpine -n my-namespace

# Create pod with command
kubectl run busybox --image=busybox --command -- sleep 3600

# Delete pod
kubectl delete pod my-pod

# Get pod details
kubectl describe pod my-pod

# Get pod logs
kubectl logs my-pod

# Execute command in pod
kubectl exec -it my-pod -- /bin/sh
```

## Deployment Management

```bash
# Create deployment
kubectl create deployment my-app --image=nginx:alpine

# Create deployment with replicas
kubectl create deployment my-app --image=nginx:alpine --replicas=3

# Scale deployment
kubectl scale deployment my-app --replicas=5

# Update deployment image
kubectl set image deployment/my-app nginx=nginx:latest

# Rollback deployment
kubectl rollout undo deployment/my-app

# Check deployment status
kubectl rollout status deployment/my-app
```

## Service Management

```bash
# Expose deployment as service
kubectl expose deployment my-app --port=80 --target-port=80

# Expose with specific type
kubectl expose deployment my-app --port=80 --target-port=80 --type=NodePort

# Get service details
kubectl get svc my-app

# Delete service
kubectl delete svc my-app
```

## ConfigMap and Secret Management

```bash
# Create configmap from literal values
kubectl create configmap my-config --from-literal=key1=value1 --from-literal=key2=value2

# Create configmap from file
kubectl create configmap my-config --from-file=config.properties

# Create secret from literal values
kubectl create secret generic my-secret --from-literal=username=admin --from-literal=password=secret

# Create secret from file
kubectl create secret generic my-secret --from-file=./secret.txt
```

## Storage Management

```bash
# Create PVC (requires YAML)
kubectl create -f pvc.yaml

# Get PVC status
kubectl get pvc

# Delete PVC
kubectl delete pvc my-pvc
```

## Resource Inspection

```bash
# Get all resources in namespace
kubectl get all -n my-namespace

# Get pods with wide output
kubectl get pods -o wide

# Get resources with labels
kubectl get pods -l app=my-app

# Describe resource
kubectl describe pod my-pod

# Get resource YAML
kubectl get pod my-pod -o yaml
```

## Port Forwarding

```bash
# Forward local port to service
kubectl port-forward svc/my-service 8080:80

# Forward local port to pod
kubectl port-forward pod/my-pod 8080:80
```

## Resource Quotas and Limits

```bash
# Create resource quota
kubectl create quota my-quota --hard=cpu=1,memory=1Gi,pods=10

# Create limit range
kubectl create limitrange my-limits --min=cpu=50m,memory=50Mi --max=cpu=500m,memory=500Mi
```

## Node Management

```bash
# Get node information
kubectl get nodes -o wide

# Describe node
kubectl describe node my-node

# Cordon node (prevent scheduling)
kubectl cordon my-node

# Uncordon node
kubectl uncordon my-node

# Drain node (evict pods)
kubectl drain my-node --ignore-daemonsets
```

## Troubleshooting Commands

```bash
# Get events
kubectl get events --sort-by=.metadata.creationTimestamp

# Get events for specific namespace
kubectl get events -n my-namespace

# Check pod status
kubectl get pods -o wide

# Check service endpoints
kubectl get endpoints my-service

# Check persistent volumes
kubectl get pv

# Check storage classes
kubectl get storageclass
```

## Quick Testing Commands

```bash
# Test cluster connectivity
kubectl get nodes

# Test pod creation
kubectl run test-pod --image=busybox --rm -it --restart=Never -- echo "Hello World"

# Test service connectivity
kubectl run test-client --image=busybox --rm -it --restart=Never -- wget -qO- http://my-service

# Test configmap access
kubectl run test-config --image=busybox --rm -it --restart=Never -- env | grep CONFIG
``` 