# pulumi-scripts
Pulumi utility scripts
## convert-cf-to-pulumi-bulk.sh
### Prerequisites:
- an AWS account with sufficient privilege,
- AWS CLI latest version installed,
- Pulumi cli installed.
- `jq` installed

### Limitations:

Currently only a small set of Pulumi type mappings are included.  See the script for details.

### Usage:

./convert-cf-to-pulumi-bulk.sh

### Result:

pulumi_import.json

### Importing:

pulumi import -f pulumi_import.json
