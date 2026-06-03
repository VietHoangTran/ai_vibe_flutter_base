# AI Vibe Coding Harness Proposal

> Tổng hợp đề xuất tham khảo từ `repository-harness` cho `AI Vibe Flutter Base`.
>
> Mục tiêu: biến repo thành một Flutter base thân thiện với AI coding/vibe coding, giúp AI hiểu scope, phân loại rủi ro, code đúng kiến trúc, kiểm chứng kết quả và ghi lại quyết định.

---

## 1. Tinh thần chính

`repository-harness` có một ý tưởng rất đáng học:

> App là thứ user dùng. Harness là thứ agent dùng.

Với `AI Vibe Flutter Base`, không nên kéo nguyên toàn bộ CLI/Rust/SQLite harness vào ngay. Thay vào đó nên làm một bản **Harness-lite** bằng Markdown + scripts + templates, nhẹ hơn và phù hợp Flutter hơn.

Harness-lite nên giúp AI trả lời 5 câu hỏi trước/sau khi code:

1. Task này thuộc loại gì?
2. Rủi ro thấp hay cao?
3. Phạm vi thay đổi nằm ở đâu?
4. Bằng chứng kiểm chứng là gì?
5. Có quyết định kiến trúc nào cần ghi lại không?

---

## 2. Những điểm nên học từ `repository-harness`

### 2.1. Feature intake trước khi code

AI không nên code ngay. Trước tiên nên phân loại request.

Đề xuất thêm:

```text
docs/ai/FEATURE_INTAKE.md
```

Phân loại task:

#### Tiny

Ví dụ:

- sửa text nhỏ
- docs
- đổi tên
- chỉnh UI rất nhỏ
- thêm file hướng dẫn

Cách xử lý:

- Có thể làm trực tiếp.
- Không cần story file.
- Vẫn phải chạy hoặc báo blocker cho quality checks.

#### Normal

Ví dụ:

- thêm screen
- thêm feature slice
- thêm repository/usecase/controller
- tích hợp API có scope rõ
- thêm shared widget có test

Cách xử lý:

- Nên kiểm tra pattern hiện có trước.
- Có thể tạo story nếu task nhiều bước.
- Cần validation rõ.

#### High-risk

Ví dụ:

- auth/session/token
- permission/security
- secure storage
- native Android/iOS config
- navigation-wide changes
- dependency upgrade lớn
- refactor nhiều feature
- thay đổi architecture convention

Cách xử lý:

- Cần hỏi lại nếu scope chưa rõ.
- Nên tạo story.
- Cần validation proof mạnh hơn.
- Nếu là decision kiến trúc, phải ghi decision log.

---

### 2.2. Validation proof thay vì chỉ nói “done”

Đề xuất thêm:

```text
docs/ai/VALIDATION_MATRIX.md
```

Validation matrix mẫu:

| Change type | Required proof |
| --- | --- |
| Docs-only | `git diff --check` |
| UI widget | widget test hoặc manual/screenshot note |
| Riverpod controller | provider test |
| Repository/data mapping | unit test với mocktail |
| Dio datasource | mocked API/Dio test nếu có logic |
| Routing | route test hoặc manual navigation proof |
| Localization | cập nhật toàn bộ ARB files |
| Native Android/iOS config | build command hoặc blocker rõ |
| Dependency change | `flutter pub get` + analyze + test |
| Generated code | `flutter gen-l10n` / `build_runner` |

Quality gate chuẩn:

```bash
flutter pub get
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
dart format --set-exit-if-changed .
dart analyze --fatal-infos --fatal-warnings
flutter test
```

Nếu môi trường không chạy được lệnh nào, AI phải báo rõ blocker.

---

### 2.3. Story packets cho task vừa/lớn

Đề xuất thêm:

```text
docs/stories/
docs/templates/story.md
```

Không cần story cho mọi task. Quy tắc:

- Tiny: không cần story.
- Normal: tạo story nếu feature nhiều bước hoặc behavior đáng kể.
- High-risk: bắt buộc story.

Template story nên gồm:

```md
# Story: <name>

## Intent

## Scope

## Out of scope

## Affected files/areas

## Architecture notes

## Validation proof

## Human decisions

## Completion notes
```

