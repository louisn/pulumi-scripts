# pulumi-scripts

A collection of utility scripts for working with Pulumi.

## convert-cf-to-pulumi-bulk.sh

This script helps you convert AWS CloudFormation resources into Pulumi code in bulk.

### Prerequisites:
- an AWS account with sufficient privilege,
- AWS CLI latest version installed,
- Pulumi cli installed.
- `jq` installed

### Limitations:

Currently supports a limited set of AWS resource to Pulumi type mappings. 
Please refer to the script for the currently supported mappings.

### Usage:

    ./convert-cf-to-pulumi-bulk.sh

### Result:

    pulumi_import.json

### Importing:

    pulumi import -f pulumi_import.json
