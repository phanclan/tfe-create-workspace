# Quick Start
The examples for this repo does four main things.

1. Create workspace-creator.
2. Create workspaces for your org.
	* dns-multicloud
	* hashicat-aws
	* hashicat-gcp
	* gcp-compute-instance-dev-us-west-1
	* aws-ec2-instance-dev-us-west-1
	* aws-ec2-instance-prod-us-west-1
2. Create teams for your org.
	* dev, ops, network, security
3. Assigns teams for your org.
4. Create/update variables for your created workspaces
[terraform-tfe-workspace - Step 4. Create Variables](bear://x-callback-url/open-note?id=5B958914-152D-4C7C-967A-8625501F4EA9-94682-000433567BB8C107&header=Step%204.%20Create%20Variables)


> We broke these into separate workspaces since team creation and assignment can be independent of workspace creation. This also make runs faster and damage blast radius smaller.


- - - -

# Step 0. Pre-requisites

* You will need access to TFC or TFE.
* You will need to have an TF organization created.
* You will need a user account with admin privileges to your TF organization.
* You will need to add two users to your organization to represent a dev person and an ops person.
* Create a TF user token using `terraform login` or create a `$HOME/.terraformrc` file with your admin user token.
* Connect your TF Org to a VCS Provider.
* Need repos for (which you can fork from github.com/phanclan)
	* dns-multicloud
	* hashicat-aws
	* hashicat-gcp
	* gcp-compute-instance-dev-us-west-1
	* aws-ec2-instance-dev-us-west-1
	* aws-ec2-instance-prod-us-west-1
* Clone this repo for creating workspaces in TF.
```
git clone https://github.com/phanclan/tfe-create-workspace.git
```

* Environmental Variables - Replace with your own values for `TF_ADDR` and `ORG`

``` shell
export TF_ADDR=https://app.terraform.io
export ORG=pphan

# if terraformrc exists, use it. else look for credentials.tfrc.json.
if [ -f $HOME/.terraformrc ]; then
  export TFE_TOKEN=$(grep token $HOME/.terraformrc | cut -d '"' -f2)
elif [ -f $HOME/.terraform.d/credentials.tfrc.json ]; then
  export TFE_TOKEN=$(jq -r .credentials.\"app.terraform.io\".token $HOME/.terraform.d/credentials.tfrc.json)
else
  echo "\n💀 You have NO TF creds defined"
  exit
fi

export oauth_token_id=$(curl -s -H "Authorization: Bearer $TFE_TOKEN" $TF_ADDR/api/v2/organizations/$ORG/oauth-tokens | \
  jq -r '.data | .[1].id')

# The following is needed for workspace-creator
export TF_VAR_tfe_token=$TFE_TOKEN
# Next line is redundant
#export TF_VAR_tfe_token=$(grep token ~/.terraformrc | cut -d '"' -f2)
```

* Populate Cloud Credentials.

``` shell
# export variables from doormat
export AWS_ACCESS_KEY_ID=<access_key_id>
export AWS_SECRET_ACCESS_KEY=<secret_access_key>
export AWS_SESSION_TOKEN=<session_token>

# set TF variables.
export TF_VAR_AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export TF_VAR_AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export TF_VAR_AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN
export TF_VAR_GOOGLE_CREDENTIALS=$(cat $HOME/.gcp/CRED_FILE.json.test)
export TF_VAR_oauth_token_id=$oauth_token_id
```

Change the google credential value as needed.

## Workspace Creator

- - - -

# Step 1. Create Workspaces
This example creates several workspaces.

* Workspaces
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


- - - -

# Step 2. Create Teams

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


- - - -

# Step 3. Assign Teams

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

The resources in this module, will assign teams to a specific workspace. It will loop through each kv pair in `local.team_<name>` and add the team and permission specified. There are four `tfe_team_access` resources. One for each team that we created.

Initialize and apply.
```
terraform init
terraform apply
```

There are no outputs configured for this module.


- - - -

# Step 4. Create Variables

I use a portal to gain temporary access to our AWS environment. This poses some interesting challenges when Terraform Cloud workspaces are tied to these temporary permissions.

To workaround this, I use the  `workspace-creator` to set cloud credential terraform variables in `1-create-workspaces`. There are a few key steps.

1. Use a script to set the values for the variables in the `4-create-variables` workspace.
2. Use `tfe_variable` resources
	1. tied to workspace data source (`tfe_workspace_ids`)
	2. which is to a variable list (`workspace_ids`) to assign cloud credentials to my other workspaces.

### Detailed Steps
* Create the `4-create-variables` workspace.
	* I added a `ws-create-variables.tf` file into `1-create-workspaces` project.
	* This will create a new workspace called `4-create-variables`.
		* Triggers `plan` upon `git commit`.
	* The workspace is VCS tied to
		* Repo: `phanclan/tfe-create-workspace`
		* Working Directory: `examples/4-create-variables`
* Set cloud credentials
	* Set variables in this workspace using terraform-guides variable script.
	* **Option 1**: I use the `tfe_variable` resource to set these.

* From local machine, go to `workspace-creator` folder

```
cd ../workspace-creator
```

* Export `TF_VAR` variables with new credentials.

```
# set TF variables.
export TF_VAR_AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export TF_VAR_AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export TF_VAR_AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN
export TF_VAR_GOOGLE_CREDENTIALS=$(cat $HOME/.gcp/CRED_FILE.json.test)
export TF_VAR_oauth_token_id=$oauth_token_id
```

* Apply changes

```
terraform apply
```

* Queue up a plan for `workspace-creator` from TFC.
* Your new values will now be pushed to other workspaces.

	* I don't use the `tfe_variable` resource to set these.
	* Since my credentials change often. It is easier for me to export using the script.
	* Alternatively, I could execute this workspace locally and use my local environmental variables.
* Tell workspace which workspaces it should create variables for.
	* Currently, using `terraform.auto.tfvars` files.
	* Set value for `workspace_ids`. This is a list of all the workspaces I want to apply these variables to.
	* At a minimum, I add the following:
		* `dns-multicloud` - so my projects have a DNS zone
		* `hashicat-aws` - my go to demo.
* Push the changes out

```
git commit "update" && git push
```

GCP only allows `-` and `_` symbols in their tags, and an email address contains `@` and `.`.
Information on  [GCP label format limits](https://cloud.google.com/compute/docs/labeling-resources#label_format)

Enable Cloud DNS API
https://console.developers.google.com/apis/api/dns.googleapis.com/overview?project=449803287135

- - - -

## What's Next?

You can set variables for your workspaces

## Destroy changes

To destroy everything, go in reverse.
```
cd ../3-assign-teams/ && terraform destroy
```

Remove teams that we created.
```
cd ../2-create-teams/ && terraform destroy
```

Remove workspaces that we created.
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