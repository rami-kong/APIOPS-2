:::page-section{backgroundColor="#000933" padding="48px 0"}
::page-hero
---
textAlign: "center"
titleColor: "#ffffff"
titleFontSize: "clamp(28px, 4vw, 48px)"
titleFontWeight: "700"
descriptionColor: "#afb7c5"
descriptionFontSize: "18px"
textMaxWidth: "640px"
---

#title
Getting Started

#description
Follow these steps to explore and integrate with our APIs in minutes.
::
:::

:::page-section{padding="60px 0"}
::multi-column
---
columns: 3
gap: "24px"
gridColumnsBreakpoints:
  mobile: 1
  tablet: 3
---

:::card
---
title: "1. Browse the API Catalog"
---
Head to the [API Catalog](/apis) to discover available APIs. Each API includes a downloadable OpenAPI spec you can use to generate client SDKs.
:::

:::card
---
title: "2. Read the Documentation"
---
Click into any API to view endpoint details, request/response examples with real tested outputs, authentication requirements, and rate limits.
:::

:::card
---
title: "3. Test the Endpoints"
---
Copy the `curl` examples below and run them in your terminal. Every example has been verified and returns real responses.
:::

::
:::

:::page-section{backgroundColor="#f9fafb" padding="60px 0"}
::container{maxWidth="720px" margin="0 auto"}

## Test the Echo API

### GET /anything

Returns metadata about your request — headers, query params, origin IP, and method.

```bash
curl -s "https://httpbin.org/anything?source=apiops-portal&demo=true" | jq .
```

**Response:**
```json
{
  "args": {
    "demo": "true",
    "source": "apiops-portal"
  },
  "headers": {
    "Accept": "*/*",
    "Host": "httpbin.org",
    "User-Agent": "curl/8.7.1"
  },
  "method": "GET",
  "origin": "203.123.65.132",
  "url": "https://httpbin.org/anything?source=apiops-portal&demo=true"
}
```

### POST /post

Echoes back your JSON payload. Great for testing POST requests and validating content types.

```bash
curl -s -X POST "https://httpbin.org/post" \
  -H "Content-Type: application/json" \
  -d '{"message": "Hello from Rami APIOps", "demo": true}' | jq .json
```

**Response:**
```json
{
  "demo": true,
  "message": "Hello from Rami APIOps"
}
```

::
:::

:::page-section{padding="60px 0"}
::container{textAlign="center" maxWidth="640px" margin="0 auto"}

## APIOps Workflow

This portal is powered by an end-to-end APIOps pipeline:

1. **Design** — Author OpenAPI specs with Kong extensions (`x-kong-name`, `x-kong-plugin-*`)
2. **Generate** — `deck` converts specs to Kong gateway config and Terraform
3. **Deploy** — Terraform provisions services, routes, and plugins on Kong Konnect
4. **Publish** — `kongctl` creates this portal with API docs and specs
5. **Automate** — GitHub Actions runs the full pipeline on every push

All source code: [github.com/rami-kong/APIOPS-2](https://github.com/rami-kong/APIOPS-2)

::button{to="/apis" appearance="primary"}
Explore APIs
::
::
:::
