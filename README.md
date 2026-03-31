# GitHub Repository Setup for Kong ApiOps

## 🔑 Required GitHub Secrets

Add these secrets in your GitHub repository settings (`Settings > Secrets and variables > Actions`):

### Secrets
- `KONNECT_TOKEN`: Your Kong Konnect Personal Access Token
  - Get from: https://cloud.konghq.com/personal-access-tokens
  - Example: `kpat_your-token-here`

## 📝 Required GitHub Variables

Add these variables in your GitHub repository settings (`Settings > Secrets and variables > Actions`):

### Variables
- `CONTROL_PLANE_NAME`: Name of your existing Kong Konnect Control Plane
  - Example: `AU-Demo-Gateway`
- `PORTAL_NAME`: Name of your existing Kong Konnect Developer Portal  
  - Example: `Rami-DevportalV3`
- `KONNECT_SERVER_URL`: Kong Konnect server URL for your region (optional)
  - US: `https://us.api.konghq.com`
  - EU: `https://eu.api.konghq.com`
  - AU: `https://au.api.konghq.com` (default)

## 📁 Repository Structure

Ensure your repository has this structure:

```
your-repo/
├── .github/
│   └── workflows/
│       └── kong-apiops.yml          # GitHub Actions workflow
├── specs/
│   └── oas.yaml                     # OpenAPI specifications
├── config/
│   └── apis.yaml                    # APIs and portal configuration
├── scripts/
│   └── generate_gateway_resources.sh # Kong-compliant generation script
├── terraform/
│   ├── main.tf                      # Main Terraform configuration
│   ├── variables.tf                 # Variable definitions
│   ├── outputs.tf                   # Output definitions
│   └── terraform.tfvars.example     # Configuration template
└── README.md                        # Documentation
```

## 🚀 Workflow Triggers

The workflow runs on:

1. **Push to main branch** (when files in `specs/`, `config/`, `terraform/`, or `scripts/` change)
   - Automatically generates Kong resources and deploys

2. **Pull Requests** to main branch
   - Validates changes and shows Terraform plan in PR comments
   - Does not deploy (safe for testing)

3. **Manual Workflow Dispatch**
   - Option to destroy infrastructure
   - Option to force regenerate Kong resources

## 🔧 Setup Commands

```bash
# 1. Clone your repository
git clone https://github.com/your-username/your-repo.git
cd your-repo

# 2. Set up the directory structure (if starting fresh)
mkdir -p .github/workflows specs config scripts terraform

# 3. Add the workflow file
# Copy the kong-apiops.yml content to .github/workflows/kong-apiops.yml

# 4. Add your Kong configuration files
# Copy all the files from the Kong ApiOps setup

# 5. Configure GitHub secrets and variables
# Go to Settings > Secrets and variables > Actions

# 6. Commit and push to trigger the workflow
git add .
git commit -m "🚀 Add Kong ApiOps with GitHub Actions"
git push origin main
```

## 📊 Workflow Features

### ✅ Kong Compliance
- Uses official `deck` CLI for all OpenAPI processing
- Follows Kong's recommended ApiOps workflow
- Validates OpenAPI specifications before deployment

### 🔍 Validation Steps
- **OpenAPI Validation**: Checks YAML syntax and Kong extensions
- **Configuration Validation**: Validates APIs configuration
- **Terraform Validation**: Ensures Terraform syntax is correct

### 📋 Pull Request Integration
- Shows Terraform plan in PR comments
- Validates changes without deploying
- Safe testing environment

### 🏗️ Resource Generation
- Automatic Kong resource generation using `deck`
- Integration with existing Terraform workflow
- State management in Git repository

### 📈 Monitoring & Outputs
- Deployment summaries and artifacts
- Terraform state management
- Job summaries with links to Kong resources

## 🛡️ Safety Features

### Automatic Cleanup
- Destroys resources if deployment fails
- Commits updated Terraform state
- Cleans up generated files

### Manual Controls
- Workflow dispatch for manual deployments
- Destroy option for cleanup
- Force regeneration option

## 🔗 Integration with Kong Konnect

After successful deployment, you can:

1. **View APIs** in Kong Developer Portal
2. **Monitor Gateway** in Kong Manager
3. **Generate API Keys** for testing
4. **Review Analytics** in Kong Konnect Console

## 🆘 Troubleshooting

### Common Issues

1. **Missing Secrets/Variables**
   ```
   Error: konnect_token is required
   ```
   → Add `KONNECT_TOKEN` secret and required variables

2. **deck Command Not Found**
   ```
   deck: command not found
   ```
   → The workflow installs deck automatically

3. **Control Plane Not Found**
   ```
   No control plane found with name
   ```
   → Verify `CONTROL_PLANE_NAME` variable matches exactly

4. **State Conflicts**
   ```
   Error acquiring the state lock
   ```
   → Ensure no other workflows are running simultaneously

### Debug Steps

1. **Check Workflow Logs**: Go to Actions tab in GitHub
2. **Validate Locally**: Run the generation script locally first
3. **Test Configuration**: Use workflow dispatch with validation only
4. **Review State**: Check committed terraform.tfstate file

## 🎯 Best Practices

1. **Branch Protection**: Enable branch protection on main branch
2. **Review Process**: Always use Pull Requests for changes
3. **Small Changes**: Make incremental changes to APIs
4. **Test First**: Use PR validation before merging
5. **Monitor Deployments**: Check Kong Konnect after deployments
6. **Backup State**: The workflow automatically commits state changes

This setup provides a complete Kong-compliant CI/CD pipeline for your APIs! 🎉