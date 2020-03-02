#!/bin/bash

echo "Installing jq"
curl --silent -Lo ./jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
chmod +x jq

echo "VCS must be enabled in your TFE organization for this to work"
echo "Writing oAuth token locally to be read by Terraform"
curl \
  --header "Authorization: Bearer ${token}" \
  https://app.terraform.io/api/v2/organizations/${organization}/oauth-tokens \
  | jq -r '.data | .[] | .id' | tr -d '\n' > .oauth-token
