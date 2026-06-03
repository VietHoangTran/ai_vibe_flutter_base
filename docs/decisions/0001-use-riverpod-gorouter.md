# Decision 0001: Use Riverpod and GoRouter

## Status

Accepted

## Context

AI Vibe Flutter Base needs a predictable architecture that coding agents can follow without introducing competing state-management or navigation patterns.

## Decision

Use Riverpod for state management/dependency wiring and GoRouter for navigation.

## Consequences

- Feature code should use Riverpod providers/controllers.
- Navigation should be centralized in `lib/core/routing/`.
- Do not introduce GetX, GetIt, BLoC/Cubit, or another router unless explicitly approved.

## Alternatives considered

- GetX: rejected because it mixes routing/state/dependency patterns and conflicts with current base direction.
- GetIt/service locator: rejected to avoid hidden global dependencies.
- BLoC/Cubit: valid in other projects, but not the chosen convention for this base.

## Date

2026-06-03
