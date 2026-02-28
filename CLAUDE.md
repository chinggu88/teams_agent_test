# Flutter Team Agent - Project Guide

## 프로젝트 개요

Flutter MVC 패턴 기반 프로젝트. GetX를 사용한 상태 관리, 라우팅, 의존성 주입을 수행한다.

## 기술 스택

- **Flutter / Dart** - UI 프레임워크
- **GetX** - 상태 관리, 라우팅, DI
- **Dio** - HTTP 클라이언트
- **Firebase** - FCM 푸시 알림
- **ScreenUtil** - 반응형 UI (.w, .h, .sp, .r)
- **GetStorage** - 로컬 저장소
- **EasyLoading** - 로딩/토스트

## 아키텍처 (MVC + GetX)

```
View (GetView + Obx) → Controller (GetxController + .obs) → Repository → ApiService (Dio) → REST API
```

### 폴더 구조

```
lib/
├── app/
│   ├── bindings/          # 글로벌 바인딩
│   ├── routes/            # 라우트 관리
│   ├── modules/           # 기능별 모듈 (MVC)
│   │   └── {feature}/
│   │       ├── bindings/
│   │       ├── controllers/
│   │       └── views/
│   ├── data/
│   │   ├── models/        # API 모델
│   │   └── repositories/  # API 레포지토리
│   ├── core/
│   │   ├── enums/
│   │   ├── values/        # AppColors, AppTextStyles, strings
│   │   ├── theme/
│   │   └── utils/
│   └── widgets/           # 재사용 위젯
├── services/              # 글로벌 서비스 (GetxService)
└── main.dart
```

## 네이밍 규칙

| 대상 | 규칙 | 예시 |
|------|------|------|
| 클래스 | PascalCase | `HomeController`, `UserModel` |
| 함수/변수 | camelCase | `fetchUserData()`, `userName` |
| 상수 | UPPER_SNAKE_CASE | `MAX_USER_COUNT` |
| 파일/폴더 | snake_case | `home_controller.dart` |

## 제약 조건

- main 브랜치에 직접 커밋 금지
- 기존 API 인터페이스 변경 금지
- 외부 의존성 추가 시 팀 리드 승인 필요
- View에 비즈니스 로직 금지 - Controller로 위임
- API 직접 호출 금지 - Repository/Service 경유

## 참조 문서

| 문서 | 경로 |
|------|------|
| 프로젝트 구조 | docs/architecture.md |
| MVC 패턴 | docs/mvc.md |
| 네이밍 기준 | docs/naming.md |
| 주석 기준 | docs/comment.md |
| 모델 가이드 | docs/api/MODEL_GUIDE.md |
| 레포지토리 가이드 | docs/api/REPOSITORY_GUIDE.md |
| 서비스 가이드 | docs/api/SERVICE_GUIDE.md |
| 컨트롤러 가이드 | docs/controller/controller.md |
| 화면 가이드 | docs/widget/screen.md |
| 팀 구성 | flutter_teams.md |
| 태스크 목록 | docs/task/TASKS.md |

## 팀 에이전트 워크플로우

```
사용자 요청 → /task-create → /team-lead → (API → Controller → UI) → /architecture-update
```

### 사용 가능한 커맨드

| 커맨드 | 역할 | 설명 |
|--------|------|------|
| `/task-create` | Task Creator | 사용자 입력 수집 → TASKS.md 생성 |
| `/team-lead` | 팀 리드 | TASKS.md 읽기 → 서브 Agent에게 작업 분배 및 실행 |
| `/api-agent` | API Agent | models, repositories 생성 |
| `/controller-agent` | Controller Agent | controllers, bindings 생성 |
| `/ui-agent` | UI Agent | views, widgets 생성 |
| `/architecture-update` | Architecture Updater | docs/architecture.md 업데이트 |
