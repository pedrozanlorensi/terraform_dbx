module "workspace_deployment" {
    source = "./resources"

    # Databricks settings
    # Since these are sensitive, they are filled out in a separate variables file.
    # Fill these out with your secret values before running the Terraform script.
    databricks_account_id = var.databricks_account_id
    client_id = var.client_id
    client_secret = var.client_secret
    
    # General settings
    # AWS access key and secret key for the AWS provider are set in Envinronment Variables
    # Set these (can be found in your AWS Access Portal):
    #   AWS_ACCESS_KEY_ID
    #   AWS_SECRET_ACCESS_KEY
    #   AWS_SESSION_TOKEN
    prefix = "<prefix>"
    resource_prefix = "<resource_prefix>"
    region = "<region>"
    
    # Variables for the customer-managed VPC module
    vpc_id = "" # If you have an existing VPC, specify its ID here. If not, it will be created.
    subnet_ids = [ ] # If you have existing subnets, specify their IDs here. If not, they will be created.
    vpc_cidr_range = "10.31.0.0/20" 
    availability_zones = ["<region>-1a", "<region>-1b"]
    public_subnets_cidr = ["10.31.0.0/24", "10.31.1.0/24"]
    private_subnets_cidr = ["10.31.2.0/24", "10.31.3.0/24"]
    
    # Security group settings
    security_group_ids = [ ] # If you have existing security groups, specify their IDs here. If not, they will be created.
    sg_egress_ports = [443, 3306, 6666, 2443, 8443, 8444, 8445, 8446, 8447, 8448, 8449, 8450, 8451]
    
    # Metastore settings
    # If you have an existing metastore, specify its ID here. If not, it will be created.
    metastore_name = "<metastore_name>" # Metastore name is required only if there is no metastore already created
    metastore_id = "" # If you have an existing metastore, specify its ID here. If not, it will be created.

    # Access control settings
    # Note that the Service Principal used to run this script will be added to both lists automatically, you shouldn't add it manually here
    # List of usernames that will have admin access to the workspace, recommended to add your user email here
    workspace_admin_usernames = [
        "<user_email>",
        "<user_email>",
        "<user_email>" # add more user emails here
    ]
    # Name of the workspace admin group (will be prefixed with the resource_prefix)
    workspace_admins_group_name = "workspace-admins"
    # List of usernames that will have owner access to the metastore, recommended to add your user email here
    metastore_owner_usernames = [
        "<user_email>",
        "<user_email>",
        "<user_email>" # add more user emails here
    ]
    # Name of the metastore owners group (will be prefixed with the resource_prefix)
    metastore_owners_group_name = "metastore-owners"
}

