
module "private_dns_resolvers_dns_forwarding_ruleset" {
  source   = "./modules/networking/private_dns_resolvers_dns_forwarding_ruleset"
  for_each = local.networking.private_dns_resolver_dns_forwarding_rulesets

  global_settings = local.global_settings
  client_config   = local.client_config
  settings        = each.value
  resource_group     = local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].name
  inherit_tags    = local.global_settings.inherit_tags
  location        = try(local.global_settings.regions[each.value.region], each.value.region)

  outbound_endpoint_ids = compact(
    [
      for key, value in each.value.dns_resolver_outbound_endpoints :
      can(value.id) ? try(value.id, null) : try(local.combined_objects_private_dns_resolver_outbound_endpoints[try(value.lz_key, local.client_config.landingzone_key)][value.key].id, "")
    ]
  )

}

output "private_dns_resolvers_dns_forwarding_ruleset" {
  value = module.private_dns_resolvers_dns_forwarding_ruleset
}
