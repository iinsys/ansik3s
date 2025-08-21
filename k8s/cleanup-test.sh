#!/bin/bash

# Cleanup script for test resources
# This script removes all test resources from the cluster

set -e

echo "Cleaning up test resources..."
echo "=============================="

# Function to run kubectl commands on master
kubectl_cmd() {
    snap run multipass exec k3s-master -- bash -c "export KUBECONFIG=/home/ubuntu/.kube/config && $1"
}

echo "1. Deleting test namespace and all resources..."
kubectl_cmd "kubectl delete namespace test-cluster --ignore-not-found=true"
echo ""

echo "2. Waiting for cleanup to complete..."
sleep 10

echo "3. Verifying cleanup..."
kubectl_cmd "kubectl get namespaces | grep test-cluster || echo 'Test namespace successfully removed'"
echo ""

echo "4. Checking remaining resources..."
kubectl_cmd "kubectl get pods --all-namespaces | grep test-cluster || echo 'No test pods remaining'"
echo ""

echo "Cleanup completed successfully!" 