output "storage_account_id" {
  value       = azurerm_storage_account.sta.id
  description = "Resource ID of the Storage Account (ADLS Gen2)."
}

output "storage_account_name" {
  value       = azurerm_storage_account.sta.name
  description = "Name of the Storage Account (ADLS Gen2)."
}

output "filesystem_ids" {
  value       = { for k, v in azurerm_storage_data_lake_gen2_filesystem.datalake2fs : k => v.id }
  description = "Map of filesystem names to their resource IDs."
}

output "filesystem_names" {
  value       = keys(azurerm_storage_data_lake_gen2_filesystem.datalake2fs)
  description = "List of filesystem names created in the Storage Account."
}