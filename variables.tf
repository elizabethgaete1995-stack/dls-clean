############################################
# Provider / basics
############################################
variable "subscription_id" {
  description = "Azure subscription id."
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant id."
  type        = string
}

variable "rsg_name" {
  description = "(Required) Resource group name where the Storage Account will be deployed."
  type        = string
}

variable "location" {
  description = "(Required) Azure region short name used to build the Storage Account name (e.g. chilecentral)."
  type        = string
}

############################################
# Naming / tags
############################################
variable "entity" {
  description = "(Required) Entity/product tag (also used in name)."
  type        = string
}

variable "environment" {
  description = "(Required) Environment tag (e.g. dev/qa/prod)."
  type        = string
}

variable "app_name" {
  description = "(Required) Application tag (also used in name)."
  type        = string
}

variable "sequence_number" {
  description = "(Required) Sequence number used in name (e.g. 001)."
  type        = string
}

variable "cost_center" {
  description = "(Optional) Cost center tag."
  type        = string
  default     = null
}

variable "tracking_code" {
  description = "(Optional) Tracking code tag."
  type        = string
  default     = null
}

variable "inherit" {
  description = "(Optional) Present for compatibility with existing tfvars. Not used by this module."
  type        = bool
  default     = true
}

variable "custom_tags" {
  description = "(Optional) Custom tags to merge into the Storage Account."
  type        = map(string)
  default     = {}
}

variable "optional_tags" {
  description = "(Optional) Extra tags to merge into the Storage Account."
  type        = map(string)
  default     = {}
}

############################################
# Storage Account configuration
############################################
variable "account_tier" {
  description = "Storage account tier (Standard or Premium)."
  type        = string
}

variable "account_replication_type" {
  description = "Storage account replication type (LRS, GRS, RAGRS, ZRS, etc.)."
  type        = string
}

variable "access_tier" {
  description = "Storage account access tier (Hot or Cool)."
  type        = string
}

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled."
  type        = bool
  default     = true
}

variable "cross_tenant_replication_enabled" {
  description = "Should cross-tenant replication be enabled?"
  type        = bool
  default     = false
}

variable "is_hns_enabled" {
  description = "Enable hierarchical namespace (ADLS Gen2)."
  type        = bool
  default     = true
}

variable "delete_retention_days" {
  description = "Blob delete retention (1-365)."
  type        = number
  default     = 7
}

variable "delete_retention_days_container" {
  description = "Container delete retention (1-365)."
  type        = number
  default     = 7
}

############################################
# Network rules
############################################
variable "network_default_action" {
  description = "Default action for network rules: Allow or Deny."
  type        = string
  default     = "Deny"
}

variable "virtual_network_subnet_ids" {
  description = "List of subnet IDs allowed to access the account."
  type        = list(string)
  default     = []
}

variable "bypass" {
  description = "Traffic bypass options (Logging, Metrics, AzureServices, None)."
  type        = list(string)
  default     = ["None"]
}

variable "ip_rules" {
  description = "List of public IPs/CIDRs allowed to access the account."
  type        = list(string)
  default     = []
}

variable "endpoint_resource_ids" {
  description = "List of Private Endpoint resource IDs that are allowed via private_link_access."
  type        = list(string)
  default     = []
}

############################################
# ADLS Gen2 filesystems
############################################
variable "datalake_filesystem_name" {
  description = "List of ADLS Gen2 filesystem (container) names to create."
  type        = list(string)
  default     = []
}

############################################
# Variables kept only to avoid tfvars errors
# (These are not used when deploying only Storage Account + ADLS Gen2.)
############################################
variable "akv_name" {
  description = "(Unused) Key Vault name."
  type        = string
  default     = null
}

variable "akv_rsg_name" {
  description = "(Unused) Key Vault resource group name."
  type        = string
  default     = null
}

variable "key_rotation" {
  description = "(Unused) Key rotation flag."
  type        = bool
  default     = false
}

variable "key_name" {
  description = "(Unused) Key name."
  type        = string
  default     = null
}

variable "key_exist" {
  description = "(Unused) Whether a CMK already exists."
  type        = bool
  default     = false
}

variable "key_custom_enabled" {
  description = "(Unused) Enable customer-managed key encryption."
  type        = bool
  default     = false
}

variable "lwk_rsg_name" {
  description = "(Unused) Log Analytics Workspace resource group."
  type        = string
  default     = null
}

variable "lwk_name" {
  description = "(Unused) Log Analytics Workspace name."
  type        = string
  default     = null
}

variable "analytics_diagnostic_monitor_name" {
  description = "(Unused) Name for diagnostics setting."
  type        = string
  default     = null
}

variable "analytics_diagnostic_monitor_enabled" {
  description = "(Unused) Enable diagnostics setting."
  type        = bool
  default     = false
}

variable "analytics_diagnostic_monitor_sta_id" {
  description = "(Unused) Storage account id for diagnostics."
  type        = string
  default     = null
}
