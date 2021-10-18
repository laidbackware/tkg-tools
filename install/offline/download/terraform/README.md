# Instructions

## Terraform
If terraform is not already installed
```
wget -P ${DOWNLOAD_DIR:?}/ https://releases.hashicorp.com/terraform/1.0.6/terraform_1.0.6_linux_amd64.zip
unzip ${DOWNLOAD_DIR:?}/tf.zip
mv ${DOWNLOAD_DIR:?}/terraform ~/.local/bin
```
At this point the `terraform` command should work. If not log out and log in again to ensure that .local/bin is in your path.

## Fetching the providers
Run `terraform init` in this directory. Afterwards the .terraform/providers/registry.terraform.io directory will contain the provider binaries
```
tar -czvf ${DOWNLOAD_DIR:?}/terraform-providers.tar.gz .terraform
```