# resource "databricks_notebook" "workspace_tester" {
#   provider = databricks.workspace
#   path     = "/Shared/ws_tester_notebook.ipynb"
#   language = "SQL"
#   source   = "${path.module}/ws_tester_notebook.sql"
  
#   depends_on = [
#     databricks_mws_workspaces.this,
#     time_sleep.wait_2_minutes
#   ]
# } 