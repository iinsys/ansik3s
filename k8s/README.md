# Kubernetes Test Manifests

This directory contains Kubernetes manifest files for testing the k3s cluster functionality.

## Files Overview

### Core Test Files
- `test-namespace.yml` - Creates a test namespace for all test resources
- `nginx-deployment.yml` - Deploys a 3-replica nginx application with service
- `storage-test.yml` - Tests persistent storage with local-path-provisioner
- `ingress-test.yml` - Tests Traefik ingress controller functionality

### Scripts
- `test-cluster.sh` - Main test script that deploys all resources and verifies functionality
- `cleanup-test.sh` - Cleanup script to remove all test resources
- `imperative-test.sh` - Test script using imperative kubectl commands
- `cleanup-imperative.sh` - Cleanup script for imperative test resources

## Usage

### Run Complete Test (Declarative)
```bash
cd k8s
./test-cluster.sh
```

### Run Imperative Test
```bash
cd k8s
./imperative-test.sh
```

### Clean Up Test Resources
```bash
cd k8s
./cleanup-test.sh
```

### Clean Up Imperative Test Resources
```bash
cd k8s
./cleanup-imperative.sh
```

### Manual Deployment
```bash
# Apply namespace
kubectl apply -f test-namespace.yml

# Deploy nginx application
kubectl apply -f nginx-deployment.yml

# Deploy storage test
kubectl apply -f storage-test.yml

# Deploy ingress test
kubectl apply -f ingress-test.yml
```

## What Each Test Verifies

### Declarative Test (YAML Manifests)
- ✅ Multi-replica deployment (3 pods)
- ✅ Pod distribution across nodes
- ✅ Service creation and connectivity
- ✅ Resource limits and requests
- ✅ PersistentVolumeClaim creation
- ✅ local-path-provisioner functionality
- ✅ Volume mounting and data persistence
- ✅ Traefik ingress controller
- ✅ Ingress resource configuration
- ✅ External access routing

### Imperative Test (kubectl Commands)
- ✅ Namespace creation
- ✅ Deployment creation with replicas
- ✅ Service exposure
- ✅ ConfigMap creation
- ✅ Secret creation
- ✅ PVC creation and binding
- ✅ Pod-to-pod communication
- ✅ Resource inspection and logs

## Expected Results

### Declarative Test
After running the declarative test script, you should see:
- 3 nginx pods running across different nodes
- 1 storage test pod with persistent volume
- All services properly configured
- Ingress resource created and configured

### Imperative Test
After running the imperative test script, you should see:
- 3 nginx pods running across different nodes
- 1 storage test pod with persistent volume
- ConfigMap and Secret created
- Service properly configured
- All resources distributed across nodes

## Additional Resources

- `imperative-commands.md` - Reference guide for common kubectl commands
- Use imperative commands for quick testing and learning
- Use declarative manifests for production deployments

## Troubleshooting

If tests fail:
1. Check cluster status: `kubectl get nodes`
2. Check system pods: `kubectl get pods --all-namespaces`
3. Check test namespace: `kubectl get all -n test-cluster`
4. Check pod logs: `kubectl logs <pod-name> -n test-cluster` 