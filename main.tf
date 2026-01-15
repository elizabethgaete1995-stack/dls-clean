terraform {
  required_version = ">= 1.4.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.110.0"
    }
  }
}

provider "azurerm" {
  subscription_id            = var.subscription_id
  tenant_id                  = var.tenant_id
  skip_provider_registration = true

  features {}
}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rsg" {
  name = var.rsg_name
}

locals {
  # Base tags (curated). You can merge extra tags via var.custom_tags / var.optional_tags.
  base_tags = {
    entity        = var.entity
    environment   = var.environment
    app_name      = var.app_name
    cost_center   = var.cost_center
    tracking_code = var.tracking_code
    hidden-deploy = "curated"
  }

  tags = merge(
    local.base_tags,
    var.custom_tags,
    var.optional_tags,
  )
}

########################################################################
// Storage Account (ADLS Gen2)
########################################################################
resource "azurerm_storage_account" "sta" {
  # NOTE: Storage Account names must be 3-24 chars, lower-case letters & numbers only.
  name = lower(join("", [var.app_name, var.location, var.entity, var.environment, var.sequence_number]))

  resource_group_name = data.azurerm_resource_group.rsg.name
  location            = data.azurerm_resource_group.rsg.location

  account_kind             = "StorageV2"
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  access_tier              = var.access_tier

  enable_https_traffic_only        = true
  min_tls_version                  = "TLS1_2"
  shared_access_key_enabled        = true
  allow_nested_items_to_be_public  = false
  cross_tenant_replication_enabled = var.cross_tenant_replication_enabled

  # ADLS Gen2
  is_hns_enabled = var.is_hns_enabled

  public_network_access_enabled = var.public_network_access_enabled

  identity {
    type = "SystemAssigned"
  }

  blob_properties {
    delete_retention_policy {
      days = var.delete_retention_days
    }

    container_delete_retention_policy {
      days = var.delete_retention_days_container
    }
  }

  # Network rules are optional. If you want a fully open account (not recommended), set
  # public_network_access_enabled=true and default_action="Allow".
  network_rules {
    default_action             = var.network_default_action
    virtual_network_subnet_ids = var.virtual_network_subnet_ids
    bypass                     = var.bypass
    ip_rules                   = var.ip_rules

    dynamic "private_link_access" {
      for_each = toset(var.endpoint_resource_ids)
      content {
        endpoint_resource_id = private_link_access.key
        endpoint_tenant_id   = data.azurerm_client_config.current.tenant_id
      }
    }
  }

  tags = local.tags
}

########################################################################
// Filesystems (containers) in ADLS Gen2
########################################################################
resource "azurerm_storage_data_lake_gen2_filesystem" "datalake2fs" {
  # Create one filesystem per name provided.
  for_each = toset(var.datalake_filesystem_name)

  name               = each.value
  storage_account_id = azurerm_storage_account.sta.id
}
