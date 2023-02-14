output "policy_name" {
  value       = vault_policy.default.name
  description = "Vault Policy name to provide as input for auth modules"
}
