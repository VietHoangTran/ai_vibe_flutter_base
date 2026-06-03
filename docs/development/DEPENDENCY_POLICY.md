# Dependency Policy

Keep the base lightweight and predictable for AI coding.

## Before Adding a Dependency

Check:

- Can Flutter/Dart already do this?
- Does an existing dependency already cover it?
- Is the package maintained?
- Does it conflict with Riverpod/GoRouter/Dio conventions?
- Will it require native Android/iOS setup?
- Can it be tested easily?

## Not Allowed Without Explicit Approval

- another state-management package
- another router
- another HTTP client
- service locator/global dependency framework
- broad code generation frameworks that change architecture

## After Adding a Dependency

Run:

```bash
flutter pub get
dart analyze --fatal-infos --fatal-warnings
flutter test
```

Document why the dependency was added in the final summary or PR.
