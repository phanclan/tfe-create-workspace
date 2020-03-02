# TFE Quick Start

Creates a workspace in TFE connected to VCS and sets up the appropriate producer/consumer users and permissions.

See [examples here](https://github.com/hashicorp-modules/terraform-tfe-workspace/tree/master/examples).

Modify workspace_ids variable in terraform.tfvars. tfe_variable resources use this variable to determine which workspaces to create variables in.

## Environment Variables

- `TF_VAR_tfe_org_name`
- `TF_VAR_tfe_org_email`
- `TF_VAR_tfe_token`

## Input Variables

- `tfe_token`: [Required] Token from the TFE account for the TFE provider API access.
- `tfe_org_name`: [Required] Name of organization to be created in TFE.
- `tfe_org_email`: [Required] Email for organziation to be created in TFE.
- `tfe_org_id`: [Optional] ID of organization in TFE to use, if empty, an organization will be created.
- `tfe_producer_name`: [Optional] Name of the "Producer" workspace and team, defaults to "tfe-workspace-producer".
- `tfe_producer_team_id`: [Optional] ID of "Producer" team in TFE to use, if empty, a team will be created.
- `tfe_producer_team_access`: [Optional] Access level for the "Producer" team, defaults to "admin".
- `tfe_consumer_name`: [Optional] Name of the "Consumer" team, defaults to "tfe-workspace-consumer".
- `tfe_consumer_team_id`: [Optional] ID of "Consumer" team in TFE to use, if empty, a team will be created.
- `tfe_consumer_team_access`: [Optional] Access level for the "Consumer" team, defaults to "read".
- `vcs_repo_identifier`: [Optional] Org and repo name for VCS, defaults to `hashicorp-modules/terraform-tfe-workspace`.
- `vcs_repo_branch`: [Optional] github branch name, defaults to "master".
- `working_directory`: [Optional] Working directory for Terraform to run in, defaults to the root directory.
- `net_access`: Access for network teams. aws-ec2-instance-dev-us-west-1, aws-ec2-instance-prod-us-west-1,azure-dev
    - NOTE: no spaces before or after commas.

# Put your creds into environment variables
Run the following commands to put your creds into environment variables

    ```
    export TF_VAR_aws_access_key_id=$(sed -n '/default/{n;p;}' ~/.aws/credentials | awk '{print $NF}')
    export TF_VAR_aws_secret_access_key=$(sed -n '/default/{n;n;p;}' ~/.aws/credentials | awk '{print $NF}')
    export TF_VAR_gcp_credentials=$(cat ~/.gcp/CRED_FILE_join.json)
    export TF_VAR_arm_client_secret=$(cat ~/.Azure/creds2.txt| jq -r .password)
    export TF_VAR_arm_client_id=$(cat ~/.Azure/creds2.txt| jq -r .appId)
    ```



## Outputs

- `zREADME`: The module README.
- `org_id`: The TFE organization ID.
- `producer_team_id`: The TFE Producer team ID.
- `consumer_team_id`: The TFE Consumer team ID.
- `producer_workspace_id`: The TFE Producer workspace ID.





## Authors

HashiCorp Solutions Engineering Team.

## License

Mozilla Public License Version 2.0. See LICENSE for full details.
