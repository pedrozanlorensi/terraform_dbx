# Get unique set of users from both admin lists
locals {
  all_users = toset(concat(var.workspace_admin_usernames, var.metastore_owner_usernames))
}

# Create each user exactly once
data "databricks_user" "users" {
  for_each = local.all_users
  provider = databricks.mws
  user_name = each.value
  depends_on = [databricks_mws_workspaces.this]
}

data "databricks_service_principal" "service_principal" {
  provider = databricks.mws
  application_id = var.client_id
  depends_on = [databricks_mws_workspaces.this]
}

# Create metastore owners group
resource "databricks_group" "metastore_owners" {
  count = var.metastore_id == "" ? 1 : 0
  provider = databricks.mws
  display_name = "${var.resource_prefix}-${var.metastore_owners_group_name}"
  depends_on = [databricks_mws_workspaces.this]
}

# Create workspace admins group
resource "databricks_group" "workspace_admins" {
  count = var.metastore_id == "" ? 1 : 0
  provider = databricks.mws
  display_name = "${var.resource_prefix}-${var.workspace_admins_group_name}"
  depends_on = [databricks_mws_workspaces.this]
}

# Add users to workspace admin group
resource "databricks_group_member" "workspace_admins" {
  for_each = var.metastore_id == "" ? toset(var.workspace_admin_usernames) : []
  provider = databricks.mws
  group_id  = databricks_group.workspace_admins[0].id
  member_id = data.databricks_user.users[each.value].id
  depends_on = [databricks_group.workspace_admins, data.databricks_user.users, databricks_mws_workspaces.this]
}

# Add users to metastore owners group
resource "databricks_group_member" "metastore_owners" {
  for_each = var.metastore_id == "" ? toset(var.metastore_owner_usernames) : []
  provider = databricks.mws
  group_id  = databricks_group.metastore_owners[0].id
  member_id = data.databricks_user.users[each.value].id
  depends_on = [databricks_group.metastore_owners, data.databricks_user.users, databricks_mws_workspaces.this]
}

# Add client_id (service principal) to workspace admin group
resource "databricks_group_member" "workspace_admins_service_principal" {
  count = var.metastore_id == "" ? 1 : 0
  provider = databricks.mws
  group_id  = databricks_group.workspace_admins[0].id
  member_id = data.databricks_service_principal.service_principal.id
  depends_on = [databricks_group.workspace_admins, databricks_group_member.workspace_admins, databricks_mws_workspaces.this, data.databricks_service_principal.service_principal, databricks_metastore_assignment.this]
}

# Add client_id (service principal) to metastore owners group
resource "databricks_group_member" "metastore_owners_service_principal" {
  count = var.metastore_id == "" ? 1 : 0
  provider = databricks.mws
  group_id  = databricks_group.metastore_owners[0].id
  member_id = data.databricks_service_principal.service_principal.id
  depends_on = [databricks_group.metastore_owners, databricks_group_member.metastore_owners, databricks_mws_workspaces.this, data.databricks_service_principal.service_principal, databricks_metastore_assignment.this]
}
