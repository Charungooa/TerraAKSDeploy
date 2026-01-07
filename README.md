# TerraAKSDeploy

# Terraform AKS Deploy

A GitHub Actions workflow for deploying and managing Azure Kubernetes Service (AKS) infrastructure using Terraform with environment-specific configurations.

## Overview

This repository provides an automated infrastructure-as-code solution for deploying AKS clusters to Azure. It supports multiple environments (Dev, Prod, Stage) and allows both provisioning and teardown of infrastructure through a simple manual workflow trigger.

## Features

- **Multi-Environment Support**: Deploy to Dev, Prod, or Stage environments with environment-specific configurations
- **Apply & Destroy Actions**: Create/update infrastructure or tear it down completely
- **State Management**: Terraform state is stored as GitHub Artifacts, eliminating the need for external state backends
- **Secure Credential Handling**: Azure credentials are managed through GitHub Secrets
- **Dynamic Resource Naming**: Automatic resource group and Azure Container Registry naming based on environment

## Prerequisites

Before using this workflow, ensure you have:

1. An Azure subscription with appropriate permissions
2. An Azure Service Principal with contributor access
3. The following GitHub Secrets configured in your repository:

| Secret Name | Description |
|-------------|-------------|
| `AZURE_CLIENT_ID` | Azure Service Principal Client ID |
| `AZURE_CLIENT_SECRET` | Azure Service Principal Client Secret |
| `AZURE_SUBSCRIPTION_ID` | Azure Subscription ID |
| `AZURE_TENANT_ID` | Azure AD Tenant ID |
| `AZURE_CLIENT_OBJECT_ID` | Azure Service Principal Object ID |

## Repository Structure

```
TerraAKSDeploy/
├── .github/
│   └── workflows/
│       └── terraform-aks-deploy.yml
├── Dev/
│   └── *.tf                    # Development environment Terraform configs
├── Prod/
│   └── *.tf                    # Production environment Terraform configs
├── Stage/
│   └── *.tf                    # Staging environment Terraform configs
└── README.md
```

## Usage

### Running the Workflow

1. Navigate to the **Actions** tab in your GitHub repository
2. Select the **Terraform AKS Deploy** workflow
3. Click **Run workflow**
4. Configure the parameters:
   - **Environment**: Choose `Dev`, `Prod`, or `Stage`
   - **Action**: Choose `apply` (create/update) or `destroy` (delete)
5. Click **Run workflow** to execute

### Environment Configuration

Each environment uses specific default values:

| Environment | Resource Group | ACR Name Pattern |
|-------------|---------------|------------------|
| Dev | `dev-rg` | `devrg2025` |
| Prod | `prod-rg` | `terraacr2025prod-{run_number}` |
| Stage | `stage-rg` | `terraacr2025stage-{run_number}` |

## Workflow Details

### State Management

The workflow uses GitHub Artifacts to persist Terraform state between runs:

- State files are named `{Environment}.tfstate` (e.g., `Dev.tfstate`)
- Artifacts are stored as `terraform-state-{Environment}`
- State is automatically downloaded before operations and uploaded after
- Each environment maintains its own independent state

### Workflow Steps

1. **Checkout** - Clones the repository
2. **Setup Python** - Configures Python environment
3. **Setup Terraform** - Installs Terraform v1.5.7
4. **Check State Artifact** - Verifies if previous state exists
5. **Download State** - Retrieves existing state (if available)
6. **Terraform Init** - Initializes the Terraform working directory
7. **Terraform Plan** - Shows execution plan (apply or destroy)
8. **Terraform Apply/Destroy** - Executes the planned changes
9. **Upload State** - Saves updated state as artifact

## Security Considerations

- All Azure credentials are stored as GitHub Secrets
- Secrets are passed to Terraform as `TF_VAR_*` environment variables
- State files contain sensitive information and are stored as private artifacts
- Review the Terraform plan output before approving production changes

## Customization

### Overriding Resource Names

The workflow supports optional overrides through input variables:

- `RESOURCE_GROUP_OVERRIDE`: Custom resource group name
- `ACR_NAME_OVERRIDE`: Custom Azure Container Registry name

### Modifying Terraform Configuration

Update the Terraform files in the respective environment directories (`Dev/`, `Prod/`, `Stage/`) to customize your AKS cluster configuration.

## Troubleshooting

### Common Issues

**State Lock Errors**
Since this uses local state stored as artifacts, concurrent runs may cause conflicts. Ensure only one workflow run is active per environment.

**Authentication Failures**
Verify all Azure secrets are correctly configured and the Service Principal has appropriate permissions.

**Missing State**
On first run or after artifact expiration (90 days default), Terraform will create new infrastructure. Use `destroy` to clean up orphaned resources if needed.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is provided as-is for educational and demonstration purposes.

## Resources

- [Terraform Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Kubernetes Service Documentation](https://docs.microsoft.com/en-us/azure/aks/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

---

**Repository**: [https://github.com/Charungooa/TerraAKSDeploy](https://github.com/Charungooa/TerraAKSDeploy)
