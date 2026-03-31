:::page-section{fullWidth backgroundColor="#000933"}
::page-hero
---
fullWidth: true
textAlign: "center"
titleColor: "#ffffff"
titleFontSize: "clamp(36px, 5vw, 64px)"
titleFontWeight: "700"
descriptionColor: "#afb7c5"
descriptionFontSize: "20px"
textMaxWidth: "720px"
---

#title
Rami APIOps Developer Portal

#description
Explore, test, and integrate with our APIs. Built with Kong APIOps — where OpenAPI specs drive gateway configuration, developer portal, and documentation automatically.

#actions
::button{to="/apis" appearance="primary" size="large"}
Explore APIs
::
::button{to="/getting-started" appearance="outline" size="large"}
Get Started
::
::
:::

:::page-section{padding="60px 0"}
::container{textAlign="center" maxWidth="800px" margin="0 auto" padding="0 0 40px 0"}
## Why APIOps?

API lifecycle managed as code — from design to deployment to documentation.
::

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
title: "Spec-Driven"
---
OpenAPI specifications are the single source of truth. Change the spec, everything updates automatically.
:::

:::card
---
title: "Gateway as Code"
---
Kong Gateway services, routes, and plugins generated from specs using `deck` and deployed via Terraform.
:::

:::card
---
title: "Portal Publishing"
---
APIs are published to this Developer Portal with documentation, specs, and versioning via `kongctl`.
:::

::
:::

:::page-section{backgroundColor="#f9fafb" padding="60px 0"}
::container{textAlign="center" maxWidth="800px" margin="0 auto" padding="0 0 32px 0"}
## Available APIs
::

::apis-list
---
persist-page-number: true
cta-text: "View Documentation"
---
::
:::
