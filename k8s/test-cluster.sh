#!/bin/bash

# Test script for k3s cluster functionality
# This script deploys test applications and verifies cluster functionality

set -e

echo "Testing k3s Cluster Functionality"
echo "=================================="

# Get the master node IP for kubectl access
MASTER_IP=$(snap run multipass exec k3s-master -- ip route get 1 | awk '{print $7}' | head -1)
echo "Master node IP: $MASTER_IP"

# Function to run kubectl commands on master
kubectl_cmd() {
    snap run multipass exec k3s-master -- bash -c "export KUBECONFIG=/home/ubuntu/.kube/config && $1"
}

echo ""
echo "1. Checking cluster status..."
kubectl_cmd "kubectl get nodes -o wide"
echo ""

echo "2. Checking system pods..."
kubectl_cmd "kubectl get pods --all-namespaces"
echo ""

echo "3. Creating test namespace..."
kubectl_cmd "kubectl apply -f -" < test-namespace.yml
echo ""

echo "4. Deploying nginx test application..."
kubectl_cmd "kubectl apply -f -" < nginx-deployment.yml
echo ""

echo "5. Deploying storage test..."
kubectl_cmd "kubectl apply -f -" < storage-test.yml
echo ""

echo "6. Deploying ingress test..."
kubectl_cmd "kubectl apply -f -" < ingress-test.yml
echo ""

echo "7. Waiting for pods to be ready..."
sleep 30

echo "8. Checking test namespace resources..."
kubectl_cmd "kubectl get all -n test-cluster"
echo ""

echo "9. Checking PVC status..."
kubectl_cmd "kubectl get pvc -n test-cluster"
echo ""

echo "10. Checking ingress status..."
kubectl_cmd "kubectl get ingress -n test-cluster"
echo ""

echo "11. Testing pod distribution across nodes..."
kubectl_cmd "kubectl get pods -n test-cluster -o wide"
echo ""

echo "12. Testing service connectivity..."
kubectl_cmd "kubectl get svc -n test-cluster"
echo ""

echo "Cluster test completed successfully!"
echo ""
echo "To access the nginx service:"
echo "  kubectl port-forward -n test-cluster svc/nginx-test-service 8080:80"
echo ""
echo "To clean up test resources:"
echo "  kubectl delete namespace test-cluster" 