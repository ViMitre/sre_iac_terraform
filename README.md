# Terraform

## What is Terraform
Terraform is an Infrastructure As Code tool used to automate orchestration tasks.
## Why Terraform
## Setting up Terraform
### Securing AWS keys for Terraform
- Create environment variable to secure AWS keys
- Restart the terminal
- Create main.tf file
- Add the code to initialize Terraform with AWS
```
provider "aws" {
    region = "eu-west-1"
}
```
- Run this with `terraform init`
## Create resources on AWS
### Start an EC2 instance using the app AMI
- AMI id
- `sre_key.pem` file
- Public IP
- Type of instance `t2.micro`
## Commands
```
Main commands:
  init          Prepare your working directory for other commands
  validate      Check whether the configuration is valid
  plan          Show changes required by the current configuration
  apply         Create or update infrastructure
  destroy       Destroy previously-created infrastructure

All other commands:
  console       Try Terraform expressions at an interactive command prompt 
  fmt           Reformat your configuration in the standard style
  force-unlock  Release a stuck lock on the current workspace
  get           Install or upgrade remote Terraform modules
  graph         Generate a Graphviz graph of the steps in an operation
  import        Associate existing infrastructure with a Terraform resource
  login         Obtain and save credentials for a remote host
  logout        Remove locally-stored credentials for a remote host
  output        Show output values from your root module
  providers     Show the providers required for this configuration
  refresh       Update the state to match remote systems
  show          Show the current state or a saved plan
  state         Advanced state management
  taint         Mark a resource instance as not fully functional
  test          Experimental support for module integration testing
  untaint       Remove the 'tainted' state from a resource instance
  version       Show the current Terraform version
  workspace     Workspace management
```

Create a `variable.tf` file and store variables that will be used later. Example:
```
variable "region" {
    default = "eu-west-1"
}
```
You can refer to a variable in this format: `var.region`

## Steps 
- Create VPC 
- Subnets
- Security groups
- Internet gateway
- Route table association
- Instances

See `main.tf` file for details

