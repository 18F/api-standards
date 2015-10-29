---
title: "API Keys"
permalink: /api-keys/
---

These standards do not take a position on whether or not to use API keys.

But _if_ keys are used to manage and authenticate API access, the API should allow some sort of unauthenticated access, without keys.

This allows newcomers to use and experiment with the API in demo environments and with simple `curl`/`wget`/etc. requests.

Consider whether one of your product goals is to allow a certain level of normal production use of the API without enforcing advanced registration by clients.

