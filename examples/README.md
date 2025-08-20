# Configuration Examples

This directory contains example configuration files for different use cases.

## Available Examples

### [custom-cluster.yml](custom-cluster.yml)
A comprehensive example showing all available configuration options with comments explaining each variable.

### [development-cluster.yml](development-cluster.yml)
Optimized for development environments with:
- More CPU cores (4) for faster builds
- More memory (8G) for running multiple services
- Larger disk (20G) for storing images and data
- Isolated network subnet (192.168.100.0/24)
- Latest k3s version

### [minimal-cluster.yml](minimal-cluster.yml)
Optimized for systems with limited resources:
- Minimal CPU (1 core)
- Minimal memory (2G)
- Smaller disk (8G)
- Single worker node
- Standard network configuration

## Usage

Copy an example and modify it for your needs:

```bash
# For development
cp examples/development-cluster.yml my-dev-config.yml

# For minimal resources
cp examples/minimal-cluster.yml my-minimal-config.yml

# Use with playbook
ansible-playbook -i inventory/multi-node.yml playbook.yml -e @my-dev-config.yml
```

## Customization

See the [Custom Configuration Guide](../docs/custom-configuration.md) for detailed information on:
- Available variables
- Best practices
- Troubleshooting
- Advanced usage patterns
