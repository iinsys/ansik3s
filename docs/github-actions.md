# GitHub Actions CI/CD Pipeline

This document describes the GitHub Actions CI/CD pipeline that validates and lints the k3s automation code.

## Overview

The pipeline is defined in `.github/workflows/test.yml` and runs on:
- Push to `main` or `develop` branches
- Pull requests to `main` branch

## Pipeline Purpose

This is a **CI/CD pipeline** focused on code quality and validation, not full deployment testing. It ensures:
- Code syntax is correct
- Configuration files are valid
- Dependencies are properly defined
- Scripts have correct permissions

## Pipeline Stages

### Lint and Validate Job
- **Purpose**: Validates all code and configuration files
- **Duration**: ~2-3 minutes
- **Actions**:

1. **Ansible Playbook Validation**
   - Syntax checks on single-node and multi-node playbooks
   - Validates inventory files structure

2. **YAML Syntax Validation**
   - Checks all YAML files for proper syntax
   - Validates playbook.yml, inventory files, and group_vars

3. **Shell Script Validation**
   - Syntax checks on all shell scripts
   - Ensures scripts are properly formatted

4. **File Permissions**
   - Sets correct executable permissions on scripts
   - Ensures scripts can be run

5. **Dependencies Validation**
   - Validates requirements.txt
   - Checks for dependency conflicts

## What the Pipeline Does NOT Do

- Full k3s deployment testing
- VM creation or destruction
- Multipass installation
- Cluster functionality testing
- Application deployment testing

## Benefits

- Fast: Completes in 1-2 minutes
- Reliable: No external dependencies or VM requirements
- Cost-effective: Minimal GitHub Actions minutes usage
- Focused: Catches common syntax and configuration errors
- Safe: No risk of leaving VMs running

## Manual Testing

For full deployment testing, run locally:

```bash
# Install dependencies
pip install -r requirements.txt

# Install Multipass
sudo snap install multipass --classic

# Test single-node deployment
ansible-playbook -i inventory/single-node.yml playbook.yml --tags deploy

# Test multi-node deployment
ansible-playbook -i inventory/multi-node.yml playbook.yml --tags deploy

# Clean up
ansible-playbook -i inventory/multi-node.yml playbook.yml --tags destroy
```

## Troubleshooting

### Common Pipeline Failures

1. **YAML syntax errors**: Check indentation and structure
2. **Ansible syntax errors**: Validate playbook syntax
3. **Shell script errors**: Check script syntax with `bash -n script.sh`
4. **Dependency conflicts**: Run `pip check` locally

### Debugging

To debug pipeline issues:
1. Check the pipeline logs in GitHub Actions
2. Run validation steps locally
3. Use `ansible-playbook --syntax-check` for playbook issues
4. Use `bash -n script.sh` for shell script issues

## Security

- No sensitive data processed
- No external systems accessed
- No VMs created or destroyed
- Minimal attack surface

## Performance

- Total time: ~1-2 minutes
- Resource usage: Minimal
- Cost: Very low GitHub Actions minutes usage

This pipeline provides fast, reliable validation without the complexity and resource requirements of full deployment testing. 