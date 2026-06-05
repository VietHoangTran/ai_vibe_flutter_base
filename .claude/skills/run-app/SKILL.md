---
name: run-app
description: Boot the app on an iOS simulator or Android emulator, navigate to the changed screen, and capture a screenshot as proof. Use when the user asks to run the app, verify a screen visually, or attach UI proof to a task.
---

# /run-app — Live Run + Screenshot Proof

"Compiles" is not "looks right". Use this to verify a screen on a real
runtime and attach a screenshot to the final response.

## Steps

1. **Pick a device.**

   ```bash
   flutter devices
   # iOS: xcrun simctl list devices | grep Booted
   # boot one if needed: xcrun simctl boot "iPhone 16"; open -a Simulator
   # Android: emulator -list-avds; emulator -avd <name> &
   ```

2. **Run with the dev environment** (background, capture logs):

   ```bash
   scripts/flutter_dev.sh -d <device_id>
   ```

   Use the Bash tool's `run_in_background`; watch output until
   "Flutter run key commands" or an error appears.

3. **Navigate to the target screen.** Default boot lands on the auth flow.
   If the screen is behind navigation, either use the route directly in a
   debug entrypoint or step through the UI on the simulator.

4. **Screenshot.**

   ```bash
   # iOS simulator
   xcrun simctl io booted screenshot /tmp/run_app_<screen>.png
   # Android
   adb exec-out screencap -p > /tmp/run_app_<screen>.png
   ```

   Read the screenshot file to visually confirm it matches the expectation
   (and the Figma reference if the task came from `/figma-screen`).

5. **Smoke checks while running:** no red error screen, no uncaught
   exceptions in logs, offline banner behaves if connectivity matters.

6. **Stop the app** (`q` to the flutter process or kill it) and report:
   device used, screenshot path, what was visually confirmed.

## Integration test alternative

For repeatable boot verification without manual navigation:

```bash
flutter test integration_test -d <device_id>
```

See `integration_test/app_smoke_test.dart`.

## Blockers

No simulator/emulator available → report exactly that, with the commands a
human should run, per `docs/ai/VALIDATION_MATRIX.md`.
