# ansik3s

Spin up Single or multiple k3s cluster on multipass using ansible

## Project Goal

The goal of this project is to provide a simple and automated way to set up a lightweight Kubernetes cluster using k3s on Multipass VMs, managed with Ansible.

It is designed for developers, learners, and hobbyists who want a fast, repeatable, and minimal setup to experiment with Kubernetes locally without the overhead of complex tooling.

With a single run, you can choose between:

- **Single-node cluster** – ideal for quick testing or learning Kubernetes basics.
- **Multi-node cluster** – to simulate a real-world Kubernetes environment with multiple worker nodes.

## Key Features

- One-command deployment of k3s on Multipass
- Minimal configuration – ready-to-use out of the box
- Lightweight – based on k3s, optimized for local labs
- Single-node or multi-node option depending on your needs
- Repeatable & reproducible with Ansible automation  

## Prerequisites

- **Multipass**: [Download and install](https://multipass.run/docs/installing) for your platform
- **Python 3.7+**: [Download and install](https://www.python.org/downloads/) (required for Ansible)
- **Ansible**: [Installation guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

### Quick Installation

**macOS:**
```bash
# Install Homebrew first (if not installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Multipass and Python
brew install --cask multipass
brew install python3
brew install ansible
```

**Linux (Ubuntu/Debian):**
```bash
# Install Python
sudo apt update
sudo apt install python3 python3-pip

# Install Multipass
sudo snap install multipass --classic

# Install Ansible
sudo apt install ansible
```

**Windows:**
- Download [Multipass for Windows](https://multipass.run/docs/installing-on-windows)
- Download [Python for Windows](https://www.python.org/downloads/windows/)
- Install Ansible via pip: `pip install ansible`

## Quick Start

1. **Clone the repository:**
   ```bash
   git clone https://github.com/iinsys/ansik3s.git
   cd ansik3s
   ```

2. **Choose your cluster type:**
   
   **For a single-node cluster:**
   ```bash
   ansible-playbook -i inventory/single-node.yml playbook.yml
   ```
   
   **For a multi-node cluster:**
   ```bash
   ansible-playbook -i inventory/multi-node.yml playbook.yml
   ```

3. **Access your cluster:**
   ```bash
   # Get the kubeconfig
   multipass exec k3s-master -- cat /etc/rancher/k3s/k3s.yaml > kubeconfig
   
   # Use kubectl with the config
   kubectl --kubeconfig kubeconfig get nodes
   ```

## Configuration

### Cluster Types

- **Single Node**: One VM running both control plane and worker node
- **Multi Node**: One master VM + configurable number of worker VMs

### Customization

Edit the inventory files to customize:
- VM names and IPs
- Number of worker nodes
- Resource allocation (CPU, memory, disk)

## Project Structure

```
ansik3s/
├── inventory/           # Ansible inventory files
│   ├── single-node.yml
│   └── multi-node.yml
├── roles/              # Ansible roles
│   ├── multipass/      # Multipass VM management
│   └── k3s/           # K3s installation and configuration
├── playbook.yml        # Main playbook
├── group_vars/         # Variables for different environments
└── README.md
```

## Usage Examples

### Basic Operations

```bash
# Deploy single-node cluster
ansible-playbook -i inventory/single-node.yml playbook.yml

# Deploy multi-node cluster
ansible-playbook -i inventory/multi-node.yml playbook.yml

# Destroy cluster
ansible-playbook -i inventory/single-node.yml playbook.yml --tags destroy
```

### Advanced Usage

```bash
# Deploy with custom variables
ansible-playbook -i inventory/multi-node.yml playbook.yml \
  -e "worker_nodes=3" \
  -e "vm_memory=4G" \
  -e "vm_cpu=2"
```

## Documentation

For detailed guides and examples, see the [docs/](docs/) directory:
- [Quick Start Guide](docs/QUICKSTART.md) - Get up and running quickly
- [Custom Configuration Guide](docs/custom-configuration.md) - How to customize your cluster
- [Examples](examples/) - Custom configuration examples

## Troubleshooting

### Common Issues

1. **Multipass not found**: Ensure Multipass is installed and running
2. **Permission denied**: Run with appropriate permissions for Multipass
3. **Network issues**: Check if Multipass can create VMs with the specified network

### Logs and Debugging

```bash
# Run with verbose output
ansible-playbook -i inventory/single-node.yml playbook.yml -vvv

# Check VM status
multipass list

# Access VM directly
multipass shell k3s-master
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with both single and multi-node configurations
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
