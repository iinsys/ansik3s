#!/bin/bash

# Test script to verify ansik3s setup
# Run this after setup.sh to ensure everything is working

set -e

echo "Testing ansik3s Setup"
echo "========================"

# Test Multipass
echo "Testing Multipass..."
if command -v multipass &> /dev/null; then
    echo "Multipass is installed"
    multipass version
else
    echo "Multipass not found"
    exit 1
fi

# Test Ansible
echo "Testing Ansible..."
if command -v ansible &> /dev/null; then
    echo "Ansible is installed"
    ansible --version
else
    echo "Ansible not found"
    exit 1
fi

# Test Python dependencies
echo "Testing Python dependencies..."
if python3 -c "import yaml" 2>/dev/null; then
    echo "PyYAML is installed"
else
    echo "PyYAML not found"
    exit 1
fi

# Test Multipass service
echo "Testing Multipass service..."
if multipass list &> /dev/null; then
    echo "Multipass service is running"
else
    echo "Multipass service not responding"
    exit 1
fi

# Test Ansible playbook syntax
echo "Testing Ansible playbook syntax..."
if ansible-playbook --syntax-check playbook.yml; then
    echo "Playbook syntax is valid"
else
    echo "Playbook syntax error"
    exit 1
fi

echo ""
echo "All tests passed! Your ansik3s setup is ready."
echo ""
echo "Next steps:"
echo "1. Deploy single-node: ansible-playbook -i inventory/single-node.yml playbook.yml"
echo "2. Deploy multi-node: ansible-playbook -i inventory/multi-node.yml playbook.yml"
echo "3. See docs/QUICKSTART.md for detailed instructions"
