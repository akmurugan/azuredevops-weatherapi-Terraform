provider "azurerm" {
    version = "2.20.0"
    features {}
}

resource "azurerm_resource_group" "tf_test" {
  name = "tfmainrg"
  location = "eastus"
}

terraform {
    backend "azurerm" {
        resource_group_name  = "tf_stgacc_rg"
        storage_account_name = "tfstorageacc23"
        container_name       = "tfstate"
        key                  = "terraform.tfstate"
    }
}

variable "imagebuild" {
  type        = string
  description = "Latest Image Build"
}


resource "azurerm_container_group" "tfcg_test" {
  name                      = "weatherapi"
  location                  = azurerm_resource_group.tf_test.location
  resource_group_name       = azurerm_resource_group.tf_test.name
  ip_address_type           = "public"
  dns_name_label            = "akmurugandev"
  os_type                   = "Linux"

  container {
      name            = "weatherapi"
      image           = "ak11224864/weatherapi:${var.imagebuild}"
        cpu             = "1"
        memory          = "1"

        ports {
            port        = 80
            protocol    = "TCP"
        }
  }
}
