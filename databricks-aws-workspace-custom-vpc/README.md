# Customer Managed VPC Databricks Workspace Deployment

This Terraform module deploys a complete Databricks workspace using a customer-managed VPC in your AWS account. It includes Unity Catalog setup, external storage configuration, and comprehensive access controls.

## What's Implemented

### Core Infrastructure
- **Databricks Workspace**: Enterprise-tier workspace with customer-managed VPC
- **VPC & Networking**: Custom VPC with public/private subnets across multiple availability zones (can use existing VPC)
- **Security Groups**: Configured with required egress ports for Databricks connectivity
- **S3 Storage**: Root storage bucket for workspace data and external location bucket for Unity Catalog

### Unity Catalog Enabled
This script creates/manages a Databricks Metastore (required for Unity Catalog, can use existing or create new, limit 1 per Cloud Region). The created workspace is attached to this metastore, and the `main` catalog is created, and set as default. It is associated to an external location, separate from the root bucket.

### Access Control & Security
- **Workspace Admin Group**: Custom group with admin privileges
- **Metastore Owner Group**: Custom group with metastore ownership
- **IAM Roles**: Cross-account role for Databricks workspace access, and storage access control roles
- **S3 Bucket Policies**: Properly configured bucket policies for Databricks access to the configured storage locations.

### Additional Features
- **Test Notebook**: SQL notebook deployed to `/Shared/ws_tester_notebook.ipynb` for workspace validation
- **Resource Tagging**: Consistent tagging across all AWS resources
- **Flexible Configuration**: Support for existing VPC/subnets or automatic creation

## Prerequisites

### AWS Requirements
- AWS CLI configured with appropriate permissions
- Environment variables set:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY` 
  - `AWS_SESSION_TOKEN` (if using temporary credentials)

### Databricks Requirements
- Admin access to Databricks Account Console
- Service Principal with appropriate permissions
- Account ID, Client ID, and Client Secret for authentication

### Required AWS Permissions
- Create and manage VPCs, subnets, and security groups
- Create and manage S3 buckets and bucket policies
- Create and manage IAM roles and policies
- Create and manage Databricks workspaces

## Configuration

### 1. Set Up Authentication Variables

Copy the example variables file and fill in your Databricks credentials:

```bash
cp variables.auto.tfvars.example variables.auto.tfvars
```

Edit `variables.auto.tfvars` with your actual values:
```hcl
databricks_account_id = "your-account-id"
client_id             = "your-client-id"
client_secret         = "your-client-secret"
```

### 2. Configure Workspace Settings

Edit `main.tf` to customize your deployment. **There are many variables you need to fill out in this file, make sure you read it!**

If you need multiple workspaces, you can re-use the outputs of the workspace_deployment module as the inputs of subsequent workspaces, in order to reutilize components (e.g. use the vpc_id of the first deployment as the input to the second, in order to reuse the same VPC).

## Deployment

### 1. Initialize Terraform
```bash
terraform init
```

### 2. Review the Plan
```bash
terraform plan
```

### 3. Apply the Configuration
```bash
terraform apply
```

### 4. Access Your Workspace

After successful deployment, you'll see outputs including:
- Workspace URL: `https://{workspace-name}.cloud.databricks.com`
- Test notebook path: `/Shared/ws_tester_notebook.ipynb`

## Post-Deployment

### Verify Deployment
1. Access your workspace using the provided URL
2. Navigate to the test notebook at `/Shared/ws_tester_notebook.ipynb`
3. Run the notebook to verify Unity Catalog connectivity

### Access Unity Catalog
- The default catalog "main" is automatically created
- External location is configured for data storage
- Workspace admins have full access to all Unity Catalog resources

## Cleanup

To destroy all created resources:
```bash
terraform destroy
```

**Warning**: This will permanently delete all workspace data, metastore contents, and AWS resources.

## Troubleshooting

### Common Issues
- **VPC Creation Fails**: Ensure your AWS account has VPC creation permissions
- **S3 Bucket Name Conflicts**: The module uses random suffixes, but you may need to adjust the prefix
- **Metastore Assignment Fails**: Ensure the metastore exists and is accessible
- **Error: Provider produced inconsistent final plan**: This erro can happen in some of the later stages of deployment. Wait a couple of minutes and try again.

### Support
For Databricks-specific issues, refer to the [official documentation](https://docs.databricks.com/aws/en/getting-started/onboarding-account).

## Security Notes

- All sensitive values are stored in `variables.auto.tfvars` (add to `.gitignore`)
- IAM roles follow least-privilege principles
- S3 buckets have appropriate bucket policies
- Security groups are configured with minimal required access