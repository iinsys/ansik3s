#!/bin/bash

# Imperative kubectl commands for testing k3s cluster functionality
# This script uses kubectl commands instead of YAML manifests

set -e

echo "Testing k3s Cluster with Imperative Commands"
echo "============================================="

# Function to run kubectl commands on master
kubectl_cmd() {
    snap run multipass exec k3s-master -- bash -c "export KUBECONFIG=/home/ubuntu/.kube/config && $1"
}

echo ""
echo "1. Checking cluster status..."
kubectl_cmd "kubectl get nodes -o wide"
echo ""

echo "2. Creating test namespace..."
kubectl_cmd "kubectl create namespace imperative-test"
echo ""

echo "3. Creating nginx deployment with imperative command..."
kubectl_cmd "kubectl create deployment nginx-imperative --image=nginx:alpine --replicas=3 -n imperative-test"
echo ""

echo "4. Exposing nginx deployment as service..."
kubectl_cmd "kubectl expose deployment nginx-imperative --port=80 --target-port=80 --type=ClusterIP -n imperative-test"
echo ""

echo "5. Creating a busybox pod for testing..."
kubectl_cmd "kubectl run busybox-test --image=busybox --restart=Never --command -- sleep 3600 -n imperative-test"
echo ""

echo "6. Creating a configmap..."
kubectl_cmd "kubectl create configmap test-config --from-literal=app.name=imperative-test --from-literal=version=1.0 -n imperative-test"
echo ""

echo "7. Creating a secret..."
kubectl_cmd "kubectl create secret generic test-secret --from-literal=username=admin --from-literal=password=secret123 -n imperative-test"
echo ""

echo "8. Creating a PVC..."
kubectl_cmd "kubectl create -f -" << EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: test-pvc-imperative
  namespace: imperative-test
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: local-path
  resources:
    requests:
      storage: 50Mi
EOF
echo ""

echo "9. Creating a pod with PVC..."
kubectl_cmd "kubectl create -f -" << EOF
apiVersion: v1
kind: Pod
metadata:
  name: storage-test-imperative
  namespace: imperative-test
spec:
  containers:
  - name: busybox
    image: busybox:latest
    command: ["/bin/sh"]
    args: ["-c", "echo 'Hello from imperative test' > /data/test.txt && sleep 3600"]
    volumeMounts:
    - name: test-storage
      mountPath: /data
  volumes:
  - name: test-storage
    persistentVolumeClaim:
      claimName: test-pvc-imperative
EOF
echo ""

echo "10. Waiting for resources to be ready..."
sleep 30

echo "11. Checking all resources..."
kubectl_cmd "kubectl get all -n imperative-test"
echo ""

echo "12. Checking PVC status..."
kubectl_cmd "kubectl get pvc -n imperative-test"
echo ""

echo "13. Checking configmap and secret..."
kubectl_cmd "kubectl get configmap,secret -n imperative-test"
echo ""

echo "14. Testing pod distribution..."
kubectl_cmd "kubectl get pods -n imperative-test -o wide"
echo ""

echo "15. Testing service connectivity..."
kubectl_cmd "kubectl get svc -n imperative-test"
echo ""

echo "16. Testing pod-to-pod communication..."
kubectl_cmd "kubectl exec -n imperative-test busybox-test -- wget -qO- http://nginx-imperative"
echo ""

echo "17. Checking pod logs..."
kubectl_cmd "kubectl logs -n imperative-test deployment/nginx-imperative --tail=5"
echo ""

echo "18. Testing resource limits..."
kubectl_cmd "kubectl describe pod -n imperative-test -l app=nginx-imperative | grep -A 5 'Limits:'"
echo ""

echo "Imperative test completed successfully!"
echo ""
echo "To access the nginx service:"
echo "  kubectl port-forward -n imperative-test svc/nginx-imperative 8080:80"
echo ""
echo "To clean up:"
echo "  kubectl delete namespace imperative-test" 