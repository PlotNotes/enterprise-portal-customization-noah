---
id: 2026-06-08-template-update-notice-test
published_at: 2026-06-08T15:00:00Z
title: Template update notice test
impact: recommended
summary: Test update used to verify Enterprise Portal template drift notices in Vendor Portal.
affects:
  - content setup
  - update notices
---

## What changed

Added a test-only update entry so Vendor Portal can display an upstream template update notice.

## Why it matters

This lets us verify the end-to-end notice flow without publishing an update in the vendor-facing template repo.

## Who should care

Internal testers validating Enterprise Portal v2 content template update notices.

## How to adopt

No vendor action is required. This file is only for testing the notice UI and acknowledgement endpoint.

## How to verify

Open Vendor Portal, load the Enterprise Portal content tab for a repo whose acknowledgement watermark is before this published_at value, and confirm the notice appears.
