/* Copyright (C) Hashicorp, Inc - All Rights Reserved */
/* Unauthorized copying of this file, via any medium is strictly prohibited */
/* Proprietary and confidential */
/* Written by Adeel Ahmad adeel@hashicorp.com, February 2023 */

locals {
  domain = format("%s.com", var.application)
}

resource "aws_route53_zone" "default" {
  name = format("%s.", local.domain)
}

resource "vault_mount" "default" {
  path        = "pki"
  type        = "pki"
  description = "Vault Secrets mount for PKI"
}

resource "vault_pki_secret_backend_role" "default" {
  backend         = vault_mount.default.path
  name            = var.application
  key_type        = "rsa"
  ttl             = 3600
  allow_ip_sans   = true
  key_bits        = 4096
  allowed_domains = tolist(local.domain)
}

data "vault_policy_document" "default" {
  rule {
    capabilities = ["read"]
    description  = "Allow issuing certs"

    path = format(
      "%s/issue/%s",
      vault_mount.pki.path,
      replace(local.domain, ".", "-dot-")
    )
  }
}

resource "vault_policy" "default" {
  name   = var.application
  policy = data.vault_policy_document.default.hcl
}
