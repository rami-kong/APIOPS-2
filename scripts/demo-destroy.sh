#!/bin/bash
set -e

# ============================================================
# APIOps Demo — Destroy
# Tears down all resources (portal + gateway)
# Usage: ./scripts/demo-destroy.sh <KONNECT_PAT> [REGION]
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
echo "║     Kong APIOps Demo — Destroy           ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Region:  $REGION"
echo "API URL: $URL"
echo ""

# ----------------------------------------------------------
# Step 1: Destroy portal & APIs (kongctl resources)
# ----------------------------------------------------------
echo "━━━ Step 1/3: Destroy portal & APIs ━━━"

echo "Deleting APIs..."
for aid in $(curl -s -H "Authorization: Bearer $TOKEN" "$URL/v3/apis" | \
  python3 -c "import sys,json; [print(d['id']) for d in json.load(sys.stdin)['data']]" 2>/dev/null); do
  NAME=$(curl -s -H "Authorization: Bearer $TOKEN" "$URL/v3/apis/$aid" | \
    python3 -c "import sys,json; print(json.load(sys.stdin).get('name','?'))" 2>/dev/null)
  curl -s -X DELETE -H "Authorization: Bearer $TOKEN" "$URL/v3/apis/$aid" > /dev/null
  echo "  Deleted API: $NAME"
done

echo "Deleting kongctl-created portals..."
for pid in $(curl -s -H "Authorization: Bearer $TOKEN" "$URL/v3/portals" | \
  python3 -c "import sys,json; [print(d['id']) for d in json.load(sys.stdin)['data'] if d['name']=='rami-apiops-portal']" 2>/dev/null); do
  curl -s -X DELETE -H "Authorization: Bearer $TOKEN" "$URL/v3/portals/$pid" > /dev/null
  echo "  Deleted portal: rami-apiops-portal ($pid)"
done
echo ""

# ----------------------------------------------------------
# Step 2: Destroy gateway resources (Terraform)
# ----------------------------------------------------------
echo "━━━ Step 2/3: Destroy gateway (Terraform) ━━━"
cd "$REPO_ROOT/terraform"

# Ensure tfvars exists for destroy
if [ ! -f terraform.tfvars ]; then
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
fi

terraform init -input=false
terraform destroy -auto-approve 2>&1 || {
  echo "Terraform destroy failed — cleaning up gateway resources via API..."

  # Fallback: delete gateway resources via API
  CP_ID=$(curl -s -H "Authorization: Bearer $TOKEN" "$URL/v2/control-planes" | \
    python3 -c "import sys,json; [print(cp['id']) for cp in json.load(sys.stdin)['data'] if cp['name']=='apiops-cp']" 2>/dev/null)

  if [ -n "$CP_ID" ]; then
    for rid in $(curl -s -H "Authorization: Bearer $TOKEN" "$URL/v2/control-planes/$CP_ID/core-entities/routes" | \
      python3 -c "import sys,json; [print(d['id']) for d in json.load(sys.stdin)['data']]" 2>/dev/null); do
      curl -s -X DELETE -H "Authorization: Bearer $TOKEN" "$URL/v2/control-planes/$CP_ID/core-entities/routes/$rid" > /dev/null
    done
    for pid in $(curl -s -H "Authorization: Bearer $TOKEN" "$URL/v2/control-planes/$CP_ID/core-entities/plugins" | \
      python3 -c "import sys,json; [print(d['id']) for d in json.load(sys.stdin)['data']]" 2>/dev/null); do
      curl -s -X DELETE -H "Authorization: Bearer $TOKEN" "$URL/v2/control-planes/$CP_ID/core-entities/plugins/$pid" > /dev/null
    done
    for sid in $(curl -s -H "Authorization: Bearer $TOKEN" "$URL/v2/control-planes/$CP_ID/core-entities/services" | \
      python3 -c "import sys,json; [print(d['id']) for d in json.load(sys.stdin)['data']]" 2>/dev/null); do
      curl -s -X DELETE -H "Authorization: Bearer $TOKEN" "$URL/v2/control-planes/$CP_ID/core-entities/services/$sid" > /dev/null
    done
    echo "  Gateway resources cleaned via API"
  fi
}
cd "$REPO_ROOT"
echo ""

# ----------------------------------------------------------
# Step 3: Reset Terraform state
# ----------------------------------------------------------
echo "━━━ Step 3/3: Reset state ━━━"
cat > "$REPO_ROOT/terraform/terraform.tfstate" <<'EOF'
{
  "version": 4,
  "terraform_version": "1.14.8",
  "serial": 99999,
  "lineage": "80366db0-0655-ffda-4289-970cc32e41fd",
  "outputs": {},
  "resources": [],
  "check_results": null
}
EOF
echo "Terraform state reset"

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║     Demo Destroyed Successfully!         ║"
echo "╚══════════════════════════════════════════╝"
echo ""
