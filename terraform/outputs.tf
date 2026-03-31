output "control_plane_id" {
  description = "Kong Konnect Control Plane ID"
  value       = local.control_plane_id
}

output "portal_id" {
  description = "Kong Konnect Developer Portal ID"
  value       = local.portal_id
}

output "control_plane_info" {
  description = "Control Plane information"
  value = {
    id   = local.control_plane.id
    name = local.control_plane.name
    description = try(local.control_plane.description, "")
  }
}

output "portal_info" {
  description = "Developer Portal information"
  value = {
    id   = local.portal.id
    name = local.portal.name
  }
}

output "apis" {
  description = "Published APIs information"
  value = {
    for key, api in konnect_api.apis : key => {
      id          = api.id
      name        = api.name
      slug        = api.slug
      version     = api.version
      portal_url  = "Check your Kong Developer Portal for '${api.name}'"
    }
  }
}

output "summary" {
  description = "Deployment Summary"
  value = {
    control_plane = {
      id   = local.control_plane_id
      name = var.control_plane_name
    }
    portal = {
      id   = local.portal_id
      name = var.portal_name
    }
    deployment = {
      apis_published   = length(konnect_api.apis)
      pages_created    = length(konnect_portal_page.pages)
    }
    next_steps = [
      "1. Visit your Developer Portal to see published APIs",
      "2. Test the APIs using the provided endpoints",
      "3. Generate API keys for authentication",
      "4. Review the gateway analytics in Kong Manager"
    ]
  }
}
