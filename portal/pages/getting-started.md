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
Head to the [API Catalog](/apis) to discover available APIs. Each API includes an OpenAPI spec you can download or use to generate client SDKs.
:::

:::card
---
title: "2. Read the Documentation"
---
Click into any API to view endpoint details, request/response examples, authentication requirements, and rate limits.
:::

:::card
---
title: "3. Test the Endpoints"
---
Use `curl` or your favorite HTTP client to test endpoints directly. Check the API docs for ready-to-use examples.
:::

::
:::

:::page-section{backgroundColor="#f9fafb" padding="60px 0"}
::container{maxWidth="720px" margin="0 auto"}

## Quick Test

Try the Echo API right now:

```bash
# GET /anything — returns request metadata
curl -s "https://httpbin.org/anything?source=apiops-portal" | jq .
```

```bash
# POST /post — echoes back your payload
curl -s -X POST "https://httpbin.org/post" \
  -H "Content-Type: application/json" \
  -d '{"message": "Hello from APIOps"}' | jq .json
```

::
:::

:::page-section{padding="60px 0"}
::container{textAlign="center" maxWidth="640px" margin="0 auto"}

## APIOps Workflow

This portal is powered by an end-to-end APIOps pipeline:

1. **Design** — Author OpenAPI specs with Kong extensions
2. **Generate** — `deck` converts specs to Kong gateway config and Terraform
3. **Deploy** — Terraform provisions gateway services, routes, and plugins on Kong Konnect
4. **Publish** — `kongctl` creates this portal, publishes APIs with docs and specs

All automated via [GitHub Actions](https://github.com/rami-kong/APIOPS-2).

::button{to="/apis" appearance="primary"}
Explore APIs
::
::
:::
