variable "control_plane_id" {
  type = string
  default = "YOUR_CONTROL_PLANE_ID"
}

resource "konnect_gateway_service" "rami_apiops_demo" {
  name = "rami-apiops-demo"
  connect_timeout = 60000
  host = "httpbin.org"
  path = "/"
  port = 443
  protocol = "https"
  read_timeout = 60000
  retries = 6
  tags = ["owner=rami", "created_by:terraform", "environment:dev"]
  write_timeout = 60000

  control_plane_id = local.control_plane_id
}

resource "konnect_gateway_route" "rami_apiops_demo_httpbin_anything" {
  name = "rami-apiops-demo_httpbin-anything"
  methods = ["GET"]
  paths = ["~/anything$"]
  regex_priority = 200
  strip_path = false
  tags = ["owner=rami", "created_by:terraform", "environment:dev"]

  service = {
    id = konnect_gateway_service.rami_apiops_demo.id
  }

  control_plane_id = local.control_plane_id
}

resource "konnect_gateway_route" "rami_apiops_demo_httpbin_post" {
  name = "rami-apiops-demo_httpbin-post"
  methods = ["POST"]
  paths = ["~/post$"]
  regex_priority = 200
  strip_path = false
  tags = ["owner=rami", "created_by:terraform", "environment:dev"]

  service = {
    id = konnect_gateway_service.rami_apiops_demo.id
  }

  control_plane_id = local.control_plane_id
}

resource "konnect_gateway_plugin_rate_limiting" "rami_apiops_demo_rate_limiting" {
  enabled = true
  config = {
    hide_client_headers = false
    hour = 1000
    minute = 90
    policy = "local"
  }
  tags = ["owner=rami", "created_by:terraform", "environment:dev"]

  service = {
    id = konnect_gateway_service.rami_apiops_demo.id
  }

  control_plane_id = local.control_plane_id
}

