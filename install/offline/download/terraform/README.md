# Instructions

## Terraform
If terraform is not already installed
```
wget https://releases.hashicorp.com/terraform/1.0.6/terraform_1.0.6_linux_amd64.zip
unzip tf.zip
mv terraform ~/.local/bin
```
At this point the `terraform` command should work. If not log out and log in again to ensure that .local/bin is in your path.

## Fetching the providers
Run `terraform init` in this directory. Afterwards the .terraform/providers/registry.terraform.io directory will contain the provider binaries
```
tar -czvf terraform-providers.tar.gz .terraform
# copy to transfer directory e.g
cp terraform-providers.tar.gz $HOME/Downloads/transfer
```