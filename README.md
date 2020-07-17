# Quick Start
* The examples for this repo does three main things.
	* Create workspaces for your org.
		* hashicat-aws
		* gcp-compute-instance-dev-us-west-1
		* aws-ec2-instance-dev-us-west-1
		* aws-ec2-instance-prod-us-west-1
	* Create teams for your org.
		* dev, ops, network, security
	* Assigns teams for your org.

> We broke these into separate workspaces since team creation and assignment can be independent of workspace create. This also make runs faster and damage blast radius smaller.

## Step 0. Pre-requisites

* You will need access to TFC or TFE.
* You will need to have an TF organization created.
* You will need a user account with admin privileges to your TF organization.
* You will need to add two users to your organization to represent a dev person and an ops person.
* Create a TF user token using `terraform login` or create a `$HOME/.terraformrc` file with your admin user token.
* Connect your TF Org to a VCS Provider.

* Clone the repo.
```
git clone https://github.com/phanclan/tfe-create-workspace.git
```

* Environmental Variables - Replace with your own values for `TF_ADDR` and `ORG`

``` shell
export TF_ADDR=https://app.terraform.io
export ORG=pphan

# if terraformrc exists, use it. else look for credentials.tfrc.json.
if [ -f $HOME/.terraformrc ]; then
  export TFE_TOKEN=$(grep token ~/.terraformrc2 | cut -d '"' -f2)
elif [ -f $HOME/.terraform.d/credentials.tfrc.json2 ]; then
  export TFE_TOKEN=$(jq -r .credentials.\"app.terraform.io\".token $HOME/.terraform.d/credentials.tfrc.json2)
else
	echo "\n💀 You have NO TF creds defined"
fi

export TF_VAR_oauth_token_id=$(curl -s -H "Authorization: Bearer $TFE_TOKEN" $TF_ADDR/api/v2/organizations/$ORG/oauth-tokens | \
  jq -r '.data | .[1] | .id')

# The following is not needed
export TF_VAR_tfe_token=$(grep token ~/.terraformrc | cut -d '"' -f2)
```


## Step 1. Create Workspaces
This example creates four workspaces.

* Four Workspaces
	* hashicat-aws
	* gcp-compute-instance-dev-us-west-1
	* aws-ec2-instance-dev-us-west-1
	* aws-ec2-instance-prod-us-west-1

* Go **1-create-workspaces** folder.
```
cd  examples/1-create-workspaces
```

* Replace variable default for `tfc_org`.

We need a module for each workspace we want to create. Two are provided for example. One with VCS connection and one without VCS connection

* For each module, do the following:
	* Provide values for:
		* `workspace_name`
		* `tf_version`.
	* If VCS connection is required, then provide values for VCS section.
		* `vcs_repo_identifier`
		* `working_directory`
		* `workspace_branch`
		* `oauth_token_id`
			* Provide either through a `terraform.tfvars` file or in an environmental variable see Pre-reqs:

Initialize and apply.
```
terraform init -upgrade
terraform apply
```

I use `-upgrade` to make sure I get the latest version of the providers. This may not be appropriate for you.


## Step 2. Create Teams

This will create four teams: **dev**, **ops**, **network**, **security**.

* Go **2-create-teams** folder.
```
cd  ../2-create-teams
```
* Replace variable `tfc_org`.
* Replace `team_name` per module with your own.
* Replace `team_members` with your own values. Keep the same format.
	* This assigns users to the team.

> Will use module `for_each` with **0.13** in the future to simplify the configuration.

**NOTE**
* The `dev` user is only assigned to `team-dev`.
* When they login, they will only see workspaces that `team-dev` is assigned to.
	* In my example, those workspaces are:
		* `hashicat-aws`
		* `aws-*-dev-*`
		* `aws-*-prod-*`

I left a template for both the **module** and **output** in case you want to create more teams.

Initialize and apply.
```
terraform init
terraform apply
```

You should see outputs for all the `team_id`'s.


## Step 3. Assign Teams

This will assign the four teams from step 2 (dev, ops, network, security) to workspaces created in step 1.

* Go **3-assign-teams** folder.
```
cd  ../3-assign-teams
```
* Replace variable `tfc_org`.
* Under `locals` stanza
	* Add `team_changeme = {}` for each additional team you want to assign to workspace.
		* Need to provide `team_id` and privileges.
		* ex `"${data.tfe_workspace.workspace-1.id}" = "read"`
* Need a `data.tfe_workspace` data source for each workspace you want to add teams to.
	* Or you can use the `team_id` outputs from Step 2.
	* I use the data source since I can reference workspaces that I did not create.

> Will use module **for_each** with 0.13 in the future.

The resources in this module, will assign teams to a specific workspace. It will loop through each kv pair in `local.team_<name>` and add the team and permission specified. There are four tfe_team_access resources. One for each team that we created.

Initialize and apply.
```
terraform init
terraform apply
```

There are no outputs configured for this module.


## What's Next?

You can set variables for your workspaces

## Destroy changes

To destroy everything, go in reverse.
```
cd ../3-assign-teams/ && terraform destroy
```

```
cd ../2-create-teams/ && terraform destroy
```

```
cd ../1-create-workspaces/ && terraform destroy
```


- - - -

# What's in the files and modules?

#### versions.tf
Modify the following for `versions.tf`.
We specify the versions for providers and terraform client here.

#### modules/tfe/main.tf


#### modules/tfe_team/main.tf



- - - -

# To Do

* Add an example to create workspaces for the steps above.
* Break out the outputs and variables into their own files for each step.