Lợi ích:

- AI không quên scope.
- Human dễ duyệt.
- Agent khác có thể tiếp tục task.

---

### 2.4. Decision log

Đề xuất thêm:

```text
docs/decisions/
docs/templates/decision.md
```

Base hiện tại đã có nhiều quyết định nên ghi lại:

1. Dùng Riverpod + GoRouter, không dùng GetX/GetIt.
2. Chỉ giữ Android + iOS.
3. Dùng Dart define files cho environment.
4. Dùng Flutter gen-l10n với `en`, `vi`, `ja`.
5. Dùng feature-first Clean Architecture.
6. Dùng Harness-lite bằng docs/scripts, chưa thêm CLI nặng.

Template decision:

```md
# Decision XXXX: <title>

## Status

Accepted | Proposed | Superseded

## Context

## Decision

## Consequences

## Alternatives considered
```

Lợi ích:

- AI sau này hiểu vì sao repo chọn stack này.
- Giảm khả năng AI tự thêm architecture khác.
- Dễ audit thay đổi lớn.

---

### 2.5. AGENTS.md nên là stable shim

Hiện `AGENTS.md` đã có rule tốt, nhưng nên hướng nó thành file điều hướng chính.

Đề xuất cấu trúc:

```md
# AGENTS.md

Read in order:

1. docs/ai/AI_CODING_GUIDE.md
2. docs/ai/FEATURE_INTAKE.md
3. docs/ai/VALIDATION_MATRIX.md
4. docs/ai/PATTERNS.md
5. docs/ai/ANTI_PATTERNS.md

Non-negotiables:

- Riverpod + GoRouter
- Android/iOS only
- No GetX/GetIt unless explicitly approved
- No generated file manual edits
- No hardcoded user-facing strings
- Run quality gate or report blocker
```

Lợi ích:

- Agent biết đọc gì trước.
- AGENTS.md không phình quá lớn.
- Docs chuyên biệt dễ mở rộng.

---

## 3. Bộ file nên thêm vào `AI Vibe Flutter Base`

Đề xuất cấu trúc:

```text
docs/
├── HARNESS.md
├── ai/
│   ├── AI_CODING_GUIDE.md
│   ├── FEATURE_INTAKE.md
│   ├── VALIDATION_MATRIX.md
│   ├── PATTERNS.md
│   ├── ANTI_PATTERNS.md
│   ├── PROMPTS.md
│   └── CHECKLIST.md
├── decisions/
│   ├── .gitkeep
│   ├── 0001-use-riverpod-gorouter.md
│   ├── 0002-android-ios-only.md
│   └── 0003-ai-harness-lite.md
├── stories/
│   └── .gitkeep
├── templates/
│   ├── story.md
│   ├── decision.md
│   └── validation-report.md
└── development/
    ├── ENVIRONMENTS.md
    ├── FEATURE_GENERATOR.md
    ├── TESTING.md
    ├── I18N.md
    └── DEPENDENCY_POLICY.md
```

Một số file đã tồn tại trong base hiện tại:

- `AGENTS.md`
- `docs/ai/AI_CODING_GUIDE.md`
- `docs/development/ENVIRONMENTS.md`
- `docs/development/FEATURE_GENERATOR.md`

Nên bổ sung thêm các file còn thiếu.

---

## 4. Scripts nên thêm

### 4.1. `scripts/generate.sh`

Mục tiêu: gom lệnh generate vào một nơi.

```bash
#!/usr/bin/env sh
set -eu

flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
```

### 4.2. `scripts/quality_check.sh`

Mục tiêu: AI/human chỉ cần chạy một command trước khi kết thúc task.

```bash
#!/usr/bin/env sh
set -eu

flutter pub get
scripts/generate.sh
dart format --set-exit-if-changed .
dart analyze --fatal-infos --fatal-warnings
flutter test
```

Lợi ích:

- AI không quên lệnh.
- CI/local đồng bộ hơn.
- Final answer có proof rõ.

---

## 5. Claude Code config

Vì project này dùng Claude Code để code, chỉ cần thêm:

```text
CLAUDE.md
```

