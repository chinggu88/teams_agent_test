---
name: testuram project controller patterns
description: GetX controller and binding conventions confirmed in testuram Flutter project
type: project
---

## Controller Patterns

- `static FeatureController get to => Get.find();` — singleton accessor 항상 포함
- 상태 변수: `final _x = value.obs;` + getter/setter 를 바로 아래 배치 (분리 금지)
- 모든 `.obs` 변수 선언 위에 한 줄 한국어 주석 필수
- `late final PageController pageController` — UI 컨트롤러는 `onInit`에서 초기화, `onClose`에서 dispose
- `GetStorage` 직접 주입 (Repository 없이 로컬 저장소 접근)
- `try-catch` + EasyLoadingService 패턴 (API 호출 시)

## Binding Patterns

- `Get.lazyPut<Controller>(() => Controller())` 단순 패턴
- 별도 import는 `../controllers/feature_controller.dart` 상대 경로 사용

## Import Paths

- Routes: `package:testuram/app/routes/app_pages.dart`
- GetStorage: `package:get_storage/get_storage.dart`
- 패키지명: `testuram`

## Docs Location

- `docs/controller/controller.md`, `docs/naming.md`, `docs/comment.md` — 초기 프로젝트에는 없을 수 있음
- 없을 경우 CLAUDE.md 규칙과 system prompt 패턴을 따른다

**Why:** 문서가 없는 초기 프로젝트에서도 일관된 패턴 적용을 위해 기록
**How to apply:** 문서 파일 read 실패 시 이 메모리를 기준으로 진행
