#!/bin/bash

# ansik3s Setup Script
# This script helps you set up the prerequisites for ansik3s

set -e

echo "ansik3s Setup Script"
echo "========================"

# Check if running on macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Detected macOS"
    
    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Homebrew found"
    fi
    
    # Install Multipass
    if ! command -v multipass &> /dev/null; then
        echo "Installing Multipass..."
        brew install --cask multipass
    else
        echo "Multipass found"
    fi
    
    # Install Ansible
    if ! command -v ansible &> /dev/null; then
        echo "Installing Ansible..."
        brew install ansible
    else
        echo "Ansible found"
    fi

# Check if running on Linux
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Detected Linux"
    
    # Check if snap is available
    if command -v snap &> /dev/null; then
        echo "Installing Multipass via snap..."
        sudo snap install multipass --classic
    else
        echo "Snap not available. Please install Multipass manually:"
        echo "   Visit: https://multipass.run/docs/installing-on-linux"
        exit 1
    fi
    
    # Install Ansible
    if ! command -v ansible &> /dev/null; then
        echo "Installing Ansible..."
        sudo apt update
        sudo apt install -y ansible
    else
        echo "Ansible found"
    fi

else
    echo "Unsupported operating system: $OSTYPE"
    echo "Please install Multipass and Ansible manually:"
    echo "Multipass: https://multipass.run/docs/installing"
    echo "Ansible: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html"
    exit 1
fi

# Install Python dependencies
echo "Installing Python dependencies..."
pip3 install -r requirements.txt

# Start Multipass service
echo "Starting Multipass service..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    # On macOS, Multipass should start automatically
    echo "Multipass should be running"
else
    # On Linux, ensure Multipass is running
    sudo systemctl start snap.multipass.multipassd || true
fi

echo ""
echo "Setup completed successfully!"
echo ""
echo "Next steps:"
echo "1. Deploy a single-node cluster:"
echo "   ansible-playbook -i inventory/single-node.yml playbook.yml"
echo ""
echo "2. Deploy a multi-node cluster:"
echo "   ansible-playbook -i inventory/multi-node.yml playbook.yml"
echo ""
echo "3. To destroy a cluster:"
echo "   ansible-playbook -i inventory/single-node.yml playbook.yml --tags destroy"
echo ""
echo "For more information, see the README.md file"
