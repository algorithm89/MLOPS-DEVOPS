# Azure Terraform Home Lab

This repo contains an Azure home lab split into infrastructure and application code. Terraform manages the Azure network foundation, and the frontend app is a small Dockerized static site intended to run on the private app VM.

## Goal

Build a small Azure environment that demonstrates:

- Azure Resource Groups
- Virtual networks and subnets
- VNet peering
- Network Security Group rules
- Linux virtual machines
- Private VM-to-VM connectivity
- Docker-based frontend deployment
- Basic connectivity testing with SSH, ping, and curl

## Target Architecture

The planned lab has two Azure virtual networks:

- `vnet-mgmt-dev`: management network with a public jumpbox VM
- `vnet-app-dev`: private app network with an app VM running Docker

```text

+--------------------------------------------------------------------------------------+
|                              AZURE RESOURCE GROUP                                    |
|                              rg-terraform-lab-dev                                    |
|                                                                                      |
|   +--------------------------------------+      VNet Peering      +--------------------------------------+
|   |          VIRTUAL NETWORK 1           | <-------------------> |          VIRTUAL NETWORK 2           |
|   |          vnet-mgmt-dev               |                       |          vnet-app-dev                |
|   |          10.10.0.0/16                |                       |          10.20.0.0/16                |
|   |                                      |                       |                                      |
|   |   +------------------------------+   |                       |   +------------------------------+   |
|   |   |        subnet-mgmt           |   |                       |   |         subnet-app           |   |
|   |   |        10.10.1.0/24          |   |                       |   |         10.20.1.0/24         |   |
|   |   |                              |   |                       |   |                              |   |
|   |   |   +----------------------+   |   |                       |   |   +----------------------+   |   |
|   |   |   |      Linux VM 1      |   |   |                       |   |   |      Linux VM 2      |   |   |
|   |   |   |      Jumpbox         |   |   |                       |   |   |      App Server      |   |   |
|   |   |   |                      |   |   |                       |   |   |                      |   |   |
|   |   |   | Private IP:          |   |   |     ping / ssh /      |   |   | Private IP:          |   |   |
|   |   |   | 10.10.1.10           |   |   |     curl test         |   |   | 10.20.1.10           |   |   |
|   |   |   |                      |   |   | --------------------> |   |   |                      |   |   |
|   |   |   | Public IP: Yes       |   |   |                       |   |   | Public IP: Yes       |   |   |
|   |   |   | SSH entry point      |   |   |                       |   |   | Web testing only     |   |   |
|   |   |   +----------------------+   |   |                       |   |   +----------------------+   |   |
|   |   |                              |   |                       |   |                              |   |
|   |   |   +----------------------+   |   |                       |   |   +----------------------+   |   |
|   |   |   |        NSG 1         |   |   |                       |   |   |        Docker        |   |   |
|   |   |   | nsg-mgmt-dev         |   |   |                       |   |   | Frontend Container   |   |   |
|   |   |   |                      |   |   |                       |   |   | nginx/sample app     |   |   |
|   |   |   | Allow SSH 22         |   |   |                       |   |   | Port: 8080           |   |   |
|   |   |   | from my public IP    |   |   |                       |   |   +----------------------+   |   |
|   |   |   +----------------------+   |   |                       |   |                              |   |
|   |   +------------------------------+   |                       |   |   +----------------------+   |   |
|   |                                      |                       |   |   |        NSG 2         |   |   |
|   |                                      |                       |   |   | nsg-app-dev          |   |   |
|   |                                      |                       |   |   |                      |   |   |
|   |                                      |                       |   |   | Allow from VNet 1:   |   |   |
|   |                                      |                       |   |   | - SSH 22             |   |   |
|   |                                      |                       |   |   | - ICMP ping          |   |   |
|   |                                      |                       |   |   | - HTTP 8080          |   |   |
|   |                                      |                       |   |   | Allow from internet: |   |   |
|   |                                      |                       |   |   | - HTTP 8080          |   |   |
|   |                                      |                       |   |   +----------------------+   |   |
|   |                                      |                       |   +------------------------------+   |
|   +--------------------------------------+                       +--------------------------------------+
|                                                                                      |
+--------------------------------------------------------------------------------------+
```

## Developer Workflow

```text
+-------------------+        +-------------------+        +----------------------+
| Developer Laptop  | -----> | GitHub Repository | -----> | Terraform Apply      |
| VS Code / Codex   |        | Terraform Code    |        | Provision Azure      |
+-------------------+        +-------------------+        +----------------------+
```

Optional frontend workflow:

```text
+-------------------+        +-------------------+        +----------------------+
| Dockerfile        | -----> | Build Image       | -----> | Deploy frontend      |
| index.html        |        | nginx frontend    |        | to VM2 on port 8080  |
+-------------------+        +-------------------+        +----------------------+
```

## Repo Layout

```text
.
|-- apps/
|   `-- frontend/
|       |-- Dockerfile
|       |-- README.md
|       `-- index.html
|-- infra/
|   |-- network/
|   |   |-- providers.tf
|   |   |-- variables.tf
|   |   |-- locals.tf
|   |   |-- network.tf
|   |   |-- outputs.tf
|   |   |-- terraform.tfvars.example
|   |   `-- README.md
|   `-- compute/
|       |-- providers.tf
|       |-- variables.tf
|       |-- locals.tf
|       |-- data.tf
|       |-- compute.tf
|       |-- cloud-init-app.yaml
|       |-- outputs.tf
|       |-- terraform.tfvars.example
|       `-- README.md
|-- Map.png
`-- README.md
```

