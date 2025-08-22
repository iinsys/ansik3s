# k3s Version Update Workflow

This document describes the automated workflow that checks for k3s version updates and creates pull requests when newer versions are available.

## Overview

The workflow is defined in `.github/workflows/check-k3s-updates.yml` and automatically:
- Checks for the latest k3s version monthly
- Compares it with the current version in the project
- Creates a pull request if an update is available

## Schedule

- **Frequency**: Monthly (1st of every month at 00:00 UTC)
- **Manual trigger**: Available via GitHub Actions UI
- **Runtime**: ~2-3 minutes

## How It Works

### 1. Version Detection
- Fetches the latest k3s version from GitHub API
- Reads the current version from `group_vars/all.yml`
- Compares versions to determine if an update is needed

### 2. Update Process
If a newer version is found:
- Creates a new branch: `update-k3s-{version}`
- Updates `group_vars/all.yml` with the new version
- Updates documentation files that reference the version
- Commits and pushes changes
- Creates a pull request with detailed information

### 3. Pull Request Details
The created PR includes:
- Version comparison (old → new)
- List of changes made
- Testing instructions
- Link to k3s release notes
- Appropriate labels for easy identification

## Manual Trigger

To manually check for updates:
1. Go to GitHub Actions tab
2. Select "Check k3s Updates" workflow
3. Click "Run workflow"
4. Select branch and click "Run workflow"

## Current Status

- **Current k3s version**: v1.28.5+k3s1
- **Latest available**: v1.33.3+k3s1
- **Update needed**: Yes

## Benefits

- **Automated**: No manual version checking required
- **Safe**: Creates PRs for review, doesn't auto-merge
- **Comprehensive**: Updates both code and documentation
- **Informative**: Includes release notes and testing guidance
- **Efficient**: Only runs when needed

## Testing Updates

When a version update PR is created:
1. Review the changes
2. Test deployment locally with the new version
3. Check k3s release notes for breaking changes
4. Run the CI/CD pipeline to validate syntax
5. Merge if everything works correctly

## Configuration

The workflow uses:
- GitHub API to fetch latest releases
- `group_vars/all.yml` for current version
- GitHub Actions secrets for authentication
- Automated PR creation with proper labels

## Troubleshooting

### Common Issues

1. **API rate limiting**: GitHub API has rate limits, but monthly runs should be fine
2. **Version format changes**: If k3s changes version format, workflow may need updates
3. **Permission issues**: Ensure workflow has proper repository permissions

### Debugging

To debug workflow issues:
1. Check workflow logs in GitHub Actions
2. Verify GitHub API responses
3. Test version parsing locally
4. Check repository permissions

## Security

- Uses GitHub's built-in secrets
- Only reads public k3s release information
- Creates PRs for review, no direct commits to main
- Minimal permissions required

## Cost

- **Runtime**: ~2-3 minutes monthly
- **GitHub Actions minutes**: Very low usage
- **Frequency**: Once per month
- **Efficiency**: Only creates PRs when updates are available 