# Quick Start

- Create a workspace in TFE connected to VCS.
- Creates Ops and Dev teams.

- You need to replace `name` for tfe_team ops and dev with your own.
- You need to replace `username` with your own for ops and dev.
* Replace the variables or values in workspaces.tf.
* Replace the variables or values in teams.tf.
* Run this command to fetch your terraform token from `.terraformrc` and store it as the `TOKEN` environment variable:
	* NOTE: You need to have a `.terraformrc` file for this to work.
```
export ORG=pphan
export TFE_TOKEN=$(grep token ~/.terraformrc | cut -d '"' -f2)
export TF_VAR_tfe_token=$(grep token ~/.terraformrc | cut -d '"' -f2)
export TF_VAR_oauth_token_id=$(curl -s -H "Authorization: Bearer $TFE_TOKEN" https://app.terraform.io/api/v2/organizations/$ORG/oauth-tokens | \
  jq -r '.data | .[1] | .id')
```

## Teams Created
* Team: hashicat-ops
	* Org Access: “”
	* Visibility: Secret
	* Members: pphan-ops
* Team: hashicat-dev
	* Org Access: “”
	* Visibility: Secret
	* Members: phanpeterhc1, pphan-dev