### 5.1. `CLAUDE.md` mẫu

```md
# CLAUDE.md

Read `AGENTS.md` first.

Common commands:

- `scripts/generate.sh`
- `scripts/quality_check.sh`
- `dart run tools/feature_cli.dart <feature>`

Completion requirement:

- summarize files changed
- summarize commands run
- list blockers if any
```

---

## 6. Development docs nên bổ sung

### 6.1. `docs/development/TESTING.md`

Nội dung nên có:

- Widget test cho shared widgets/pages.
- Provider test với `ProviderContainer`.
- Repository test với mocktail.
- Khi nào cần test.
- Khi nào không cần test.

### 6.2. `docs/development/I18N.md`

Nội dung nên có:

- Thêm key vào `app_en.arb`, `app_vi.arb`, `app_ja.arb`.
- Không hardcode user-facing text.
- Dùng `context.l10n.key`.
- Chạy `flutter gen-l10n`.

### 6.3. `docs/development/DEPENDENCY_POLICY.md`

Nội dung nên có:

- Chỉ thêm dependency khi thực sự cần.
- Không thêm state management/router/http client khác.
- Phải giải thích lý do thêm dependency.
- Phải chạy `flutter pub get`, analyze, test.

### 6.4. `docs/development/ROUTING.md`

Nội dung nên có:

- Route names ở `route_names.dart`.
- Routes ở `app_router.dart`.
- Auth redirect pattern.
- Không hardcode path lung tung trong UI.

---

## 7. Pull request template

Đề xuất thêm:

```text
.github/pull_request_template.md
```

Template:

```md
## Summary

## Architecture impact

## Tests / validation

## AI checklist

- [ ] Followed AGENTS.md
- [ ] Classified task risk
- [ ] Updated localization if user-facing text changed
- [ ] Added/updated tests when logic changed
- [ ] Ran quality gates or documented blocker
- [ ] Added decision/story docs if needed
```

Lợi ích:

- PR từ AI/human rõ ràng hơn.
- Dễ review.
- Giảm merge các thay đổi thiếu proof.

---

## 8. Không nên áp dụng ngay

Không nên kéo nguyên những phần nặng từ `repository-harness` vào lúc này:

- Rust CLI
- SQLite durable layer
- Installer script
- Complex multi-agent orchestration

Lý do:

- Tăng complexity cho Flutter base.
- Chưa cần thiết ở giai đoạn template.
- Markdown + scripts đã đủ để hướng AI code tốt hơn.

Sau này nếu repo phát triển lớn, có thể cân nhắc CLI/harness đầy đủ.

---

## 9. Thứ tự triển khai đề xuất

Nếu triển khai Harness-lite, nên đi theo thứ tự:

1. `docs/HARNESS.md`
2. `docs/ai/FEATURE_INTAKE.md`
3. `docs/ai/VALIDATION_MATRIX.md`
4. `docs/ai/CHECKLIST.md`
5. `docs/ai/PATTERNS.md`
6. `docs/ai/ANTI_PATTERNS.md`
7. `docs/ai/PROMPTS.md`
8. `docs/templates/story.md`
9. `docs/templates/decision.md`
10. `docs/templates/validation-report.md`
11. `docs/decisions/0001-use-riverpod-gorouter.md`
12. `docs/decisions/0002-android-ios-only.md`
13. `docs/decisions/0003-ai-harness-lite.md`
14. `scripts/generate.sh`
15. `scripts/quality_check.sh`
16. `CLAUDE.md`
17. `.github/pull_request_template.md`

---

## 10. Đề xuất ngắn gọn

Nên triển khai **Harness-lite**, không triển khai full repository-harness.

Bản Harness-lite sẽ giúp `AI Vibe Flutter Base` trở thành base đúng nghĩa cho vibe coding:

- AI biết đọc gì trước.
- AI biết phân loại task.
- AI biết khi nào cần hỏi lại.
- AI biết bằng chứng kiểm chứng cần cung cấp.
- AI không tự ý đổi stack.
- AI ghi lại quyết định kiến trúc.
- Human dễ review hơn.

Nếu được duyệt, bước tiếp theo là thêm các file Markdown/scripts trên vào repo, commit và push.
