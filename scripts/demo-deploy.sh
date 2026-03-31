#!/bin/bash
set -e

# ============================================================
# APIOps Demo — Deploy
# Deploys gateway + portal + publishes API
# Usage: ./scripts/demo-deploy.sh <KONNECT_PAT> [REGION]
# ============================================================

if [ -z "$1" ]; then
  echo "Usage: $0 <KONNECT_PAT> [REGION]"
  echo "  KONNECT_PAT  - Kong Konnect Personal Access Token"
  echo "  REGION       - Konnect region (default: au)"
  exit 1
fi

TOKEN="$1"
REGION="${2:-au}"
URL="https://${REGION}.api.konghq.com"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║     Kong APIOps Demo — Deploy            ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Region:  $REGION"
echo "API URL: $URL"
echo ""

# ----------------------------------------------------------
# Step 1: Generate gateway resources from OAS spec
# ----------------------------------------------------------
echo "━━━ Step 1/4: Generate gateway resources (deck) ━━━"
cd "$REPO_ROOT/scripts"
bash generate_gateway_resources.sh
cd "$REPO_ROOT"
echo ""

# ----------------------------------------------------------
# Step 2: Deploy gateway via Terraform
# ----------------------------------------------------------
echo "━━━ Step 2/4: Deploy gateway (Terraform) ━━━"
cd "$REPO_ROOT/terraform"

# Write tfvars with token
cat > terraform.tfvars <<EOF
konnect_token      = "$TOKEN"
konnect_server_url = "$URL"
control_plane_name = "apiops-cp"
portal_name        = "se-tools-portal"
enable_portal_pages = true
tags = {
  managed_by  = "terraform"
  owner       = "Rami"
  project     = "kong-apiops-demo"
  environment = "production"
  team        = "APAC-SE"
}
EOF

terraform init -input=false
terraform apply -auto-approve
cd "$REPO_ROOT"
echo ""

# ----------------------------------------------------------
# Step 3: Deploy portal & publish API via kongctl
# ----------------------------------------------------------
echo "━━━ Step 3/4: Deploy portal & publish API (kongctl) ━━━"
kongctl apply -f portal.yaml --auto-approve --pat "$TOKEN" --region "$REGION"
echo ""

# ----------------------------------------------------------
# Step 4: Fix home page slug to / and get portal URL
# ----------------------------------------------------------
echo "━━━ Step 4/4: Configure portal home page ━━━"
PORTAL_ID=$(curl -s -H "Authorization: Bearer $TOKEN" "$URL/v3/portals" | \
  python3 -c "import sys,json; [print(p['id']) for p in json.load(sys.stdin)['data'] if p['name']=='rami-apiops-portal']")

if [ -n "$PORTAL_ID" ]; then
  HOME_ID=$(curl -s -H "Authorization: Bearer $TOKEN" "$URL/v3/portals/$PORTAL_ID/pages" | \
    python3 -c "import sys,json; [print(p['id']) for p in json.load(sys.stdin)['data'] if p.get('slug')=='/home']" 2>/dev/null)

  if [ -n "$HOME_ID" ]; then
    curl -s -X PATCH -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
      "$URL/v3/portals/$PORTAL_ID/pages/$HOME_ID" \
      -d '{"slug": "/"}' > /dev/null
    echo "Home page slug set to /"
  fi

  PORTAL_DOMAIN=$(curl -s -H "Authorization: Bearer $TOKEN" "$URL/v3/portals/$PORTAL_ID" | \
    python3 -c "import sys,json; print(json.load(sys.stdin)['default_domain'])")
else
  PORTAL_DOMAIN="(portal not found)"
fi

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║     Demo Deployed Successfully!          ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Portal URL:  https://$PORTAL_DOMAIN"
echo "APIs:        https://$PORTAL_DOMAIN/apis"
echo "Get Started: https://$PORTAL_DOMAIN/getting-started"
echo "GitHub:      https://github.com/rami-kong/APIOPS-2"
echo ""
