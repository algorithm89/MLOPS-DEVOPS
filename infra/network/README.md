# Network Terraform Stack

This Terraform stack creates the Azure networking foundation for the lab:

- Resource group
- Management virtual network
- App virtual network
- Management subnet
- App subnet
- Network security groups
- Subnet-to-NSG associations
- Bidirectional VNet peering

## Usage

Create a local variables file:

```powershell
Copy-Item terraform.tfvars.example terraform.tfvars
```

Update `terraform.tfvars` with your Azure subscription ID and trusted SSH source IP.

Do not put Azure portal passwords, client secrets, or other credentials in Terraform files. For local development, authenticate with Azure CLI:

```powershell
az login
az account show
```

Terraform will use that logged-in Azure CLI session.

For later automation, set credentials as environment variables or GitHub Actions secrets instead of saving them in a `.tfvars` file:

```powershell
$env:ARM_CLIENT_ID       = "00000000-0000-0000-0000-000000000000"
$env:ARM_CLIENT_SECRET   = "your-service-principal-client-secret"
$env:ARM_SUBSCRIPTION_ID = "00000000-0000-0000-0000-000000000000"
$env:ARM_TENANT_ID       = "00000000-0000-0000-0000-000000000000"
```

Initialize and validate:

```powershell
terraform init
terraform fmt
terraform validate
```

Preview changes:

```powershell
terraform plan
```