## Resources

| Resource | Purpose |
| --- | --- |
| Resource group | Container for all lab resources |
| Management VNet | Public entry network for the jumpbox |
| App VNet | Network for the application server |
| VNet peering | Allows private traffic between the two VNets |
| Jumpbox VM | SSH entry point from your local machine |
| App VM | Runs the Docker frontend, published on port 8080 |
| Public IPs | One on the jumpbox for SSH, one on the app VM for web testing |
| Management NSG | Allows SSH only from a trusted public IP |
| App NSG | Allows SSH and ICMP from the management network, HTTP 8080 from the internet |

## Terraform Stacks

The lab is split into two stacks. Apply `network` first — `compute` reads its
state file for the resource group, region, and subnet IDs.

| File | Purpose |
| --- | --- |
| `infra/network/providers.tf` | Terraform and AzureRM provider requirements |
| `infra/network/variables.tf` | Project, region, CIDR, and access-control inputs |
| `infra/network/locals.tf` | Shared resource naming values |
| `infra/network/network.tf` | Resource group, VNets, subnets, NSGs, and VNet peering |
| `infra/network/outputs.tf` | Useful IDs returned after apply |
| `infra/network/terraform.tfvars.example` | Example local variable values |
| `infra/compute/data.tf` | Reads the network stack's outputs from its state file |
| `infra/compute/compute.tf` | Public IPs, NICs, and the two Linux VMs |
| `infra/compute/cloud-init-app.yaml` | Installs Docker and starts the frontend container |
| `infra/compute/outputs.tf` | App URL, VM IPs, and ready-to-paste SSH commands |

## Frontend App

The frontend app lives in `apps/frontend/`. It is a static `index.html` served by nginx.

Build and run it locally:

```powershell
cd apps/frontend
docker build -t azure-terraform-lab-frontend .
docker run --rm -p 8080:80 azure-terraform-lab-frontend
```

Open:

```text
http://localhost:8080
```

## Prerequisites

- Azure subscription
- Azure CLI installed
- Terraform installed
- Git installed
- SSH key pair for VM login

## Azure Access Needed

For this network-only stage, your Azure account needs permission to create and manage:

- Resource groups
- Virtual networks
- Subnets
- Network security groups
- Subnet-to-NSG associations
- VNet peering

The simplest option for a lab is `Contributor` on the target subscription or target resource group.

A tighter option is:

- `Contributor` at the subscription level only long enough to create the resource group, then
- `Network Contributor` on the lab resource group for day-to-day network work.

If someone else creates the resource group for you, ask them for `Network Contributor` on `rg-terraform-lab-dev`.

Login to Azure before running Terraform:

```powershell
az login
az account show
```

Do not put your Azure portal username, password, or client secret in this repo. For local work, Terraform connects to Azure through your Azure CLI login session from `az login`.

Create a local `terraform.tfvars` file from the example and set your real values:

```powershell
cd infra/network
Copy-Item terraform.tfvars.example terraform.tfvars
```

At minimum, update:

```hcl
# This is an Azure identifier, not a password.
subscription_id       = "<your-azure-subscription-id>"

# This locks future SSH access down to your current public IP.
allowed_ssh_source_ip = "<your-public-ip>/32"
```

## Terraform Workflow

Build the network first:

```powershell
cd infra/network
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

Then the VMs:

```powershell
cd ../compute
Copy-Item terraform.tfvars.example terraform.tfvars
terraform init
terraform apply
```

Destroy in reverse order when you are done testing, to control cost:

```powershell
cd infra/compute
terraform destroy
cd ../network
terraform destroy
```

## Testing Flow

Open the frontend in a browser using the app VM's public IP:

```powershell
cd infra/compute
terraform output app_url
```

SSH from your local machine to the jumpbox public IP:

```powershell
ssh azureuser@<vm1-public-ip>
```

From VM1, test private connectivity to VM2:

```bash
ping 10.20.1.10
ssh azureuser@10.20.1.10
curl http://10.20.1.10:8080
```

## Expected Result

- VM1 is reachable from the internet by SSH only from your trusted public IP.
- VM2 serves the frontend publicly on port `8080`.
- VM2 accepts SSH only from the management subnet, so admin access goes through VM1.
- VM1 can reach VM2 through VNet peering.
- VM1 can ping VM2.
- VM1 can SSH to VM2.
- VM1 can curl the Docker frontend on VM2 port `8080`.

## Public Exposure Note

VM2 carries a public IP so the site can be browsed directly while testing. This
is a deliberate lab convenience, not the hardened pattern — it trades away the
"app tier is unreachable from the internet" property the two-VNet layout is
built to demonstrate. To go back to the private design, set
`expose_app_publicly = false` in the network stack and
`app_public_ip_enabled = false` in the compute stack, then reach the site
through an SSH tunnel:

```powershell
ssh -L 8080:10.20.1.10:8080 azureuser@<vm1-public-ip>
```

## Status

Network and compute Terraform stacks are in place and validate successfully.
