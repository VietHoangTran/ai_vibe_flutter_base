# Story: Close the auth token loop and add a refresh-on-401 seam

> This is a worked example of a filled-in story, based on real work shipped in
> commit `d6e9899`. Copy `docs/templates/story.md` for new stories and aim for
> this level of detail.

## Intent

`AuthInterceptor` read the access token from secure storage under
`auth.access_token`, but nothing in the auth flow ever wrote that key, so every
request went out unauthenticated. Close the loop (sign-in persists tokens,
sign-out clears them) and add an extension point for refresh-on-401 so future
API wiring does not have to design it from scratch.

## Scope

- Persist access/refresh tokens through an `AuthTokenStore` on sign-in.
- Clear tokens on sign-out.
- `TokenRefresher` seam with a no-op default plus a queued
  `RefreshTokenInterceptor` that retries a failed request once after refresh.
- Tests for the interceptors and exception mapper.

## Out of scope

- A real `/auth/refresh` endpoint (the base has no backend; the no-op default
  keeps 401 behavior unchanged).
- Session-expiry UX (forced logout, re-login dialog).
- Biometric or multi-account token storage.

## Risk classification

High-risk (auth/session/token work touches every authenticated request).

## Affected files/areas

- `lib/core/network/auth_token_store.dart` (new)
- `lib/core/network/auth_interceptor.dart`
- `lib/core/network/token_refresher.dart` (new)
- `lib/core/network/refresh_token_interceptor.dart` (new)
- `lib/core/network/dio_provider.dart`
- `lib/features/auth/data/` (remote datasource, repository impl, provider)
- `test/core/network/`

## Architecture notes

- Tokens flow through `authTokenStoreProvider`; feature code never touches
  raw secure storage keys.
- `RefreshTokenInterceptor` is a `QueuedInterceptor` so concurrent 401s share
  one refresh attempt; retries go through a bare Dio client to avoid recursive
  refresh loops.
- The remote sign-in returns a `SignInResult` record (user + tokens); the
  repository persists both before returning the domain entity.

## Human decisions

- Default `TokenRefresher` is a no-op rather than a thrown
  `UnimplementedError`, so the starter app keeps working without a backend.
- Refresh retries exactly once per request (`auth.retried` flag) — no retry
  budget/backoff until a real API demands it.

## Validation proof

Commands/tests/manual checks required:

- `scripts/quality_check.sh` — passed (format, analyze with fatal infos,
  full test suite).
- New tests: auth interceptor header behavior, refresh-retry success and
  401 propagation, exception mapper coverage.

## Completion notes

Shipped in `d6e9899`. Remaining follow-up: implement a real `TokenRefresher`
when the first authenticated API is wired, and decide session-expiry UX at
that point.
