# Decision 0002: Support Android and iOS Only

## Status

Accepted

## Context

The base is intended for mobile Flutter projects. Extra platform folders increase maintenance and give AI agents more surfaces to edit incorrectly.

## Decision

Keep only Android and iOS platform folders.

## Consequences

- Supported platforms: Android, iOS.
- Do not add web, Linux, macOS, or Windows unless explicitly requested.
- CI/build scripts should focus on mobile outputs.

## Alternatives considered

- Keep all Flutter platforms: rejected to reduce noise and maintenance.
- Add web support by default: rejected because it is not part of the intended mobile base.

## Date

2026-06-03
