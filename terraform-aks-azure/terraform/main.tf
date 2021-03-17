provider "azurerm" {
  version = "~>2.0"
  features {}
}

provider "azuread" {
  version = "0.9.0"
}
terraform {
  required_providers {
    kubernetes = {
        source        = "hashicorp/kubernetes"
        version       = "1.13.2"
      }

    kubectl = {
      source          = "gavinbunney/kubectl"
      version         = "1.9.1"
    }
  }
}
resource "azurerm_resource_group" "mantis-tf-rg" {
  name     = "mantis-tf-rg"
  location = var.location
}

resource "azurerm_virtual_network" "mantis-tf-network" {
  name                = "mantis-tf-network"
  location            = azurerm_resource_group.mantis-tf-rg.location
  resource_group_name = azurerm_resource_group.mantis-tf-rg.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "mantis-tf-subnet" {
  name                 = "mantis-tf-subnet"
  virtual_network_name = azurerm_virtual_network.mantis-tf-network.name
  resource_group_name  = azurerm_resource_group.mantis-tf-rg.name
  address_prefixes     = ["10.1.0.0/22"]
}

resource "azurerm_kubernetes_cluster" "mantis-tf-aks" {
  name                = "mantis-tf-aks"
  location            = azurerm_resource_group.mantis-tf-rg.location
  resource_group_name = azurerm_resource_group.mantis-tf-rg.name
  dns_prefix          = "mantis-tf-aks"

  default_node_pool {
    name                = "default"
    node_count          = 2
    vm_size             = "Standard_D2_v2"
    type                = "VirtualMachineScaleSets"
    availability_zones  = ["1", "2"]
    enable_auto_scaling = true
    min_count           = 2
    max_count           = 4

    # Required for advanced networking
    vnet_subnet_id = azurerm_subnet.mantis-tf-subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  # role_based_access_control {
  #   azure_active_directory {
  #     client_app_id     = var.client_app_id
  #     server_app_id     = var.server_app_id
  #     server_app_secret = var.server_app_secret
  #     tenant_id         = var.tenant_id
  #   }
  #   enabled = true
  # }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
    network_policy    = "calico"
  }

  tags = {
    Environment = "Development"
  }
}

