# ansik3s

Spin up Single or multiple k3s cluster on multipass using ansible

[![CI/CD Pipeline](https://github.com/iinsys/ansik3s/workflows/CI/CD%20Pipeline/badge.svg)](https://github.com/iinsys/ansik3s/actions/workflows/test.yml)
[![k3s Version](https://img.shields.io/badge/k3s-v1.28.5%2Bk3s1-blue.svg)](https://github.com/k3s-io/k3s/releases)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Ansible](https://img.shields.io/badge/ansible-2.9+-red.svg)](https://docs.ansible.com/)
[![Multipass](https://img.shields.io/badge/multipass-1.0+-orange.svg)](https://multipass.run/)

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
   ansible-playbook -i inventory/single-node.yml playbook.yml --tags deploy
   ```
   
   **For a multi-node cluster:**
   ```bash
   ansible-playbook -i inventory/multi-node.yml playbook.yml --tags deploy
   ```

3. **Access your cluster:**
   ```bash
   # The kubeconfig is automatically generated and saved locally
   # Use kubectl with the config
   kubectl --kubeconfig kubeconfig get nodes
   
   # Or access the master node directly (no sudo needed)
   snap run multipass shell k3s-master
   kubectl get nodes
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
ansible-playbook -i inventory/single-node.yml playbook.yml --tags deploy

# Deploy multi-node cluster
ansible-playbook -i inventory/multi-node.yml playbook.yml --tags deploy

# Destroy cluster
ansible-playbook -i inventory/single-node.yml playbook.yml --tags destroy
```

### Advanced Usage

```bash
# Deploy with custom variables
ansible-playbook -i inventory/multi-node.yml playbook.yml --tags deploy \
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
ansible-playbook -i inventory/single-node.yml playbook.yml --tags deploy -vvv

# Check VM status
multipass list

# Access VM directly
multipass shell k3s-master
```

## Automated Workflows

This project uses GitHub Actions for automated quality assurance and maintenance:

### CI/CD Pipeline
- **Status**: ![CI/CD Pipeline](https://github.com/iinsys/ansik3s/workflows/CI/CD%20Pipeline/badge.svg)
- **Purpose**: Validates code syntax, YAML files, and shell scripts
- **Trigger**: Pull requests to main branch
- **Runtime**: ~1-2 minutes

### k3s Version Updates
- **Schedule**: Monthly (1st of every month)
- **Purpose**: Automatically checks for k3s version updates
- **Action**: Creates pull requests when newer versions are available
- **Current**: v1.28.5+k3s1 (Latest: v1.33.3+k3s1)

For more details, see:
- [CI/CD Pipeline Documentation](docs/github-actions.md)
- [k3s Version Updates](docs/k3s-version-updates.md)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with both single and multi-node configurations
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
