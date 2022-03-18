terraform {
  required_version = ">= 0.15"
  required_providers {
    volterra = {
      source = "volterraedge/volterra"
      version = "0.11.3"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.8.0"
    }
  }
}

provider "volterra" {
  api_p12_file = "${path.root}/creds/${var.api_p12_file}"
  url          = var.api_url
}

provider "kubernetes" {
  alias                  = "app"
  host                   = module.f5xc.app_kubecfg_host
  cluster_ca_certificate = base64decode(module.f5xc.app_kubecfg_cluster_ca)
  client_certificate     = base64decode(module.f5xc.app_kubecfg_client_cert)
  client_key             = base64decode(module.f5xc.app_kubecfg_client_key)
}

provider "kubernetes" {
  alias                  = "utility"
  host                   = module.f5xc.utility_kubecfg_host
  cluster_ca_certificate = base64decode(module.f5xc.utility_kubecfg_cluster_ca)
  client_certificate     = base64decode(module.f5xc.utility_kubecfg_client_cert)
  client_key             = base64decode(module.f5xc.utility_kubecfg_client_key)
}

module "f5xc" {
  source = "./module/f5xc"

  api_url                 = var.api_url
  api_p12_file            = "${path.module}/../../creds/${var.api_p12_file}"
  base                    = var.base
  app_fqdn                = var.app_fqdn
  spoke_site_selector     = var.spoke_site_selector
  hub_site_selector       = var.hub_site_selector
  utility_site_selector   = var.utility_site_selector
  cred_expiry_days        = var.cred_expiry_days
  bot_defense_region      = var.bot_defense_region
}

module "vk8s-app" {
  source = "./module/vk8s-app"
  providers = {
    kubernetes = kubernetes.app 
   }

  namespace     = module.f5xc.app_namespace
  spoke_vsite   = module.f5xc.spoke_vsite
  hub_vsite     = module.f5xc.hub_vsite

  reg_server            = var.registry_server
  registry_config_json  = var.registry_config_json
  tenant_js_ref         = var.tenant_js_ref
}

module "vk8s-utility" {
  source = "./module/vk8s-utility"
  providers = {
    kubernetes = kubernetes.utility 
   }

  namespace       = module.f5xc.utility_namespace
  vsite           = module.f5xc.utility_vsite
  app_namespace   = module.f5xc.app_namespace
  target_url      = module.f5xc.app_url
  app_kubecfg     = module.f5xc.app_kubecfg

  reg_server            = var.registry_server
  registry_config_json  = var.registry_config_json
}

