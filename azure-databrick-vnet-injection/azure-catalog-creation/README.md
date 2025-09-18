## Azure Databricks - Catalog Creation for Existing Workspace

This example provisions cloud storage, access connector, a Databricks storage credential and an external location in an existing Azure Databricks workspace. Use the resulting external location to back a catalog you create via SQL/UI (best practice).

### What it does
- Creates an ADLS Gen2 storage account and container
- Creates an Azure Databricks Access Connector and assigns required roles on storage
- Creates a `databricks_storage_credential` using the access connector
- Creates a `databricks_external_location` pointing to a folder in the container
- Optionally grants privileges on the external location

### Prerequisites
- Existing Azure Databricks workspace already attached to a Unity Catalog metastore
- Azure CLI logged in: `az login`
- Databricks CLI auth via Azure (`auth_type = azure-cli`) or `DATABRICKS_TOKEN`
- The following information:
  - `azure_workspace_resource_id` of the workspace
  - `workspace_host` (e.g. `https://adb-123456789.12.azuredatabricks.net`)
  - `metastore_id` where the catalog(s) will be created
  - Optional external location URL to back managed tables (for `storage_root`)
  - `subscription_id` (or run `az account set --subscription <ID>`)

### Variables
See `variables.tf` for full list. Key inputs:
- `workspace_host`, `azure_workspace_resource_id`
- `resource_group_name`, `location`
- `access_connector_name`
- `storage_account_name`, `container_name`
- `external_location_path`, `external_location_name`, `storage_credential_name`
- `external_location_grants`

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
- `external_location_url`: Full abfss:// URL
- `external_location_name`: External location name
- `storage_credential_name`: Storage credential name

### Catalog creation: manual or automated
By default, this example only provisions storage/credential/external location.

If you prefer to create the catalog via Terraform, set `create_catalog = true` and provide `catalog_name`. The module will create the catalog, optional grants (`catalog_grants`), and can set it as default (`set_default_catalog`).

If you keep it manual, create the catalog in SQL/UI referencing the external location. Example (SQL):
```sql
CREATE CATALOG analytics
MANAGED LOCATION 'abfss://uc@stgucxxxxxxxx.dfs.core.windows.net/catalogs/analytics';
```
Alternatively, you can keep catalogs as default and create schemas/tables with explicit locations.


### Files in this folder
- `provider.tf`: Configures the Databricks (workspace) and Azure providers used by this module.
- `variables.tf`: Declares input variables controlling storage, credentials, and optional catalog creation.
- `main.tf`: Provisions ADLS, Access Connector, storage credential, external location, and optional catalog/default.
- `variables.auto.tfvars.example`: Example values to copy into `variables.auto.tfvars` for quick start.
- `README.md`: This guide explaining usage, prerequisites, variables, and outputs.


