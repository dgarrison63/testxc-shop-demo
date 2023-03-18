variable "api_url" {
  default = "https://<tenant>.console.ves.volterra.io/api"
}

variable "api_p12_file" {
  default = "./creds/<p12 filename>"
}

variable "base" {
  default = "demo-shop"
}

variable "app_fqdn" {
  default = "<application fqdn>"
}

variable "spoke_site_selector" {
  default = ["ves.io/siteName in (ves-io-ny8-nyc, ves-io-wes-sea)"]
}

variable "hub_site_selector" {
  default = ["ves.io/siteName in (ves-io-dc12-ash)"]
}

variable "utility_site_selector" {
  default = ["ves.io/siteName in (ves-io-dc12-ash)"]
}

variable "cred_expiry_days" {
  default = 89
}

variable "registry_server" {
  default = "ghcr.io/dgarrisonf5"
}

variable "registry_config_json" {
  default     = "b64 encoded json"
  description = "registry config data string in type kubernetes.io/dockerconfigjson"
}

variable "bot_defense_region" {
  default = "US"
}

variable "tenant_js_ref" {
  default = "volt-f5_sales_demo_rljyvvmw-49301db1"
}