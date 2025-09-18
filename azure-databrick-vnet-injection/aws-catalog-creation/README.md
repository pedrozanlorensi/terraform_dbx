## AWS Databricks - Catalog Creation for Existing Workspace

This example provisions S3 storage, IAM role and policy, a Databricks storage credential, and an external location in an existing Databricks workspace on AWS. Use the resulting external location to back a catalog you create via SQL/UI (best practice).

### What it does
- Creates an S3 bucket to host managed data for the catalog
- Generates and attaches the Unity Catalog access IAM policy and role
- Creates a `databricks_storage_credential` using that role
- Creates a `databricks_external_location` to a prefix in the bucket
- Optionally grants privileges on the external location

### Prerequisites
- Existing Databricks workspace already attached to a Unity Catalog metastore
- Account-level OAuth credentials (recommended) or PAT for the workspace
- The following information:
  - `workspace_host` (e.g. `https://dbc-xxxxxxxx-xxxx.cloud.databricks.com`)
  - `databricks_account_id`, `client_id`, `client_secret` (if using account OAuth)
  - `metastore_id` where the catalog(s) will be created
  - Optional external location URL to back managed tables (`storage_root`)

### Variables
See `variables.tf` for full list. Key inputs:
- `workspace_host`, `client_id`, `client_secret`
- `resource_prefix`, `databricks_account_id`, `tags`
- `external_bucket_name` (optional), `external_location_prefix`, `external_location_name`
- `storage_credential_name`, `external_location_grants`

### Usage
1) Copy example tfvars and edit values:
```bash
cp variables.auto.tfvars.example variables.auto.tfvars
```

2) Initialize and apply:
```bash
terraform init
terraform plan
terraform apply
```

2a) What these commands do (one-liners):
- `terraform init`: Downloads providers and initializes the working directory.
- `terraform plan`: Shows the changes Terraform will make without applying them.
- `terraform apply`: Applies the planned changes to create/update resources.

### Outputs
- `external_location_url`: Full s3:// URL
- `external_location_name`: External location name
- `storage_credential_name`: Storage credential name

### Catalog creation: manual or automated
By default, this example only provisions storage/credential/external location.

If you prefer to create the catalog via Terraform, set `create_catalog = true` and provide `catalog_name`. The module will create the catalog, optional grants (`catalog_grants`), and can set it as default (`set_default_catalog`).

If you keep it manual, create the catalog in SQL/UI referencing the external location. Example (SQL):
```sql
CREATE CATALOG analytics
MANAGED LOCATION 's3://<generated-bucket>/catalogs/analytics/';
```
Alternatively, you can keep catalogs as default and create schemas/tables with explicit locations.


### Files in this folder
- `provider.tf`: Configures Databricks (workspace) and AWS providers for this example.
- `variables.tf`: Declares inputs for region, naming, IAM, external location, and optional catalog creation.
- `main.tf`: Provisions S3 bucket, IAM role/policy, storage credential, external location, and optional catalog/default.
- `variables.auto.tfvars.example`: Example values to copy into `variables.auto.tfvars` for quick start.
- `README.md`: This guide explaining usage, prerequisites, variables, and outputs.


