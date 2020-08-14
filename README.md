# Quick Start
The examples for this repo does four main things.

1. Create workspace-creator.
2. Create workspaces for your org.
	1. dns-multicloud
	2. hashicat-aws
	3. hashicat-gcp
	4. gcp-compute-instance-dev-us-west-1
	5. aws-ec2-instance-dev-us-west-1
	6. aws-ec2-instance-prod-us-west-1
3. Create teams for your org.
	* dev, ops, network, security
3. Assigns teams for your org.
4. Create/update variables for your created workspaces
[terraform-tfe-workspace - Step 4. Create Variables](bear://x-callback-url/open-note?id=5B958914-152D-4C7C-967A-8625501F4EA9-94682-000433567BB8C107&header=Step%204.%20Create%20Variables)


> We broke these into separate workspaces since team creation and assignment can be independent of workspace creation. This also make runs faster and damage blast radius smaller.


- - - -

# 🟢 Step 0. Pre-requisites

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
export ORG=pphan && export TF_VAR_tfc_org=$ORG

# if terraformrc exists, use it. else look for credentials.tfrc.json.
if [ -f $HOME/.terraformrc ]; then
  export TFE_TOKEN=$(grep token $HOME/.terraformrc | cut -d '"' -f2)
elif [ -f $HOME/.terraform.d/credentials.tfrc.json ]; then
  export TFE_TOKEN=$(jq -r .credentials.\"app.terraform.io\".token $HOME/.terraform.d/credentials.tfrc.json)
else
  echo "\n💀 You have NO TF creds defined"
  exit
fi

# Your jq filter might need to be different based on VCS provider order
export oauth_token_id=$(curl -s -H "Authorization: Bearer $TFE_TOKEN" $TF_ADDR/api/v2/organizations/$ORG/oauth-tokens | \
  jq -r '.data | .[1].id')

# The following is needed for workspace-creator
export TF_VAR_tfe_token=$TFE_TOKEN

# Next line is redundant
#export TF_VAR_tfe_token=$(grep token ~/.terraformrc | cut -d '"' -f2)
```

> For the `oauth_token_id`, I specified `.[1]` in my `jq` filter. I have two VCS providers, and the one I work with the most is the second one. You might need to specify `.[0]` or some other value.

* Export credentials from Doormat

``` shell
# export variables from doormat
export AWS_ACCESS_KEY_ID=<access_key_id>
export AWS_SECRET_ACCESS_KEY=<secret_access_key>
export AWS_SESSION_TOKEN=<session_token>
```

* Populate Cloud Credentials.

```shell
# set TF variables.
export TF_VAR_AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export TF_VAR_AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export TF_VAR_AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN
export TF_VAR_GOOGLE_CREDENTIALS=$(cat $HOME/.gcp/CRED_FILE.json.test)
export TF_VAR_oauth_token_id=$oauth_token_id
```

Change the azure and google credential value as needed.


# 🟢 Workspace Creator
* Go to `tfe-create-workspace/examples/workspace-creator` directory.

```
cd tfe-create-workspace/examples/workspace-creator
```

* Deploy workspace create to TFC. Initialize and apply with terraform.

```
terraform init -upgrade
terraform apply
```

I use `-upgrade` to make sure I get the latest version of the providers. This may not be appropriate for you.

> 💡NOTE: There is a TFE provider bug. If you’ve deployed this workspace before, and then deleted it from the UI manually, you will get the following error.

```
Error: Error retrieving workspace ws-X27MEevtKdVrmX4y: resource not found
```

> To resolve this, I delete my `terraform.tfstate` file and `apply` again.

## Verification
* Make sure you see a new workspace in TFC called: `1-create-workspaces`
* You should also see all the workspaces that we mentioned above.
* `dns-multicloud` and `hashicat-aws` should be running a plan. They were configured to queue a plan on creation.
	* These runs will error out, which is expected. The cloud variables have not been applied, yet.


- - - -

# 🟢 Step 1. Create Workspaces

This example creates several workspaces.

1. dns-multicloud
2. hashicat-aws
3. hashicat-gcp
4. gcp-compute-instance-dev-us-west-1
5. aws-ec2-instance-dev-us-west-1
6. aws-ec2-instance-prod-us-west-1

Once `1-create-workspaces` is created it will automatically do a VCS triggered run.

> 🛑 NOTE: Many of example workspaces already have defaults defined either in the variable definition or through an `*.auto.tfvars` file. Plain `.tfvars` files are ignored by TFC. However, `auto.tfvars` are processed. You will need to specify your specific information for those workspace, which is not covered here.

* Go to **1-create-workspaces** folder.
```
cd  examples/1-create-workspaces
```

* Replace variable default for `tfc_org`.


## Cloud Credentials
Modify list of workspaces you want to apply cloud credentials to. The workspace_ids variable contains the list of workspaces that we will create credential variables for.

* Edit `terraform.auto.tfvars`
* Modify the `workspace_ids` value. It currently has dns-multicloud and hashicat-aws.
```
workspace_ids = [
"dns-multicloud",
"hashicat-aws",
]
```

* I will add two more to the list.
```
workspace_ids = [
"dns-multicloud",
"hashicat-aws",
"hashicat-gcp",
"aws-ec2-instance-dev-us-west-1",
]
```

* Commit and push changes.
```
git commit -am "update" && git push
```

* This will cause the workspace creator to set the variables on the designated workspaces.


## Verification
* Confirm that your new workspaces have the desired cloud credentials.
	* TFC UI: **<WORKSPACE>** > **Variables** > **Environment Variables** section
	* Ex. AWS, Google, Azure
* Confirm that your git commit triggered a VCS run in TFC for `1-create-workspaces` and that it **Applied** successfully.
* Confirm that "`dns-multicloud`" has a plan queued automatically.
	* Status of **NEEDS CONFIRMATION**.
	* This is caused by our new **Run Triggers** functionality.
	* `1-create-workspaces` is designated as a source workspace. When it finishes an apply, then a plan is queued for all linked workspaces.
* Approve the apply. Click **Confirm & Apply**. Then, click **Confirm Plan**.

* Confirm that `hashicat-aws` has a plan queued automatically.
	* Status of **NEEDS CONFIRMATION**.
	* `dns-multicloud` is designated as a source workspace for `hashicat`. When it finishes an apply, then a plan is queued for all linked workspaces.
* Approve the apply. Click **Confirm & Apply**. Then, click **Confirm Plan**.


## Create a new workspace
We need a module for each workspace we want to create. Several are provided for example. One with VCS connection and one without VCS connection

* To create a new workspace. Create a new `.tf `file inside `1-create-workspaces` or add to an existing `.tf` file the following info.
	* Provide values for:
		* `workspace_name`
		* `tf_version`.
	* If VCS connection is required, then provide values for VCS section.
		* `vcs_repo_identifier`
		* `working_directory`
		* `workspace_branch`
		* `oauth_token_id`
			* Provide either through a `terraform.tfvars` file or in an environmental variable see Pre-reqs:

Sample - Replace `<NAME>` with your own value.
```
module "ws-<NAME>" {
  source         = "../../modules/tfe"
  organization   = var.tfc_org
  workspace_name = "<NAME>"
  queue_all_runs = false
  auto_apply     = true
  tf_version     = "0.12.29"
  # VCS Section - if you don't want VCS then comment out section below.
  vcs_repo = [
    {
      vcs_repo_identifier = "phanclan/<NAME>"
      working_directory   = ""
      workspace_branch    = "" # default: master
      oauth_token_id      = var.oauth_token_id
    }
  ]
}

output "ws-<NAME>_id" {
  value = module.ws-<NAME>.workspace_id
}
```

* Commit and push changes.

```
git commit -am "update" && git push
```


## Verification
* Confirm that your git commit triggered a VCS run in TFC for 1-create-workspaces.
* Confirm that your new workspace was created.
* NOTE: You need run the create twice. Once to create the new workspace. And, again to apply the variables.

🛑 At this point, I usually skip to Step 4. If you want to create and assign teams, then go to the next step.

- - - -

# 🟡 Step 2. Create Teams

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

# 🟡 Step 3. Assign Teams

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

# 🟢 Step 4. Create Variables

I use a portal to gain temporary access to our AWS environment. This poses some interesting challenges when Terraform Cloud workspaces are tied to these temporary permissions.

To workaround this, I use the  `workspace-creator` to set cloud credential terraform variables in `1-create-workspaces`. Whenever credentials change, I load them into my local machine's env vars, and then push it out with with terraform.


## Who's doing the work?

* `create-variables.tf` contains all `tfe_variable` resource definitions.
* The resource uses a `for_each` loop to determine which workspaces to  create the variable for.
* The `create_workspaces` data source uses a list to determine which workspaces it should provide `workspace_ids` for.
* The list is provided by the `workspace_ids` variable, which you modified earlier.


## Detailed Steps

* From local machine, go to `workspace-creator` folder

```
cd ../workspace-creator
```


### Update the creator

* Export `TF_VAR` variables with new credentials.

```
# set TF variables.
export TF_VAR_AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export TF_VAR_AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export TF_VAR_AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN
export TF_VAR_GOOGLE_CREDENTIALS=$(cat $HOME/.gcp/CRED_FILE.json.test)
export TF_VAR_oauth_token_id=$oauth_token_id
```

* Update pass thru variables in `1-create-workspaces`.

```
terraform apply
```


### Push the changes to the children

* Tell **workspace creator** which workspaces it should create variables for.
	* Currently, using `terraform.auto.tfvars` files.
	* Edit `terraform.auto.tfvars` file.
	* Set value for `workspace_ids`. This is a list of all the workspaces I want to apply these variables to.
	* `dns-multicloud` and `hashicat-aws` should already be part of the list.
	* Add "`hashicat-gcp`" to the list.
* Queue up a plan for `1-create-workspaces` with git.

```
git commit -am "update" && git push
```

* Your new values will now be pushed to other workspaces.


- - - -


# Destroy changes
To destroy everything, go in reverse.

* Queue destroy plan for workspaces that you created and applied.

```
UI: Workspace > Settings > Desstruction and Deletion > Queue destroy plan
```

* Queue destroy plan for team workspaces and assignment that you created and applied.

```
cd ../3-assign-teams/ && terraform destroy
```

* Remove teams that we created.

```
cd ../2-create-teams/ && terraform destroy
```

* Remove workspaces that we created.

```
cd ../1-create-workspaces/ && terraform destroy
```

* Destroy the workspace-create.

```
cd ../workspace-creator/ && terraform destroy
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

* Add an example to create workspaces for the steps above. - done
* Break out the outputs and variables into their own files for each step.