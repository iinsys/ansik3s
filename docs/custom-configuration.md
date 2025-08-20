# Custom Configuration Guide

This guide explains how to use custom configurations with ansik3s.

## How Example Configuration Works

The `examples/custom-cluster.yml` file contains variable overrides that can be used to customize your cluster deployment. These variables override the defaults defined in `group_vars/all.yml`.

## Using Custom Configuration

### Method 1: Copy and Modify (Recommended)

1. Copy the example configuration:
   ```bash
   cp examples/custom-cluster.yml my-cluster-config.yml
   ```

2. Modify the variables in `my-cluster-config.yml` to match your needs

3. Use the custom configuration with your playbook:
   ```bash
   ansible-playbook -i inventory/multi-node.yml playbook.yml -e @my-cluster-config.yml
   ```

### Method 2: Direct Variable Override

Pass variables directly on the command line:
```bash
ansible-playbook -i inventory/multi-node.yml playbook.yml \
  -e "vm_cpu=4" \
  -e "vm_memory=8G" \
  -e "worker_nodes=3"
```

### Method 3: Environment-Specific Variables

Create environment-specific variable files:
```bash
# Create production config
cp examples/custom-cluster.yml group_vars/production.yml

# Create development config  
cp examples/custom-cluster.yml group_vars/development.yml

# Use with specific inventory
ansible-playbook -i inventory/multi-node.yml playbook.yml --extra-vars "@group_vars/production.yml"
```

## Configuration Variables

### VM Configuration
- `vm_image`: Ubuntu version (default: "22.04")
- `vm_cpu`: Number of CPU cores per VM (default: 2)
- `vm_memory`: Memory allocation per VM (default: "4G")
- `vm_disk`: Disk size per VM (default: "10G")

### Network Configuration
- `vm_network`: Network subnet (default: "10.0.0.0/24")
- `master_ip`: Master node IP address (default: "10.0.0.10")
- `worker_start_ip`: Starting IP for worker nodes (default: "10.0.0.20")

### K3s Configuration
- `k3s_version`: K3s version to install (default: "v1.28.5+k3s1")
- `k3s_token`: Join token (auto-generated if not specified)

### Cluster Configuration
- `worker_nodes`: Number of worker nodes (default: 2)

### Multipass Configuration
- `multipass_timeout`: Timeout for VM operations (default: 300)
- `multipass_retries`: Number of retry attempts (default: 3)

## Example Use Cases

### Development Environment
```yaml
vm_cpu: 4
vm_memory: "8G"
vm_disk: "20G"
worker_nodes: 2
k3s_version: "v1.29.0+k3s1"
```

### Production-Like Environment
```yaml
vm_cpu: 2
vm_memory: "4G"
vm_disk: "15G"
worker_nodes: 3
k3s_version: "v1.28.5+k3s1"
multipass_timeout: 600
```

### Minimal Resource Environment
```yaml
vm_cpu: 1
vm_memory: "2G"
vm_disk: "8G"
worker_nodes: 1
```

## Best Practices

1. **Start with defaults**: Use the default configuration first to ensure everything works
2. **Incremental changes**: Modify one variable at a time to isolate issues
3. **Resource planning**: Ensure your host system has enough resources for the VMs
4. **Network isolation**: Use different subnets for different environments
5. **Version pinning**: Pin k3s versions for reproducible deployments

## Troubleshooting Custom Configurations

### Common Issues

1. **Insufficient host resources**: Reduce VM resources if deployment fails
2. **Network conflicts**: Change network subnet if IP conflicts occur
3. **Timeout issues**: Increase `multipass_timeout` for larger VMs
4. **Version compatibility**: Ensure k3s version is compatible with your use case

### Debugging

Run with verbose output to see detailed variable resolution:
```bash
ansible-playbook -i inventory/multi-node.yml playbook.yml -e @my-cluster-config.yml -vvv
```

Check variable precedence:
```bash
ansible-playbook -i inventory/multi-node.yml playbook.yml -e @my-cluster-config.yml --list-tasks
```
