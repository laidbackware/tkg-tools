terraform {
  required_providers {
    nsxt = {
      source = "vmware/nsxt"
      version = "3.2.4"
    }
    avi = {
      source = "vmware/avi"
      version = "21.1.1"
    }
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.0.2"
    }
  }
}

provider "nsxt" {
  # Configuration options
}

provider "avi" {
  # Configuration options
}