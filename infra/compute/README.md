# Compute Terraform Stack

This stack creates the two lab VMs on top of the networking built by `infra/network`:

- Jumpbox VM in `subnet-mgmt` with a public IP (SSH entry point)
- App VM in `subnet-app` with a public IP (browsable frontend on port 8080)
- Network interfaces with static private IPs
- Docker installed on the app VM via cloud-init

## Prerequisite

Apply the network stack first. This stack reads `../network/terraform.tfstate`
for the resource group name, region, and subnet IDs, so those outputs must exist.

## SSH key

Both VMs are key-only; password login is disabled. If you do not have a key yet:

```powershell
ssh-keygen -t ed25519 -C "terraform-lab"
```

Then point `ssh_public_key_path` at the `.pub` file.

## Usage

```powershell
Copy-Item terraform.tfvars.example terraform.tfvars
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

After apply, Terraform prints the URL and SSH commands:

```powershell
terraform output app_url
terraform output ssh_jumpbox_command
terraform output ssh_app_command
```

## Deploying the real frontend

Cloud-init starts a placeholder nginx container on port 8080 so the public
endpoint can be verified immediately. To replace it with the lab frontend,
copy the app to the VM through the jumpbox and rebuild:

```powershell
$jump = terraform output -raw jumpbox_public_ip
$app  = terraform output -raw app_private_ip

scp -o ProxyJump=azureuser@$jump -r ../../apps/frontend azureuser@${app}:~/
ssh -J azureuser@$jump azureuser@$app
```

Then on the app VM:

```bash
cd ~/frontend
docker build -t frontend .
docker rm -f frontend
docker run -d --name frontend --restart unless-stopped -p 8080:80 frontend
```

The container listens on port 80 internally; `-p 8080:80` publishes it on the
host port the NSG allows.

## Public exposure

`app_public_ip_enabled = true` attaches a public IP to the app VM, and the
network stack's `expose_app_publicly = true` opens TCP 8080 inbound from the
internet. Set both to `false` to return to the private design, where the app
VM is reachable only from the jumpbox via an SSH tunnel:

```powershell
ssh -L 8080:10.20.1.10:8080 azureuser@<jumpbox-public-ip>
```

SSH to the app VM is never open to the internet in either mode — it is
restricted to the management subnet, so use the jumpbox hop.

## Cost

Two `Standard_B1s` VMs plus two static public IPs. Run `terraform destroy` in
this stack before the network stack when you are done testing.
