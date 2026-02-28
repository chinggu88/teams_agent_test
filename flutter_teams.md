
## 프로젝트 개요

flutter를 위한 에이전트 팀을 생성해줘.

**목표**: mvc패턴으로 일관된 코드 스타일을 생성하는 것

**작업 범위**: 실행하는 프로젝트 디렉토리 모든 범위

**기술 스택**: flutter, dart

**제약 조건**:
- [예: main 브랜치에 직접 커밋 금지, 기존 API 인터페이스 변경 금지]
- [예: 외부 의존성 추가 시 팀 리드 승인 필요]

---

## 공통 참조 문서

> 모든 팀원이 작업 시작 전 반드시 읽어야 하는 문서

| 문서 | 경로 | 설명 |
|------|------|------|
| 프로젝트 구조 | docs/architecture.md | 프로젝트의 전체 구조를 폴더 기준 분류하고 파일의 설명을 기록 |
| 주석 사용 기준 | docs/comment.md | 주석을 사용한 방법을 기록 |
| 아키텍쳐 구조 | docs/mvc.md | 공통 패키지 명과 데이터 흐름 |
| 네이밍 기준 | docs/naming.md | 폴더,파일,변수 생성 기준을 기록 |

---

## 실행 순서 (Workflow)

```
[사용자 요청]
     ↓
┌─────────────────────────────────────────────────────────────┐
│ 1. Task Creator Agent (최초 실행)                             │
│    - 사용자 입력 수집 → TASKS.md 생성                            │
└─────────────────────────────────────────────────────────────┘
     ↓
┌─────────────────────────────────────────────────────────────┐
│ 2. 팀 리드 (Team Lead)                                        │
│    - TASKS.md 읽기 → 서브 Agent에게 작업 분배                     │
└─────────────────────────────────────────────────────────────┘
     ↓
┌─────────────────────────────────────────────────────────────┐
│ 3. 서브 Agent 작업 (의존성 순서대로)                              │
│    API Agent → Controller Agent → UI Agent                  │
└─────────────────────────────────────────────────────────────┘
     ↓
┌─────────────────────────────────────────────────────────────┐
│ 4. Architecture Updater Agent (최종 실행)                     │
│    - 모든 작업 완료 후 docs/architecture.md 업데이트              │
└─────────────────────────────────────────────────────────────┘
```

---

## 팀 구성

### 팀 리드 (Lead)

- **역할**: 전체 조율, 태스크 분배, 결과 종합, 품질 검증
- **모델**: opus
- **모드**: delegate (코드 직접 수정 금지, 조율만 수행)
- **트리거**: Task Creator Agent가 TASKS.md 생성 완료 후 실행
- **책임**:
    - **TASKS.md 읽기** → 작업 분배 섹션 확인
    - 서브 Agent에게 태스크 할당 (의존성 순서: API → Controller → UI)
    - 코드 리뷰 시 아키텍처 패턴 준수 여부 확인
    - 폴더 구조 강제:
        lib/
        ├── views/          # UI Agent 담당
        ├── controllers/    # Controller Agent 담당
        ├── services/       # API Agent 담당
        ├── models/         # API Agent 담당
        └── utils/
    - 팀원 간 작업 충돌 방지
    - 태스크 진행 상황 모니터링
    - **모든 서브 Agent 완료 후** → Architecture Updater Agent 호출
    - 최종 결과물 통합 및 검증

---

### UI Agent

