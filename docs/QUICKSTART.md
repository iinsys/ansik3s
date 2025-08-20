# Quick Start Guide

Get your k3s cluster running in minutes!

## Prerequisites

- macOS or Linux
- Internet connection
- At least 8GB RAM available

## Step 1: Setup

Run the setup script to install all prerequisites:

```bash
./setup.sh
```

This will install:
- Multipass (for VM management)
- Ansible (for automation)
- Python dependencies

## Step 2: Deploy Your Cluster

### Option A: Single-Node Cluster (Recommended for beginners)

```bash
ansible-playbook -i inventory/single-node.yml playbook.yml
```

### Option B: Multi-Node Cluster (For more realistic testing)

```bash
ansible-playbook -i inventory/multi-node.yml playbook.yml
```

## Step 3: Access Your Cluster

Once deployment is complete, you'll have a `kubeconfig` file in your current directory.

```bash
# Check your cluster nodes
kubectl --kubeconfig kubeconfig get nodes

# Check all pods
kubectl --kubeconfig kubeconfig get pods --all-namespaces

# Access the master node directly
multipass shell k3s-master
```

## Step 4: Test Your Cluster

Deploy a simple application:

```bash
# Deploy nginx
kubectl --kubeconfig kubeconfig apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - containerPort: 80
EOF

# Check the deployment
kubectl --kubeconfig kubeconfig get deployments
kubectl --kubeconfig kubeconfig get pods
```

## Cleanup

When you're done, destroy the cluster:

```bash
ansible-playbook -i inventory/single-node.yml playbook.yml --tags destroy
```

## Troubleshooting

### Common Issues

1. **"multipass not found"**
   - Run `./setup.sh` again
   - On macOS: `brew install --cask multipass`
   - On Linux: `sudo snap install multipass --classic`

2. **"ansible not found"**
   - Run `./setup.sh` again
   - On macOS: `brew install ansible`
   - On Linux: `sudo apt install ansible`

3. **VMs fail to start**
   - Check available system resources
   - Ensure virtualization is enabled in BIOS
   - Try reducing VM resources in `group_vars/all.yml`

### Getting Help

- Check the full [README.md](../README.md) for detailed documentation
- Run with verbose output: `ansible-playbook -i inventory/single-node.yml playbook.yml -vvv`
- Check VM status: `multipass list`

## Next Steps

- Explore Kubernetes concepts with your new cluster
- Try deploying more complex applications
- Experiment with different cluster configurations
- Check out the [examples/](examples/) directory for custom configurations
