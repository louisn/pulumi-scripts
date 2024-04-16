#!/bin/bash

# Preserve variable state from the pipeline subcommands
shopt -s lastpipe

echo "converts a stack from aws to a pulumi bulk import json file."

# Define a mapping from AWS resource types to Pulumi type tokens as a JSON object
type_mapping='{
  "AWS::S3::Bucket": "aws:s3/bucket:Bucket",
  "AWS::IoT::Policy": "aws:iot/policy:Policy",
  "AWS::IoT::ProvisioningTemplate": "aws:iot/provisioningTemplate:ProvisioningTemplate",
  "AWS::IAM::Role": "aws:iam/role:Role",
  "AWS::IoT::RoleAlias": "aws:iot/roleAlias:RoleAlias"
}'
# Add more mappings as needed...

# Check for dependencies
if ! command -v aws &> /dev/null; then
  echo "AWS CLI is not installed. Please install it: https://aws.amazon.com/cli/"
  exit 1
fi

if ! command -v jq &> /dev/null; then
  echo "jq is not installed. Please install it: https://stedolan.github.io/jq/"
  exit 1
fi

# Get stack name from the user
read -p "Enter the CloudFormation stack name: " stack_name

# Validate stack existence
if ! aws cloudformation describe-stacks --stack-name "$stack_name" &> /dev/null; then
  echo "CloudFormation stack '$stack_name' does not exist."
  exit 1
fi

# Describe stack resources and extract relevant information
resources=$(aws cloudformation describe-stack-resources --stack-name "$stack_name" \
  --query 'StackResources[].[LogicalResourceId, PhysicalResourceId, ResourceType]' \
  --output json)

# Build the Pulumi import JSON structure
pulumi_import_json="{
  \"resources\": [
"

# Process each resource
echo "$resources" | jq -c --argjson type_mapping "$type_mapping" '.[] | 
{
  "type": ($type_mapping[.[2]] // "unknown"),
  "name": .[0],
  "id": .[1]
}
' | while IFS= read -r resource; do
    pulumi_import_json="${pulumi_import_json}${resource},"
done

echo "pulumi_import_json is $pulumi_import_json"

# Remove the trailing comma and close the JSON structure
pulumi_import_json="${pulumi_import_json::-1}]}"

# Output the JSON file
echo "$pulumi_import_json" > pulumi_import.json

echo "Pulumi import file 'pulumi_import.json' has been created!"