- **담당 영역**: */views/*_view.dart,*/widgets/*.dart
- **모델**: sonnet
- **권한**: 읽기+쓰기
- **핵심 지시**:
    - 모든 위젯은 StatelessWidget 우선, 상태 필요시 Controller 연결
    - ScreenUtil 필수 적용: .w, .h, .sp, .r
    - 색상은 AppColors, 텍스트는 AppTextStyles 사용
    - 위젯 파일명: feature_screen.dart, feature_widget.dart
    - 비즈니스 로직 절대 금지 - Controller로 위임
    - 재사용 위젯은 lib/views/widgets/common/ 에 배치

**참조 문서**:

| 문서 | 경로 | 읽는 시점 | 용도 |
|------|------|-----------|------|
| widget 코드 템플릿 | docs/widget/screen.md | 작업 시작 전 | 기본 베이스 화면 구조

---

### Controller Agent

- **역할**: 비즈니스 로직 및 상태 관리 전담
- **담당 영역**: */controller/*_controller.dart
- **모델**: sonnet
- **권한**: 읽기+쓰기
- **핵심 지시**:
    - GetX 패턴 사용: extends GetxController
    - 상태 변수는 .obs, 메서드는 명확한 동사 사용
    - API 호출은 직접 X → Service 클래스 주입받아 사용
    - 파일명: feature_controller.dart
    - 에러 처리 필수: try-catch + 사용자 피드백

**참조 문서**:

| 문서 | 경로 | 읽는 시점 | 용도 |
|------|------|-----------|------|
| controller 코드 템플릿 | docs/controller/controller.md | 작업 시작 전 | controller파일 작성 규칙

---

### API Agent

- **담당 영역**: [예: tests/, e2e/ 디렉토리]
- **모델**: sonnet
- **권한**: 읽기+쓰기
- **핵심 지시**:
    - Dio 클라이언트 사용, BaseService 상속
    - 파일명: feature_service.dart
    - 모든 API 응답은 Model로 변환하여 반환
    - 엔드포인트는 상수로 관리: ApiEndpoints 클래스
    - 에러는 커스텀 Exception으로 래핑

**참조 문서**:

| 문서 | 경로 | 읽는 시점 | 용도 |
|------|------|-----------|------|
| 모델생성 가이드 | docs/api/MODEL_GUIDE | 생성 필요 시 | 모델 생성 규칙 |
| api생성 가이드 | docs/api/REPOSITORY_GUIDE | 생성 필요 시 | api 함수 생성 규칙 |

---

### Architecture Updater Agent

- **역할**: 작업 완료 후 프로젝트 구조 문서 자동 업데이트
- **담당 영역**: docs/architecture.md
- **모델**: haiku
- **권한**: 읽기+쓰기
- **실행 순서**: **4번째 (최종)** - 모든 서브 Agent 작업 완료 후
- **트리거**: 팀 리드가 모든 작업 완료 확인 후 호출
- **핵심 지시**:
    - lib/ 폴더 구조를 스캔하여 현재 상태 파악
    - 새로 생성된 파일/폴더를 architecture.md에 추가
    - 삭제된 파일/폴더를 architecture.md에서 제거
    - 기존 포맷 유지: 트리 구조 + 주석 설명
    - 파일별 한 줄 설명 추가 (파일명 기반 추론)

**출력 포맷**:
```
lib/
├── 폴더명/                    # [카테고리] 설명
│   ├── 하위폴더/              # [하위카테고리] 설명
│   │   └── 파일명.dart        # 파일 역할 설명
```

**작업 순서**:
1. `lib/` 폴더 구조 스캔 (Glob 사용)
2. 기존 `docs/architecture.md` 읽기
3. 변경사항 비교 (추가/삭제된 파일)
4. 포맷에 맞춰 업데이트
5. 변경 내용 요약 보고

**참조 문서**:

| 문서 | 경로 | 읽는 시점 | 용도 |
|------|------|-----------|------|
| 현재 구조 | docs/architecture.md | 작업 시작 전 | 기존 포맷 및 설명 참고 |
| 네이밍 기준 | docs/naming.md | 설명 작성 시 | 파일명 규칙으로 역할 추론 |

---

### Task Creator Agent

- **역할**: 사용자 입력을 받아 TASKS.md에 태스크 생성
- **담당 영역**: docs/task/TASKS.md
- **모델**: opus
- **권한**: 읽기+쓰기
- **실행 순서**: **1번째 (최초)** - 사용자 요청 직후 가장 먼저 실행
- **트리거**: 사용자 요청 시 ("새 태스크 추가", "기능 태스크 생성")
- **완료 후**: ./TASKS.md 생성 → 팀 리드에게 작업 분배 요청
- **핵심 지시**:
    - 기존 TASKS.md를 읽어 다음 태스크 ID 자동 결정 (TASK-002, TASK-003...)
    - 사용자로부터 필수 정보 수집 (기능명, 디자인, 기능정의, API정보)
    - 사용자 흐름(User Flow) 다이어그램 생성
    - flutter_teams.md 기준으로 Agent별 파일 경로 자동 분배
    - TASKS.md 포맷에 맞춰 태스크 추가

**입력 수집**:
| 항목 | 설명 | 예시 |
|------|------|------|
| 기능명 | 태스크 제목 | 로그인 기능 |
| 디자인 | Figma URL 또는 파일 경로 | docs/designs/login.png |
| 기능 정의 | 기능, 설명, 트리거 목록 | 이메일 검증 / 형식 확인 / 입력 시 |
| API 정보 | Method, Endpoint, Request/Response | POST /auth/login |

**작업 분배 규칙**:
```
API Agent      → lib/app/data/models/, lib/app/data/repositories/
Controller Agent → lib/app/modules/{feature}/controllers/, bindings/
UI Agent       → lib/app/modules/{feature}/views/
```

**작업 순서**:
1. 기존 `docs/task/TASKS.md` 읽기 (태스크 ID 확인)
2. 사용자로부터 입력 수집
3. 사용자 흐름 다이어그램 생성
4. Agent별 파일 경로 결정
5. TASKS.md에 새 태스크 추가

**참조 문서**:

| 문서 | 경로 | 읽는 시점 | 용도 |
|------|------|-----------|------|
| 태스크 목록 | docs/task/TASKS.md | 작업 시작 전 | 기존 태스크 ID 확인 및 포맷 참고 |
| 팀 구성 | flutter_teams.md | 파일 분배 시 | Agent별 담당 영역 확인 |

---

## 소통 규칙

### 메시지 패턴

- **진행 보고**: 각 팀원은 태스크 시작과 완료 시 리드에게 write로 보고
- **도움 요청**: 막히면 즉시 리드에게 메시지, 혼자 30초 이상 고민하지 말 것
- **발견 공유**: 다른 팀원에게 영향을 주는 발견이 있으면 해당 팀원에게 직접 write
- **broadcast 사용**: 전체 설계 변경 등 모든 팀원이 알아야 할 사항에만 사용 (비용 높음)


### 보고 형식

팀원이 리드에게 보고할 때 다음 형식을 사용:

```
[상태] 완료 / 진행중 / 차단됨
[요약] 한 줄 요약
[상세] (필요 시) 상세 내용
[다음] 다음에 할 작업 또는 필요한 것
```

---

> **팀 생성을 시작해줘.**